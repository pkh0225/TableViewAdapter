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
}


extension TableViewAdapterData.CellInfo {
    public func contentObj(_ contentObj: Any?) -> Self {
        self.contentObj = contentObj
        return self
    }

    public func subData(_ subData: [String: Any?]?) -> Self {
        self.subData = subData
        return self
    }

    public func cellType(_ cellType: TableViewAdapterCellProtocol.Type) -> Self {
        self.cellType = cellType
        return self
    }

    public func sizeClosure(_ sizeClosure: (() -> CGFloat)? = nil) -> Self {
        self.sizeClosure = sizeClosure
        return self
    }

    public func actionClosure(_ actionClosure: ((_ name: String, _ object: Any?) -> Void)? = nil) -> Self {
        self.actionClosure = actionClosure
        return self
    }
}

extension TableViewAdapterData.HeaderFooterInfo {
    public func contentObj(_ contentObj: Any?) -> Self {
        self.contentObj = contentObj
        return self
    }

    public func subData(_ subData: [String: Any?]?) -> Self {
        self.subData = subData
        return self
    }

    public func cellType(_ cellType: TableViewAdapterHeaderFooterProtocol.Type) -> Self {
        self.cellType = cellType
        return self
    }

    public func sizeClosure(_ sizeClosure: (() -> CGFloat)? = nil) -> Self {
        self.sizeClosure = sizeClosure
        return self
    }

    public func actionClosure(_ actionClosure: ((_ name: String, _ object: Any?) -> Void)? = nil) -> Self {
        self.actionClosure = actionClosure
        return self
    }
}

extension TableViewAdapterData.SectionInfo {
    public func header(_ cellInfo: TableViewAdapterData.HeaderFooterInfo) -> Self {
        self.header = cellInfo
        return self
    }

    public func footer(_ cellInfo: TableViewAdapterData.HeaderFooterInfo) -> Self {
        self.footer = cellInfo
        return self
    }

    public func cells(_ cells: [TableViewAdapterData.CellInfo]) -> Self {
        self.cells = cells
        return self
    }

    public func dataType(_ type: String) -> Self {
        self.dataType = type
        return self
    }

    public func indexPath(_ indexPath: IndexPath) -> Self {
        self.indexPath = indexPath
        return self
    }
}
