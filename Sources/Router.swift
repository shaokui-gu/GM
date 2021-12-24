//
//  Router.swift
//  Polytime
//
//  Created by gavin on 2021/12/16.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation
import UIKit

/// 任意参数无返回值
public typealias AnyCallBack = (Any) -> Void

/// 无参数无返回值
public typealias VoidCallBack  = () -> Void

/// 布尔参数无返回值
public typealias BoolCallBack = (Bool) -> Void


public enum RouteChangeDirection {
    case forward
    case backward
}

public enum RouteChangeTransitionType {
    case push
    case pop
    case present
    case dismiss
}

/// 路由代理
public protocol RouterDelegate {
    func routerShouldChange(_ from:String?, to:String?, params:[String: Any]?, direction:RouteChangeDirection, transitionType:RouteChangeTransitionType) -> Bool
    func routerWillChange(_ from:String?, to:String?, params:[String: Any]?, direction:RouteChangeDirection, transitionType:RouteChangeTransitionType) -> Void
    func routerDidChange(_ from:String?, to:String?, params:[String: Any]?, direction:RouteChangeDirection, transitionType:RouteChangeTransitionType) -> Void
    func routerLoadFailure(_ error:Error, params:[String: Any]?, direction:RouteChangeDirection, transitionType:RouteChangeTransitionType) -> Void
}

open class Router {
    
    /// 错误码
    public enum RouteErrorCode : Int {
        case notSetRoot = 100
        case notFound = 404
        case notSupport = 405
        case internalError = 500
    }

    /// 错误描述
    public enum RouteErrorDescription  : String {
        case notSetRoot = "根路由未设置"
        case notFound = "路由不存在"
        case notSupport = "不支持此方式切换路由"
        case internalError = "内部错误"
    }
    
    /// 错误
    public struct RouteError : Error {
        let code:Int
        let msg:String
        public init(code:Int, msg:String) {
            self.code = code
            self.msg = msg
        }
    }
    
    /// 导航
    class Navigator {
        static let shared = Router.Navigator()
        fileprivate var rootNavigation:UINavigationController? {
            return  UIApplication.shared.getFirstKeyWindow?.rootViewController as? UINavigationController
        }
        fileprivate var root:UIViewController? {
            return UIApplication.shared.getFirstKeyWindow?.rootViewController
        }
        fileprivate weak var topNavigation:UINavigationController? {
            let current = Router.shared.current?.controller
            if let current = current as? UINavigationController {
                return current
            }
            return current?.navigationController ?? rootNavigation
        }
        private init() {}
    }
    
    /// 一个命名路由界面
    public struct RoutePage {
        
        /// 路由名称
        public var name:String
    
        /// page构造器
        public var page:([String : Any ]?) -> UIViewController
        
        /// controller 如果是persent的，transiton方式
        public var transition:UIModalTransitionStyle?
        
        /// controller 如果是persent的，present方式
        public var presentation:UIModalPresentationStyle?
        
        /// 界面跳转时是否带动画
        public var animated:Bool
        
        public init(name:String, page:@escaping ([String : Any ]?) -> UIViewController, transition:UIModalTransitionStyle? = nil, presentation:UIModalPresentationStyle? = nil, animated:Bool = true) {
            self.name = name
            self.page = page
            self.transition = transition
            self.presentation = presentation
            self.animated = animated
        }
    }
    
    public struct Page : Equatable {
        
        public let identifire = UUID().uuidString
        
        /// 路由名称
        public private(set) var name:String
        
        /// id
        public private(set) var id:AnyHashable?
        
        /// viewController
        public private(set) weak var controller:UIViewController?
                
        public init(_ name:String, id:AnyHashable? = nil, controller:UIViewController) {
            self.name = name
            self.id = id
            self.controller = controller
            controller.routeIdentifire = identifire
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name && lhs.id == rhs.id
        }
    }
    
    
    static let shared = Router()
    
    private init(){}

    /// 所有已进入路由页面
    private(set) var routes:[Router.Page] = []
    
    /// 根页面
    fileprivate(set) var root:Router.Page? {
        didSet {
            guard routes.count == 0 else {
                assertionFailure("根页面不可修改")
                return
            }
            guard let page = root else {
                assertionFailure("根页面不可设置为空")
                return
            }
            routes.append(page)
        }
    }
    
    /// 所有已注册路由
    private(set) var pages:[AnyHashable : Router.RoutePage] = [:]

    /// 路由导航
    lazy var navigator:Router.Navigator = {
        return Router.Navigator.shared
    }()
    
    /// 最顶部的页面
    var current:Router.Page? {
        return routes.last
    }
    
    /// 代理
    var delegate:RouterDelegate?
    
    /// 注册
    func registerPages(_ pages:[Router.RoutePage]) {
        pages.forEach { page in
            self.pages[page.name] = page
        }
    }
    
    /// 对应路由名称的RoutePage
    func routePageFor(_ name:String) -> Router.RoutePage? {
        return pages[name]
    }
    
    func removePage(_ identifire:String) {
        self.routes.removeAll { page in
            let result = page.identifire == identifire
            if result {
                GM.log(GM.RouteLogPrefix, "\(page.controller?.description ?? "")退出路由")
            }
            return result
        }
    }
    
    /// push new
    func toNamed(_ name:String, id:AnyHashable? = nil, params:[String : Any]? = nil, useRootNavigation:Bool = false, animated:Bool? = nil, completion:VoidCallBack? = nil) throws -> Void {
        
        guard let _ = self.root else {
            throw RouteError.init(code: RouteErrorCode.notSetRoot.rawValue, msg: RouteErrorDescription.notSetRoot.rawValue)
        }
        
        guard let routePage = self.pages[name] else {
            throw RouteError.init(code: RouteErrorCode.notFound.rawValue, msg: RouteErrorDescription.notFound.rawValue)
        }

        var navigation = self.navigator.topNavigation
        if useRootNavigation {
            navigation = self.navigator.rootNavigation
        }
        
        guard let navigation = navigation else {
            throw RouteError.init(code: RouteErrorCode.notSupport.rawValue, msg: RouteErrorDescription.notSupport.rawValue)
        }
        
        let from = self.current?.name
        guard (delegate?.routerShouldChange(from, to: name, params: params, direction: .forward, transitionType: .push) ?? true) else {
            return
        }
        delegate?.routerWillChange(from, to: name, params: params, direction: .forward, transitionType: .push)
        
        let viewController = routePage.page(params)
        let page = Router.Page(name, id: id, controller: viewController)
        navigation.pushViewController(viewController, animated: animated ?? routePage.animated)
        GM.log(GM.RouteLogPrefix, "\(viewController.description)进入路由")
        self.routes.append(page)
        completion?()
        delegate?.routerDidChange(from, to: name, params: params, direction: .forward, transitionType: .push)
    }
    
    /// push and remove self from navigation after pushed
    func offToNamed(_ name:String, id:AnyHashable? = nil, params:[String : Any]? = nil, useRootNavigation:Bool = false, animated:Bool? = nil, completion:VoidCallBack? = nil) throws -> Void  {
        
        guard let _ = self.root else {
            throw RouteError.init(code: RouteErrorCode.notSetRoot.rawValue, msg: RouteErrorDescription.notSetRoot.rawValue)
        }
        
        guard let routePage = self.pages[name] else {
            throw RouteError.init(code: RouteErrorCode.notFound.rawValue, msg: RouteErrorDescription.notFound.rawValue)
        }
        var navigation = self.navigator.topNavigation
        if useRootNavigation {
            navigation = self.navigator.rootNavigation
        }
        
        guard let navigation = navigation else {
            throw RouteError.init(code: RouteErrorCode.notSupport.rawValue, msg: RouteErrorDescription.notSupport.rawValue)
        }
        
        let from = self.current?.name
        guard (delegate?.routerShouldChange(from, to: name, params: params, direction: .forward, transitionType: .push) ?? true) else {
            return
        }
        delegate?.routerWillChange(from, to: name, params: params, direction: .forward, transitionType: .push)
        
        let currentPage = self.current
        let currentPageIdx = self.routes.count - 1
        let viewController = routePage.page(params)
        let page = Router.Page(name, id: id, controller: viewController)
        navigation.pushViewController(viewController, animated: animated ?? routePage.animated)
        GM.log(GM.RouteLogPrefix, "\(viewController.description)进入路由")
        self.routes.append(page)
        
        guard let currentController = currentPage?.controller else {
            throw RouteError.init(code: RouteErrorCode.internalError.rawValue, msg: RouteErrorDescription.internalError.rawValue)
        }
        if let navigation = currentController.navigationController {
            var controllers = navigation.viewControllers
            if let index = controllers.firstIndex(of: currentController) {
                controllers.remove(at: index)
                self.routes.remove(at: currentPageIdx)
                navigation.viewControllers = controllers
            }
        }
        completion?()
        delegate?.routerDidChange(from, to: name, params: params, direction: .forward, transitionType: .push)
    }
    
    /// present new
    func toModalNamed(_ name:String, id:AnyHashable? = nil, params:[String : Any]? = nil, transition:UIModalTransitionStyle? = nil, presentation:UIModalPresentationStyle? = nil, enablePullBack:Bool = true, animated:Bool? = nil, completion:VoidCallBack? = nil) throws -> Void  {

        guard let _ = self.root else {
            throw RouteError.init(code: RouteErrorCode.notSetRoot.rawValue, msg: RouteErrorDescription.notSetRoot.rawValue)
        }

        guard let routePage = self.pages[name] else {
            throw RouteError.init(code: RouteErrorCode.notFound.rawValue, msg: RouteErrorDescription.notFound.rawValue)
        }
        
        let from = self.current?.name
        guard (delegate?.routerShouldChange(from, to: name, params: params, direction: .forward, transitionType: .present) ?? true) else {
            return
        }
        delegate?.routerWillChange(from, to: name, params: params, direction: .forward, transitionType: .present)
        
        let topController = self.current?.controller ?? self.navigator.root
        let viewController = routePage.page(params)
        if #available(iOS 13.0, *) {
            viewController.isModalInPresentation = !enablePullBack
        } else {
            // Fallback on earlier versions
        }
        viewController.isModalViewController = true
        viewController.modalTransitionStyle = transition ?? routePage.transition ?? .coverVertical
        viewController.modalPresentationStyle = presentation ?? routePage.presentation ?? .pageSheet
        let page = Router.Page(name, id: id, controller: viewController)
        topController?.present(viewController, animated: animated ?? routePage.animated, completion: completion)
        GM.log(GM.RouteLogPrefix, "\(viewController.description)进入路由")
        self.routes.append(page)
        delegate?.routerDidChange(from, to: name, params: params, direction: .forward, transitionType: .present)
    }
    
    /// back
    func back(animated: Bool = true, completion:VoidCallBack? = nil) throws -> Void {
        guard let page = self.routes.last else {
            throw RouteError.init(code: RouteErrorCode.notFound.rawValue, msg: RouteErrorDescription.notFound.rawValue)
        }
        
        guard let controller = page.controller else {
            throw RouteError.init(code: RouteErrorCode.internalError.rawValue, msg: RouteErrorDescription.internalError.rawValue)
        }
        let from = self.current?.name
        var to:String?
        if controller.isModalViewController {
            self.routes.removeLast()
            to = self.current?.name
            guard (delegate?.routerShouldChange(from, to: to, params: nil, direction: .backward, transitionType: .dismiss) ?? true) else {
                return
            }
            delegate?.routerWillChange(from, to: to, params: nil, direction: .backward, transitionType: .dismiss)
            controller.dismiss(animated: animated, completion: completion)
            delegate?.routerDidChange(from, to: to, params: nil, direction: .backward, transitionType: .dismiss)
        } else {
            guard let navigation = self.navigator.topNavigation else {
                throw RouteError.init(code: RouteErrorCode.notSupport.rawValue, msg: RouteErrorDescription.notSupport.rawValue)
            }
            self.routes.removeLast()
            to = self.current?.name
            guard (delegate?.routerShouldChange(from, to: to, params: nil, direction: .backward, transitionType: .pop) ?? true) else {
                return
            }
            navigation.popViewController(animated: animated)
            completion?()
            delegate?.routerDidChange(from, to: to, params: nil, direction: .backward, transitionType: .pop)
        }
    }
    
    /// back to
    func backTo(_ name:String, id:AnyHashable? = nil, animated: Bool = true, completion:VoidCallBack? = nil) throws -> Void  {
        let index = self.routes.firstIndex { page in
            return page.name == name && (id == nil ? true : (page.id == id))
        }
        guard let index = index else {
            throw RouteError.init(code: RouteErrorCode.notFound.rawValue, msg: RouteErrorDescription.notFound.rawValue)
        }
        let page = self.routes[index]
        guard let controller = page.controller else {
            throw RouteError.init(code: RouteErrorCode.internalError.rawValue, msg: RouteErrorDescription.internalError.rawValue)
        }
        let subRoutes = Array(self.routes.suffix(from: index + 1).reversed())
        let modalPages = subRoutes.filter { page in
            return page.controller?.isModalViewController ?? false
        }
        
        let from = self.current?.name
        let to = page.name
        
        let finalIsModalPage = subRoutes.last?.controller?.isModalViewController ?? false
        let transitionType:RouteChangeTransitionType = finalIsModalPage ? .dismiss : .pop
        guard (delegate?.routerShouldChange(from, to: to, params: nil, direction: .backward, transitionType: transitionType) ?? true) else {
            return
        }
        delegate?.routerWillChange(from, to: to, params: nil, direction: .backward, transitionType: transitionType)
        guard modalPages.count > 0 else {
            let  controllers = self.navigator.topNavigation?.popToViewController(controller, animated: animated)
            self.routes.removeLast(controllers?.count ?? 0)
            completion?()
            delegate?.routerDidChange(from, to: to, params: nil, direction: .backward, transitionType: .pop)
            return
        }
        
        let sortedModalPages = modalPages.sorted { page1, page2 in
            let index1 = subRoutes.firstIndex(of: page1)!
            let index2 = subRoutes.firstIndex(of: page2)!
            return index1 < index2
        }
        
        var completed = false
        for idx in 0..<sortedModalPages.count {
            let page = sortedModalPages[idx]
            guard let controller = page.controller else {
                throw RouteError.init(code: RouteErrorCode.internalError.rawValue, msg: RouteErrorDescription.internalError.rawValue)
            }
            completed = (idx == (sortedModalPages.count - 1) && subRoutes.last == page)
            controller.dismiss(animated: animated, completion: completed ? completion : nil)
            let subIndex:Int = subRoutes.firstIndex(of: page) ?? 0
            if controller is UINavigationController {
                self.routes.removeLast(subIndex)
            }
        }
        if !completed {
            let controllers = self.navigator.topNavigation?.popToViewController(controller, animated: animated)
            self.routes.removeLast(controllers?.count ?? 0)
            completion?()
        }
        delegate?.routerDidChange(from, to: to, params: nil, direction: .backward, transitionType: transitionType)
    }
}


public extension UIViewController {
    
    struct AssociatedKeys {
        static var paramsKey = "params_key"
        static var isModalViewController = "is_model_view_controller"
        static var routePageIdentifire = "route_page_identifire"
    }
    
    var isModalViewController:Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isModalViewController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isModalViewController) as? Bool ?? false
        }
    }
    
    var routeIdentifire:String? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.routePageIdentifire, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.routePageIdentifire) as? String
        }
    }
    
    var params:[String : Any ]? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.paramsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.paramsKey) as? [String : Any]
        }
    }
}

extension GM {
    
    public static let RouteErrorLogPrefix = "【 ROUTER ERROR 】:"
    
    public static let RouteLogPrefix = "【 ROUTER 】:"

    public static var routes:[Router.Page] {
        return Router.shared.routes
    }
    
    public static var pages:[AnyHashable : Router.RoutePage] {
        return Router.shared.pages
    }

    /// 注册
    public static func registerPages(_ pages:[Router.RoutePage]) {
        Router.shared.registerPages(pages)
    }
    
    /// 代理
    public static func setRouterDelegate(_ delegate:RouterDelegate) {
        Router.shared.delegate = delegate
    }
    
    /// 对应路由名称的RoutePage
    public static func routePageFor(_ name:String) -> Router.RoutePage? {
        return Router.shared.routePageFor(name)
    }
    
    public static func rootPage() -> Router.Page? {
        return Router.shared.root
    }
    
    public static func topPage() -> Router.Page? {
        return Router.shared.current
    }
    
    public static func setRoot(_ page:Router.Page) {
        Router.shared.root = page
    }
    
    public static func removePage(_ identifire:String) {
        Router.shared.removePage(identifire)
    }
    
    public static func toNamed(_ name:String, id:AnyHashable? = nil, params:[String : Any]? = nil, useRootNavigation:Bool = false, animated:Bool? = nil, completion:VoidCallBack? = nil) {
        do {
            try Router.shared.toNamed(name, id: id, params: params, useRootNavigation: useRootNavigation, animated: animated, completion: completion)
        } catch {
            if let error = error as? Router.RouteError {
                self.log(RouteErrorLogPrefix ,error.msg)
            }
        }
    }
    
    public static func offToNamed(_ name:String, id:AnyHashable? = nil, params:[String : Any]? = nil, useRootNavigation:Bool = false, animated:Bool? = nil, completion:VoidCallBack? = nil)  {
        do {
            try Router.shared.offToNamed(name, id: id, params: params, useRootNavigation: useRootNavigation, animated: animated, completion: completion)
        } catch {
            if let error = error as? Router.RouteError {
                self.log(RouteErrorLogPrefix ,error.msg)
            }
        }
    }

    public static func toModalNamed(_ name:String, id:AnyHashable? = nil, params:[String : Any]? = nil, transition:UIModalTransitionStyle? = nil, presentation:UIModalPresentationStyle? = nil, enablePullBack:Bool = true, animated:Bool? = nil, completion:VoidCallBack? = nil)  {
        do {
            try Router.shared.toModalNamed(name, id: id, params: params, transition: transition, presentation: presentation, enablePullBack: enablePullBack, animated: animated, completion: completion)
        } catch {
            if let error = error as? Router.RouteError {
                self.log(RouteErrorLogPrefix ,error.msg)
            }
        }
    }
    
    public static func back(animated: Bool = true, completion:VoidCallBack? = nil)  {
        do {
            try Router.shared.back(animated: animated, completion: completion)
        } catch {
            if let error = error as? Router.RouteError {
                self.log(RouteErrorLogPrefix ,error.msg)
            }
        }
    }
    
    public static func backTo(_ name:String, id:AnyHashable? = nil, animated: Bool = true, completion:VoidCallBack? = nil) {
        do {
            try Router.shared.backTo(name, id: id, animated: animated, completion: completion)
        } catch {
            if let error = error as? Router.RouteError {
                self.log(RouteErrorLogPrefix ,error.msg)
            }
        }
    }
}
