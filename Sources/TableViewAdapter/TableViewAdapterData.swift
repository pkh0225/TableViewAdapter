// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public typealias TVAData = TableViewAdapterData
public typealias TVASectionInfo = TableViewAdapterData.SectionInfo
public typealias TVACellInfo = TableViewAdapterData.CellInfo
public typealias TVAHeaderFooterInfo = TableViewAdapterData.HeaderFooterInfo


// MARK: - UITableViewViewAdapterData
public class TableViewAdapterData: NSObject {
    public class CellInfo: NSObject {

        public var contentObj: Any?
        public var subData: [String: Any?]?
        public var cellType: TableViewAdapterCellProtocol.Type
        public var sizeClosure: (() -> CGFloat)?
        public var actionClosure: ActionClosure?

        public init(cellType: TableViewAdapterCellProtocol.Type) {
            self.cellType = cellType
        }
    }

    public class HeaderFooterInfo: NSObject {
        public var contentObj: Any?
        public var subData: [String: Any?]?
        public var cellType: TableViewAdapterHeaderFooterProtocol.Type
        public var sizeClosure: (() -> CGFloat)?
        public var actionClosure: ActionClosure?

        public init(cellType: TableViewAdapterHeaderFooterProtocol.Type) {
            self.cellType = cellType
        }
    }

    public class SectionInfo: NSObject {
        public var header: HeaderFooterInfo?
        public var footer: HeaderFooterInfo?
        public var cells = [CellInfo]()

        public var dataType: String = ""
        public var indexPath = IndexPath(row: 0, section: 0)

        public override init() {}

        public init(cells: [CellInfo]) {
            self.cells = cells
        }
    }

    public var sectionList = [SectionInfo]()
}


extension TableViewAdapterData.CellInfo {
    public func setContentObj(_ contentObj: Any?) -> Self {
        self.contentObj = contentObj
        return self
    }

    public func setSubData(_ subData: [String: Any?]?) -> Self {
        self.subData = subData
        return self
    }

    public func setCellType(_ cellType: TableViewAdapterCellProtocol.Type) -> Self {
        self.cellType = cellType
        return self
    }

    public func setSizeClosure(_ sizeClosure: (() -> CGFloat)? = nil) -> Self {
        self.sizeClosure = sizeClosure
        return self
    }

    public func setActionClosure(_ actionClosure: ActionClosure? = nil) -> Self {
        self.actionClosure = actionClosure
        return self
    }
}

extension TableViewAdapterData.HeaderFooterInfo {
    public func setContentObj(_ contentObj: Any?) -> Self {
        self.contentObj = contentObj
        return self
    }

    public func setSubData(_ subData: [String: Any?]?) -> Self {
        self.subData = subData
        return self
    }

    public func setCellType(_ cellType: TableViewAdapterHeaderFooterProtocol.Type) -> Self {
        self.cellType = cellType
        return self
    }

    public func setSizeClosure(_ sizeClosure: (() -> CGFloat)? = nil) -> Self {
        self.sizeClosure = sizeClosure
        return self
    }

    public func setActionClosure(_ actionClosure: ActionClosure? = nil) -> Self {
        self.actionClosure = actionClosure
        return self
    }
}

extension TableViewAdapterData.SectionInfo {
    public func setHeader(_ cellInfo: TableViewAdapterData.HeaderFooterInfo) -> Self {
        self.header = cellInfo
        return self
    }

    public func setFooter(_ cellInfo: TableViewAdapterData.HeaderFooterInfo) -> Self {
        self.footer = cellInfo
        return self
    }

    public func setCells(_ cells: [TableViewAdapterData.CellInfo]) -> Self {
        self.cells = cells
        return self
    }

    public func setDataType(_ type: String) -> Self {
        self.dataType = type
        return self
    }

    public func setIndexPath(_ indexPath: IndexPath) -> Self {
        self.indexPath = indexPath
        return self
    }
}
