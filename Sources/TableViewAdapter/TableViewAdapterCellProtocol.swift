//
//  TableViewAdapterCellProtocol.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//

import UIKit

public let SectionInsetNotSupport = UIEdgeInsets(top: -9999, left: -9999, bottom: -9999, right: -9999)
public typealias TVACellProtocol = TableViewAdapterCellProtocol
public typealias TVAHeadFooterProtocol = TableViewAdapterHeaderFooterProtocol

@MainActor
public protocol TableViewAdapterCellProtocol: UITableViewCell {
    var actionClosure: ((_ name: String, _ object: Any?) -> Void)? { get set }

    static func getSize(data: Any?, width: CGFloat, tableView: UITableView, indexPath: IndexPath) -> CGFloat
    func configureBefore(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath)
    func configureAfter(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath)
    func configure(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath)
    func willDisplay(tableView: UITableView, indexPath: IndexPath)
    func didEndDisplaying(tableView: UITableView, indexPath: IndexPath)
    // didSelect는 cell만 지원가능함
    func didSelect(tableView: UITableView, indexPath: IndexPath)
    func didHighlight(tableView: UITableView, indexPath: IndexPath)
    func didUnhighlight(tableView: UITableView, indexPath: IndexPath)
}

public extension TableViewAdapterCellProtocol {
    func configureBefore(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath) {}
    func configureAfter(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath) {}
    func willDisplay(tableView: UITableView, indexPath: IndexPath) {}
    func didEndDisplaying(tableView: UITableView, indexPath: IndexPath) {}
    func didSelect(tableView: UITableView, indexPath: IndexPath) {}
    func didHighlight(tableView: UITableView, indexPath: IndexPath) {}
    func didUnhighlight(tableView: UITableView, indexPath: IndexPath) {}
}

@MainActor
public protocol TableViewAdapterHeaderFooterProtocol: UITableViewHeaderFooterView {
    var actionClosure: ((_ name: String, _ object: Any?) -> Void)? { get set }

    static func getSize(data: Any?, width: CGFloat, tableView: UITableView, indexPath: IndexPath) -> CGFloat
    func configureBefore(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath)
    func configureAfter(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath)
    func configure(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath)
    func willDisplay(tableView: UITableView, indexPath: IndexPath)
    func didEndDisplaying(tableView: UITableView, indexPath: IndexPath)
}

public extension TableViewAdapterHeaderFooterProtocol {
    func configureBefore(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath) {}
    func configureAfter(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath) {}
    func willDisplay(tableView: UITableView, indexPath: IndexPath) {}
    func didEndDisplaying(tableView: UITableView, indexPath: IndexPath) {}
}

@MainActor
public class ViewCacheManager {
    static var cacheViewNibs: NSCache<NSString, UIView> = {
        var c = NSCache<NSString, UIView>()
        c.countLimit = 500
        return c
    }()
    static var cacheNibs: NSCache<NSString, UINib> = {
        var c = NSCache<NSString, UINib>()
        c.countLimit = 500
        return c
    }()

    public static func cacheRemoveAll() {
        self.cacheViewNibs.removeAllObjects()
        self.cacheNibs.removeAllObjects()
    }
}

extension TableViewAdapterCellProtocol where Self: UIView {
    public static func fromXib(cache: Bool = false) -> Self {
        return fromXib(cache: cache, as: self)
    }

    private static func fromXib<T>(cache: Bool = false, as type: T.Type) -> T {
        if cache, let view = ViewCacheManager.cacheViewNibs.object(forKey: self.className as NSString) {
            return view as! T
        }
        else if let nib = ViewCacheManager.cacheNibs.object(forKey: self.className as NSString) {
            return nib.instantiate(withOwner: nil, options: nil).first as! T
        }
        else if let path: String = Bundle.main.path(forResource: className, ofType: "nib") {
            if FileManager.default.fileExists(atPath: path) {
                let nib = UINib(nibName: self.className, bundle: nil)
                let view = nib.instantiate(withOwner: nil, options: nil).first as! T

                ViewCacheManager.cacheNibs.setObject(nib, forKey: self.className as NSString)
                if cache {
                    ViewCacheManager.cacheViewNibs.setObject(view as! UIView, forKey: self.className as NSString)
                }
                return view
            }
        }
        fatalError("\(className) XIB File Not Exist")
    }

    private static func fromXibSize() -> CGSize {
        return fromXib(cache: true).frame.size
    }
}

extension TableViewAdapterHeaderFooterProtocol where Self: UIView {
    static func fromXib(cache: Bool = false) -> Self {
        return fromXib(cache: cache, as: self)
    }

    private static func fromXib<T>(cache: Bool = false, as type: T.Type) -> T {
        if cache, let view = ViewCacheManager.cacheViewNibs.object(forKey: self.className as NSString) {
            return view as! T
        }
        else if let nib = ViewCacheManager.cacheNibs.object(forKey: self.className as NSString) {
            return nib.instantiate(withOwner: nil, options: nil).first as! T
        }
        else if let path: String = Bundle.main.path(forResource: className, ofType: "nib") {
            if FileManager.default.fileExists(atPath: path) {
                let nib = UINib(nibName: self.className, bundle: nil)
                let view = nib.instantiate(withOwner: nil, options: nil).first as! T

                ViewCacheManager.cacheNibs.setObject(nib, forKey: self.className as NSString)
                if cache {
                    ViewCacheManager.cacheViewNibs.setObject(view as! UIView, forKey: self.className as NSString)
                }
                return view
            }
        }
        fatalError("\(className) XIB File Not Exist")
    }

    public static func fromXibSize() -> CGSize {
        return fromXib(cache: true).frame.size
    }
}
