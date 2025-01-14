// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public typealias TVAData = TableViewAdapterData
public typealias TVASectionInfo = TableViewAdapterData.SectionInfo
public typealias TVACellInfo = TableViewAdapterData.CellInfo
public typealias TVAHFInfo = TableViewAdapterData.HeaderFooterInfo


// MARK: - UITableViewViewAdapterData
public class TableViewAdapterData: NSObject {
    public class CellInfo: NSObject {

        public var contentObj: Any?
        public var subData: [String: Any?]?
        public var cellType: TableViewAdapterCellProtocol.Type
        public var sizeClosure: (() -> CGFloat)?
        public var actionClosure: ((_ name: String, _ object: Any?) -> Void)?

        public init(_ cellType: TableViewAdapterCellProtocol.Type) {
            self.cellType = cellType
        }
    }

    public class HeaderFooterInfo: NSObject {
        public var contentObj: Any?
        public var subData: [String: Any?]?
        public var cellType: TableViewAdapterHeaderFooterProtocol.Type
        public var sizeClosure: (() -> CGFloat)?
        public var actionClosure: ((_ name: String, _ object: Any?) -> Void)?

        public init(_ cellType: TableViewAdapterHeaderFooterProtocol.Type) {
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

    @discardableResult
    public func addScetion(_ section: SectionInfo) -> Self {
        self.sectionList.append(section)
        return self
    }
}


extension TableViewAdapterData.CellInfo {
    @discardableResult
    public func contentObj(_ contentObj: Any?) -> Self {
        self.contentObj = contentObj
        return self
    }

    @discardableResult
    public func subData(_ subData: [String: Any?]?) -> Self {
        self.subData = subData
        return self
    }

    @discardableResult
    public func cellType(_ cellType: TableViewAdapterCellProtocol.Type) -> Self {
        self.cellType = cellType
        return self
    }

    @discardableResult
    public func sizeClosure(_ sizeClosure: (() -> CGFloat)? = nil) -> Self {
        self.sizeClosure = sizeClosure
        return self
    }

    @discardableResult
    public func actionClosure(_ actionClosure: ((_ name: String, _ object: Any?) -> Void)? = nil) -> Self {
        self.actionClosure = actionClosure
        return self
    }
}

extension TableViewAdapterData.HeaderFooterInfo {
    @discardableResult
    public func contentObj(_ contentObj: Any?) -> Self {
        self.contentObj = contentObj
        return self
    }

    @discardableResult
    public func subData(_ subData: [String: Any?]?) -> Self {
        self.subData = subData
        return self
    }

    @discardableResult
    public func cellType(_ cellType: TableViewAdapterHeaderFooterProtocol.Type) -> Self {
        self.cellType = cellType
        return self
    }

    @discardableResult
    public func sizeClosure(_ sizeClosure: (() -> CGFloat)? = nil) -> Self {
        self.sizeClosure = sizeClosure
        return self
    }

    @discardableResult
    public func actionClosure(_ actionClosure: ((_ name: String, _ object: Any?) -> Void)? = nil) -> Self {
        self.actionClosure = actionClosure
        return self
    }
}

extension TableViewAdapterData.SectionInfo {
    @discardableResult
    public func header(_ cellInfo: TableViewAdapterData.HeaderFooterInfo) -> Self {
        self.header = cellInfo
        return self
    }

    @discardableResult
    public func footer(_ cellInfo: TableViewAdapterData.HeaderFooterInfo) -> Self {
        self.footer = cellInfo
        return self
    }

    @discardableResult
    public func cells(_ cells: [TableViewAdapterData.CellInfo]) -> Self {
        self.cells = cells
        return self
    }

    @discardableResult
    public func addCell(_ cell: TableViewAdapterData.CellInfo) -> Self {
        self.cells.append(cell)
        return self
    }

    @discardableResult
    public func dataType(_ type: String) -> Self {
        self.dataType = type
        return self
    }

    @discardableResult
    public func indexPath(_ indexPath: IndexPath) -> Self {
        self.indexPath = indexPath
        return self
    }
}
