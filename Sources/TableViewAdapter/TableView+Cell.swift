//
//  TableView+Cell.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//

import UIKit

private var cacheNibs = {
    let cache = NSCache<NSString, UINib>()
    cache.countLimit = 300
    return cache
}()

public func isXibFileExists(_ fileName: String, bundle: Bundle?) -> Bool {
    var aBundle = Bundle.main
    if let bundle {
        aBundle = bundle
    }

    if let path: String = aBundle.path(forResource: fileName, ofType: "nib") {
        if FileManager.default.fileExists(atPath: path) {
            return true
        }
    }
    return false
}

extension UITableView {
    private struct AssociatedKeys {
        static var registerCellName: UInt8 = 0
        static var registerHeaderName: UInt8 = 0
        static var registerFooterName: UInt8 = 0
    }

    public var registerCellNames: Set<String> {
        get {
            if let result: Set<String> = objc_getAssociatedObject(self, &AssociatedKeys.registerCellName) as? Set<String> {
                return result
            }
            let result: Set<String> = Set<String>(minimumCapacity: 100)
            objc_setAssociatedObject(self, &AssociatedKeys.registerCellName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerCellName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var registerHeaderNames: Set<String> {
        get {
            if let result: Set<String> = objc_getAssociatedObject(self, &AssociatedKeys.registerHeaderName) as? Set<String> {
                return result
            }
            let result: Set<String> = Set<String>(minimumCapacity: 100)
            objc_setAssociatedObject(self, &AssociatedKeys.registerHeaderName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerHeaderName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var registerFooterNames: Set<String> {
        get {
            if let result: Set<String> = objc_getAssociatedObject(self, &AssociatedKeys.registerFooterName) as? Set<String> {
                return result
            }
            let result: Set<String> = Set<String>(minimumCapacity: 100)
            objc_setAssociatedObject(self, &AssociatedKeys.registerFooterName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerFooterName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func registerDefaultCell(bundle: Bundle? = nil) {
        register(UITableViewCell.self, bundle: bundle)
        registerHeader(UITableViewHeaderFooterView.self, bundle: bundle)
        registerFooter(UITableViewHeaderFooterView.self, bundle: bundle)
    }

    public func register(_ Classs: UITableViewCell.Type..., bundle: Bundle? = nil) {
        for Class: UITableViewCell.Type in Classs {
            guard registerCellNames.contains(Class.className) == false else { continue }

            registerCellNames.insert(Class.className)
            if isXibFileExists(Class.className, bundle: bundle) {
                registerNibCell(Class, bundle: bundle)
            }
            else {

                if let bundle {
                    register(getNib(className: Class.className, bundle: bundle), forCellReuseIdentifier: Class.className)
                }
                else {
                    register(Class, forCellReuseIdentifier: Class.className)
                }
            }
        }
    }

    public func register(Class: UITableViewCell.Type, withReuseIdentifier: String, bundle: Bundle? = nil) {
        guard registerCellNames.contains(withReuseIdentifier) == false else { return }

        registerCellNames.insert(withReuseIdentifier)
        if isXibFileExists(Class.className, bundle: bundle) {
            registerNibCell(Class: Class, withReuseIdentifier: withReuseIdentifier, bundle: bundle)
        }
        else {
            if let bundle {
                register(getNib(className: Class.className, bundle: bundle), forCellReuseIdentifier: withReuseIdentifier)
            }
            else {
                register(Class, forCellReuseIdentifier: withReuseIdentifier)
            }
        }
    }

    public func registerHeader(_ Classs: UITableViewHeaderFooterView.Type..., bundle: Bundle? = nil) {
        for Class: UITableViewHeaderFooterView.Type in Classs {
            guard registerHeaderNames.contains(Class.className) == false else { continue }

            registerHeaderNames.insert(Class.className)
            if isXibFileExists(Class.className, bundle: bundle) {
                registerNibCellHeader(Class, bundle: bundle)
            }
            else {
                if let bundle {
                    register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: Class.className)
                }
                else {
                    register(Class, forHeaderFooterViewReuseIdentifier: Class.className)
                }
            }
        }
    }

    public func registerHeader(Class: UITableViewHeaderFooterView.Type, withReuseIdentifier: String, bundle: Bundle? = nil) {
        guard registerHeaderNames.contains(withReuseIdentifier) == false else { return }

        registerHeaderNames.insert(withReuseIdentifier)
        if isXibFileExists(Class.className, bundle: bundle) {
            registerNibCellHeader(Class: Class, withReuseIdentifier: withReuseIdentifier, bundle: bundle)
        }
        else {
            if let bundle {
                register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: withReuseIdentifier)
            }
            else {
                register(Class, forHeaderFooterViewReuseIdentifier: withReuseIdentifier)
            }
        }
    }

    public func registerFooter(_ Classs: UITableViewHeaderFooterView.Type..., bundle: Bundle? = nil) {
        for Class: UITableViewHeaderFooterView.Type in Classs {
            guard registerFooterNames.contains(Class.className) == false else { continue }

            registerFooterNames.insert(Class.className)
            if isXibFileExists(Class.className, bundle: bundle) {
                registerNibCellFooter(Class, bundle: bundle)
            }
            else {
                if let bundle {
                    register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: Class.className)
                }
                else {
                    register(Class, forHeaderFooterViewReuseIdentifier: Class.className)
                }
            }
        }
    }

    public func registerFooter(Class: UITableViewHeaderFooterView.Type, withReuseIdentifier: String, bundle: Bundle? = nil) {
        guard registerFooterNames.contains(Class.className) == false else { return }

        registerFooterNames.insert(Class.className)
        if isXibFileExists(Class.className, bundle: bundle) {
            registerNibCellFooter(Class: Class, withReuseIdentifier: withReuseIdentifier, bundle: bundle)
        }
        else {
            if let bundle {
                register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: withReuseIdentifier)
            }
            else {
                register(Class, forHeaderFooterViewReuseIdentifier: withReuseIdentifier)
            }
        }
    }

    private func getNib(className: String, bundle: Bundle? = nil) -> UINib {
        if let nib = cacheNibs.object(forKey: className as NSString) {
            return nib
        }

        let nib = UINib(nibName: className, bundle: bundle)
        cacheNibs.setObject(nib, forKey: className as NSString)
        return nib
    }

    public func registerNibCell(_ Classs: UITableViewCell.Type..., bundle: Bundle? = nil) {
        Classs.forEach { (Class: UITableViewCell.Type) in
            register(getNib(className: Class.className, bundle: bundle), forCellReuseIdentifier: Class.className)
        }
    }

    public func registerNibCell(Class: UITableViewCell.Type, withReuseIdentifier: String, bundle: Bundle? = nil) {
        register(getNib(className: Class.className, bundle: bundle), forCellReuseIdentifier: withReuseIdentifier)
    }

    public func registerNibCellHeader(_ Classs: UITableViewHeaderFooterView.Type..., bundle: Bundle? = nil) {
        Classs.forEach { (Class: UITableViewHeaderFooterView.Type) in
            register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: Class.className)
        }
    }

    public func registerNibCellHeader(Class: UITableViewHeaderFooterView.Type, withReuseIdentifier: String, bundle: Bundle? = nil) {
        register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: withReuseIdentifier)
    }

    public func registerNibCellFooter(_ Classs: UITableViewHeaderFooterView.Type..., bundle: Bundle? = nil) {
        Classs.forEach { (Class: UITableViewHeaderFooterView.Type) in
            register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: Class.className)
        }
    }

    public func registerNibCellFooter(Class: UITableViewHeaderFooterView.Type, withReuseIdentifier: String, bundle: Bundle? = nil) {
        register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: withReuseIdentifier)
    }

    public func registerCustomKindReusableView(_ Class: UITableViewHeaderFooterView.Type, _ Kind: String, _ identifier: String, bundle: Bundle? = nil) {
        register(getNib(className: Class.className, bundle: bundle), forHeaderFooterViewReuseIdentifier: identifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: Class.className, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }

    public func dequeueReusableCell<T: UITableViewCell>(_ Class: T.Type, for indexPath: IndexPath, withReuseIdentifier: String) -> T {
        let cell = dequeueReusableCell(withIdentifier: withReuseIdentifier, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }

    public func dequeueReusableHeader<T: UITableViewHeaderFooterView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let view = dequeueReusableHeaderFooterView(withIdentifier: Class.className) as! T
        view.indexPath = indexPath
        return view
    }

    public func dequeueReusableHeader<T: UITableViewHeaderFooterView>(_ Class: T.Type, for indexPath: IndexPath, withReuseIdentifier: String) -> T {
        let view = dequeueReusableHeaderFooterView(withIdentifier: withReuseIdentifier) as! T
        view.indexPath = indexPath
        return view
    }

    public func dequeueReusableFooter<T: UITableViewHeaderFooterView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let view = dequeueReusableHeaderFooterView(withIdentifier: Class.className) as! T
        view.indexPath = indexPath
        return view
    }

    /// 다음페이지를 호출해야 하는 검사
    /// willDisplay에서 호출해 주세요
    /// - Parameter cell: cell
    /// - Returns: 체크값
    public func checkMorePage(cell: UITableViewCell) -> Bool {
        return (contentSize.height - cell.frame.maxY) < (cell.frame.size.height * 4)
    }
}

extension UITableViewCell {
    private struct AssociatedKeys {
        static var indexPath: UInt8 = 0
        static var parentTableView: UInt8 = 0
    }
    public var indexPath: IndexPath {
        get {
            if let indexPath: IndexPath = objc_getAssociatedObject(self, &AssociatedKeys.indexPath) as? IndexPath {
                return indexPath
            }
            return IndexPath(row: 0, section: 0)

        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.indexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public weak var parentTableView: UITableView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.parentTableView) as? UITableView
        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.parentTableView, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

extension UITableViewHeaderFooterView {
    private struct AssociatedKeys {
        static var indexPath: UInt8 = 0
        static var parentTableView: UInt8 = 0
    }
    public var indexPath: IndexPath {
        get {
            if let indexPath: IndexPath = objc_getAssociatedObject(self, &AssociatedKeys.indexPath) as? IndexPath {
                return indexPath
            }
            return IndexPath(row: 0, section: 0)

        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.indexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public weak var parentTableView: UITableView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.parentTableView) as? UITableView
        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.parentTableView, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

extension NSObject {
    private struct AssociatedKeys {
        static var className: UInt8 = 0
        static var observerAble: UInt8 = 0
    }

    var className: String {
        if let name = objc_getAssociatedObject(self, &AssociatedKeys.className) as? String {
            return name
        }
        else {
            let name = String(describing: type(of:self))
            objc_setAssociatedObject(self, &AssociatedKeys.className, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
    }

    class var className: String {
        if let name = objc_getAssociatedObject(self, &AssociatedKeys.className) as? String {
            return name
        }
        else {
            let name = String(describing: self)
            objc_setAssociatedObject(self, &AssociatedKeys.className, name, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return name
        }
    }

    var observerAble: (key: String, closure: (_ value: String) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.observerAble) as? (key: String, closure: (String) -> Void)
        }
        set {
            if objc_getAssociatedObject(self, &AssociatedKeys.observerAble) == nil {
                NotificationCenter.default.addObserver(self, selector: #selector(onObserver), name: Notification.Name(rawValue: newValue?.key ?? "observerAble"), object: nil)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.observerAble, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private func onObserver() {
        observerAble?.closure(observerAble?.key ?? "observerAble")
    }
}
