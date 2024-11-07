//
//  TableViewAdapterCellProtocol.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//

import UIKit

public let SectionInsetNotSupport = UIEdgeInsets(top: -9999, left: -9999, bottom: -9999, right: -9999)
public typealias TVACellProtocol = TableViewAdapterCellProtocol
public typealias TVAHeadFooterFProtocol = TableViewAdapterHeaderFooterProtocol

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
fileprivate var CacheViewXibs = {
    let cache = NSCache<NSString, UIView>()
    cache.countLimit = 200
    return cache
}()

public extension UIView {

    class func fromXib(cache: Bool = false) -> Self {
        return fromXib(cache: cache, as: self)
    }

    private class func fromXib<T>(cache: Bool = false, as type: T.Type) -> T {
        if cache, let view = CacheViewXibs.object(forKey: String(describing: self) as NSString) {
            return view as! T
        }
        let view: UIView = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.first as! UIView
        if cache {
            CacheViewXibs.setObject(view, forKey: String(describing: self) as NSString)
        }
        return view as! T
    }

    class func fromXibSize() -> CGSize {
        return fromXib(cache: true).frame.size
    }
}

