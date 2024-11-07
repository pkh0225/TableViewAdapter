//
//  TableView+Adapter.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//
import UIKit

// MARK: - UICollectionView Extension
extension UITableView {
    private struct AssociatedKeys {
        static var tableViewAdapter: UInt8 = 0
    }

    public var adapter: TableViewAdapter {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociatedKeys.tableViewAdapter) as? TableViewAdapter {
                return obj
            }
            let obj = TableViewAdapter()
            obj.tableView = self
            objc_setAssociatedObject(self, &AssociatedKeys.tableViewAdapter, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return obj
        }
        set {
            newValue.tableView = self
            objc_setAssociatedObject(self, &AssociatedKeys.tableViewAdapter, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var adapterData: TableViewAdapterData? {
        get {
            return self.adapter.data
        }
        set {
            self.adapter.data = newValue
        }
    }

    public var scrollViewDelegate: UIScrollViewDelegate? {
        get {
            return self.adapter.scrollViewDelegate
        }
        set {
            self.adapter.scrollViewDelegate = newValue
        }
    }

    public var adapterHasNext: Bool {
        get {
            return self.adapter.hasNext
        }
        set {
            self.adapter.hasNext = newValue
        }
    }

    public var adapterRequestNextClosure: (() -> Void)? {
        get {
            return self.adapter.requestNextClosure
        }
        set {
            self.adapter.requestNextClosure = newValue
        }
    }

    public var isUsedCacheSize: Bool {
        get {
            return self.adapter.isUsedCacheSize
        }
        set {
            self.adapter.isUsedCacheSize = newValue
        }
    }
    public var cacheSize: [Int: [Int: CGFloat]] {
        get {
            return self.adapter.cacheSize
        }
        set {
            self.adapter.cacheSize = newValue
        }
    }

    public func cacheRemoveAfterReloadData() {
        self.adapter.cacheSize.removeAll()
        self.reloadData()
    }

    public func cacheRemoveAfterReloadSections(_ sections: IndexSet) {
        for s in sections {
            self.adapter.cacheSize.removeValue(forKey: s)
        }
        self.reloadSections(sections, with: .automatic)
    }

    public func cacheRemoveAfterReloadItems(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if var sectionDic = self.adapter.cacheSize[indexPath.section] {
                sectionDic.removeValue(forKey: indexPath.row)
                self.adapter.cacheSize[indexPath.section] = sectionDic
            }
        }
        self.reloadRows(at: indexPaths, with: .automatic)
    }
}
