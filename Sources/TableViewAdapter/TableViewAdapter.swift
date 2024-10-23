//
//  TableViewAdapter.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//
import UIKit

// MARK: - TableViewAdapter
public class TableViewAdapter: NSObject {
    public var isDebugMode: Bool = false
    public static let CHECK_Y_MORE_SIZE: CGFloat = UISCREEN_HEIGHT * 4
    public static let CHECK_X_MORE_SIZE: CGFloat = UISCREEN_WIDTH * 2

    private var checkBeforeHeight: CGFloat = 0.0
    private var checkBeforeHeightIndex: Int = -1
    private var isCheckBeforeHeight = false
    weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }

    var didScrollCallback: [ScrollViewCallback] = []
    var willBeginDraggingCallback: [ScrollViewCallback] = []
    var didEndDeceleratingCallback: [ScrollViewCallback] = []

    var data: TableViewAdapterData?
    var hasNext: Bool = false
    var requestNextClosure: (() -> Void)?

    var isUsedCacheSize: Bool = true
    var cacheSize = [Int: [Int: CGFloat]]()


    @discardableResult
    func checkMoreData(_ collecttionView: UITableView) -> Bool {
        guard let tableView else { return hasNext }
        guard hasNext else { return hasNext }

        let checkXY = tableView.contentSize.height - TableViewAdapter.CHECK_Y_MORE_SIZE
        let position = tableView.contentOffset.y + tableView.frame.size.height

        if position >= checkXY || checkXY <= 0 {
            hasNext = false
            DispatchQueue.main.async {
                self.requestNextClosure?()
            }
        }
        return hasNext
    }

    func getCellInfo(_ indexPath: IndexPath) -> TableViewAdapterData.CellInfo? {
        guard let data = self.data else { return nil }
        var checkCellInfo: TableViewAdapterData.CellInfo?
        if let cellInfo = data.sectionList[safe: indexPath.section]?.cells[safe: indexPath.row] {
            checkCellInfo = cellInfo
        }
        return checkCellInfo
    }

    // FOR YOU 그만볼래요 처럼 섹션, 셀 삭제 상황을 위해 기능 구현 by. iSunSoo.
    private func checkCellIndexPath(_ cellInfo: TableViewAdapterData.CellInfo) -> IndexPath? {
        guard let data = self.data else { return nil }
        for (sectionIndex, section) in data.sectionList.enumerated() {
            for (cellIndex, cell) in section.cells.enumerated() {
                if cell === cellInfo {
                    return IndexPath(row: cellIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }

    func removeCellInfo(in tableView: UITableView, cellInfo: TableViewAdapterData.CellInfo) {
        guard let data = self.data else { return }
        // 해당 cellInfo에 속해있는 item이 오직 1개라면 해당 section까지 지운다.
        if let indexPath = checkCellIndexPath(cellInfo) {
            if data.sectionList[indexPath.section].cells.count <= 1 {
                tableView.performBatchUpdates {
                    data.sectionList.remove(at: indexPath.section)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
            }
            else {
                tableView.performBatchUpdates {
                    data.sectionList[safe: indexPath.section]?.cells.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    func registerCell(in collectionView: UITableView) {
        guard let data else { return }
        guard data.sectionList.count > 0 else { return }

        for (sectionInfo) in data.sectionList {
            if let header = sectionInfo.header {
                collectionView.registerHeader(header.cellType)
            }
            if let footer = sectionInfo.footer {
                collectionView.registerFooter(footer.cellType)
            }
            if sectionInfo.cells.count > 0 {
                for (cell) in sectionInfo.cells {
                    collectionView.register(cell.cellType)
                }
            }
        }
    }
}

extension TableViewAdapter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let data else { return 0 }
        checkBeforeHeight = -1
        checkBeforeHeightIndex = -1
        registerCell(in: tableView)

        if data.sectionList.count == 0 && hasNext {
//            hasNext = false
            requestNextClosure?()
        }

        return data.sectionList.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data else { return 0 }
        guard let sectionInfo = data.sectionList[safe: section] else { return 0 }
        return sectionInfo.cells.count
    }
}

extension TableViewAdapter: UITableViewDelegate {
    //MARK: - UITableViewDelegate - Cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func defaultReturn() -> UITableViewCell { return UITableViewCell() }
        guard let cellInfo = self.getCellInfo(indexPath) else { return defaultReturn() }
        defer {
            checkMoreData(tableView)
        }

        let cell = tableView.dequeueReusableCell(cellInfo.cellType, for: indexPath)
        cell.parentTableView = tableView
        cell.indexPath = indexPath

        if let cell = cell as? TableViewAdapterCellProtocol {
            cell.actionClosure = cellInfo.actionClosure
            cell.configure(data: cellInfo.contentObj,
                           subData: cellInfo.subData,
                           tableView: tableView,
                           indexPath: indexPath,
                           actionClosure: cellInfo.actionClosure)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellInfo = self.getCellInfo(indexPath) else { return 0 }

        if self.isUsedCacheSize, let size = self.cacheSize[indexPath.section]?[indexPath.row] {
            return size
        }

        var size: CGFloat = 0
        if let sizeClosure = cellInfo.sizeClosure {
            size = sizeClosure()
        }
        else {
            size = cellInfo.cellType.getSize(data: cellInfo.contentObj,
                                             width: tableView.frame.size.width,
                                             tableView: tableView,
                                             indexPath: indexPath)
        }

        if self.isUsedCacheSize {
            if var sectionDic = self.cacheSize[indexPath.section] {
                sectionDic[indexPath.row] = size
                self.cacheSize[indexPath.section] = sectionDic
            }
            else {
                self.cacheSize[indexPath.section] = [indexPath.row: size]
            }
        }
        return size
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow( at: indexPath) as? TableViewAdapterCellProtocol {
            cell.didSelect(tableView: tableView, indexPath: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TableViewAdapterCellProtocol {
            cell.willDisplay(tableView: tableView, indexPath: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TableViewAdapterCellProtocol {
            cell.didEndDisplaying(tableView: tableView, indexPath: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow( at: indexPath) as? TableViewAdapterCellProtocol {
            cell.didHighlight(tableView: tableView, indexPath: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow( at: indexPath) as? TableViewAdapterCellProtocol {
            cell.didUnhighlight(tableView: tableView, indexPath: indexPath)
        }
    }

    //MARK: - UITableViewDelegate - Header Footer
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let cellInfo = self.data?.sectionList[safe: section]?.header else { return 0 }
        var size: CGFloat = 0
        if let sizeClosure = cellInfo.sizeClosure {
            size = sizeClosure()
        }
        else {
            size = cellInfo.cellType.getSize(data: cellInfo.contentObj,
                                             width: tableView.frame.size.width,
                                             tableView: tableView,
                                             indexPath: IndexPath(row: 0, section: section))
        }
        return size
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let cellInfo = self.data?.sectionList[safe: section]?.footer else { return 0 }
        var size: CGFloat = 0
        if let sizeClosure = cellInfo.sizeClosure {
            size = sizeClosure()
        }
        else {
            size = cellInfo.cellType.getSize(data: cellInfo.contentObj,
                                             width: tableView.frame.size.width,
                                             tableView: tableView,
                                             indexPath: IndexPath(row: 0, section: section))
        }
        return size
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cellInfo = self.data?.sectionList[safe: section]?.header else { return UIView() }
        defer {
            checkMoreData(tableView)
        }

        let cell = tableView.dequeueReusableHeader(cellInfo.cellType, for: IndexPath(row: 0, section: section))
        cell.parentTableView = tableView
        cell.indexPath = IndexPath(row: 0, section: section)

        if let cell = cell as? TableViewAdapterHeaderFooterProtocol {
            cell.actionClosure = cellInfo.actionClosure
            cell.configure(data: cellInfo.contentObj,
                           subData: cellInfo.subData,
                           tableView: tableView,
                           indexPath: IndexPath(row: 0, section: section),
                           actionClosure: cellInfo.actionClosure)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cellInfo = self.data?.sectionList[safe: section]?.footer else { return UIView() }
        defer {
            checkMoreData(tableView)
        }

        let cell = tableView.dequeueReusableFooter(cellInfo.cellType, for: IndexPath(row: 0, section: section))
        cell.parentTableView = tableView
        cell.indexPath = IndexPath(row: 0, section: section)

        if let cell = cell as? TableViewAdapterHeaderFooterProtocol {
            cell.actionClosure = cellInfo.actionClosure
            cell.configure(data: cellInfo.contentObj,
                           subData: cellInfo.subData,
                           tableView: tableView,
                           indexPath: IndexPath(row: 0, section: section),
                           actionClosure: cellInfo.actionClosure)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = tableView.headerView(forSection: section) as? TableViewAdapterHeaderFooterProtocol {
            view.willDisplay(tableView: tableView, indexPath: IndexPath(row: 0, section: section))
        }
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let view = tableView.footerView(forSection: section) as? TableViewAdapterHeaderFooterProtocol {
            view.willDisplay(tableView: tableView, indexPath: IndexPath(row: 0, section: section))
        }
    }


    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let view = tableView.headerView(forSection: section) as? TableViewAdapterHeaderFooterProtocol {
            view.didEndDisplaying(tableView: tableView, indexPath: IndexPath(row: 0, section: section))
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let view = tableView.footerView(forSection: section) as? TableViewAdapterHeaderFooterProtocol {
            view.didEndDisplaying(tableView: tableView, indexPath: IndexPath(row: 0, section: section))
        }
    }
}

//MARK: - UIScrollViewDelegate
extension TableViewAdapter: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x = \(scrollView.contentOffset.x)")
        guard scrollView.contentSize != .zero else { return }
        guard let scrollView = scrollView as? UICollectionView else { return }
        for callback in self.didScrollCallback {
            callback(scrollView)
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        for callback in self.willBeginDraggingCallback {
            callback(scrollView)
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging willDecelerate = \(decelerate)")
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
        for callback in self.didEndDeceleratingCallback {
            callback(scrollView)
        }
    }
}

extension Array {
    subscript(safe index: Int?) -> Element? {
        guard let index = index else { return nil }
        if indices.contains(index) {
            return self[index]
        }
        else {
            return nil
        }
    }
}

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
