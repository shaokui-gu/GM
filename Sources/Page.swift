//
//  Page.swift
//  Polytime
//
//  Created by gavin on 2021/12/18.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation
import SwiftUI

public protocol GMAppSceneCycle {
    @available(iOS 13.0, *)
    func sceneDidBecomeActive() -> Void
    @available(iOS 13.0, *)
    func sceneWillResignActive() -> Void
    @available(iOS 13.0, *)
    func sceneWillEnterForeground() -> Void
    @available(iOS 13.0, *)
    func sceneDidEnterBackground() -> Void
}

public protocol GMAppLifeCycle {
    func applicationDidBecomeActive(_ application: UIApplication) -> Void
    func applicationWillResignActive(_ application: UIApplication) -> Void
    func applicationDidEnterBackground(_ application: UIApplication) -> Void
    func applicationWillEnterForeground(_ application: UIApplication) -> Void
}

public protocol GMPageLifeCycle {
    func onPageAppear() -> Void
    func onPageDisappear()  -> Void
    func onPageInit() -> Void
    func onPageLoaded() -> Void
    func onPageDestroy() -> Void
}

public protocol GMPageAppearan {
    var preferredStatusBarStyle: UIStatusBarStyle { get }
    func onPageBoundsUpdated(_ bounds:CGRect) -> Void
}

fileprivate extension NSObject {
    
    func registerApplocationLifecycleNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNofify), name: UIApplication.didBecomeActiveNotification, object: UIApplication.shared)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNofify), name: UIApplication.willResignActiveNotification, object: UIApplication.shared)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackgroundNofify), name: UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNofify), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(sceneWillResignActiveNofify), name: UIScene.willDeactivateNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(sceneWillEnterForegroundNofify), name: UIScene.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(sceneDidBecomeActiveNofify), name: UIScene.didActivateNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(sceneDidEnterBackgroundNofify), name: UIScene.didEnterBackgroundNotification, object: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func applicationDidBecomeActiveNofify() {
        if let app = self as? GMAppLifeCycle {
            app.applicationDidBecomeActive(UIApplication.shared)
        }
    }

    @objc func applicationWillResignActiveNofify() {
        if let app = self as? GMAppLifeCycle {
            app.applicationWillResignActive(UIApplication.shared)
        }
    }

    @objc func applicationDidEnterBackgroundNofify() {
        if let app = self as? GMAppLifeCycle {
            app.applicationDidEnterBackground(UIApplication.shared)
        }
    }

    @objc func applicationWillEnterForegroundNofify() {
        if let app = self as? GMAppLifeCycle {
            app.applicationWillEnterForeground(UIApplication.shared)
        }
    }
    
    @available(iOS 13.0, *)
    @objc func sceneDidBecomeActiveNofify() {
        if let scene = self as? GMAppSceneCycle {
            scene.sceneDidBecomeActive()
        }
    }
    
    @available(iOS 13.0, *)
    @objc func sceneWillResignActiveNofify() {
        if let scene = self as? GMAppSceneCycle {
            scene.sceneWillResignActive()
        }
    }

    @available(iOS 13.0, *)
    @objc func sceneDidEnterBackgroundNofify() {
        if let scene = self as? GMAppSceneCycle {
            scene.sceneDidEnterBackground()
        }
    }

    @available(iOS 13.0, *)
    @objc func sceneWillEnterForegroundNofify() {
        if let scene = self as? GMAppSceneCycle {
            scene.sceneWillEnterForeground()
        }
    }
}

public protocol GMViewEventProtocol {
    
    /// 开始
    func touchesBegin() -> Void
    /// 移动
    func touchesMove() -> Void
    ///  结束
    func touchesEnd() -> Void
    /// 取消
    func touchesCancel() -> Void
    
}

public extension UIViewController {

    struct PopGestureAssociateKeys {
        static var popGesture = "popGestureKey"
    }
    
    var enablePopGesture:Bool {
        set {
            if let navigation = self as? UINavigationController {
                navigation.interactivePopGestureRecognizer?.isEnabled = newValue
            } else {
                objc_setAssociatedObject(self, &PopGestureAssociateKeys.popGesture, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            if let navigation = self as? UINavigationController {
                return navigation.interactivePopGestureRecognizer?.isEnabled ?? true
            } else {
                return objc_getAssociatedObject(self, &PopGestureAssociateKeys.popGesture) as? Bool ?? true
            }
        }
    }
}

open class GMPage : UIViewController, GMPageLifeCycle,GMAppLifeCycle, GMAppSceneCycle {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.registerApplocationLifecycleNotification()
        self.onPageInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final public override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageLoaded()
    }
    
    final public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.enablePopGesture = self.enablePopGesture
        self.onPageAppear()
    }

    final public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    final public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.onPageBoundsUpdated(self.view.bounds)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    open func onPageAppear() -> Void {}
    open func onPageDisappear()  -> Void {}
    open func onPageLoaded() -> Void {}
    open func onPageInit() -> Void {}
    open func onPageDestroy() -> Void {}
    open func onPageBoundsUpdated(_ bounds: CGRect) {}
    public func applicationDidBecomeActive(_ application: UIApplication) {}
    public func applicationWillResignActive(_ application: UIApplication) {}
    public func applicationDidEnterBackground(_ application: UIApplication) {}
    public func applicationWillEnterForeground(_ application: UIApplication) {}
    public func sceneDidBecomeActive() {}
    public func sceneWillResignActive() {}
    public func sceneWillEnterForeground() {}
    public func sceneDidEnterBackground() {}
    
}
 
open class GMNavigationPage : UINavigationController, GMPageLifeCycle, UIGestureRecognizerDelegate, GMAppLifeCycle, GMAppSceneCycle {
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.registerApplocationLifecycleNotification()
        self.onPageInit()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final public override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageLoaded()
    }
    
    final public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.enablePopGesture = self.enablePopGesture
        self.onPageAppear()
    }

    final public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    final public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.onPageBoundsUpdated(self.view.bounds)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    open func onPageAppear() -> Void {}
    open func onPageDisappear()  -> Void {}
    open func onPageLoaded() -> Void {}
    open func onPageInit() -> Void {}
    open func onPageDestroy() -> Void {}
    open func onPageBoundsUpdated(_ bounds: CGRect) {}
    open func applicationDidBecomeActive(_ application: UIApplication) {}
    open func applicationWillResignActive(_ application: UIApplication) {}
    open func applicationDidEnterBackground(_ application: UIApplication) {}
    open func applicationWillEnterForeground(_ application: UIApplication) {}
    open func sceneDidBecomeActive() {}
    open func sceneWillResignActive() {}
    open func sceneWillEnterForeground() {}
    open func sceneDidEnterBackground() {}


}

open class GMTabBarPage : UITabBarController, GMPageLifeCycle, GMAppLifeCycle, GMAppSceneCycle {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.registerApplocationLifecycleNotification()
        self.onPageInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final public override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageLoaded()
    }
    
    final public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.enablePopGesture = self.enablePopGesture
        self.onPageAppear()
    }

    final public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    
    final public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.onPageBoundsUpdated(self.view.bounds)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    open func onPageAppear() -> Void {}
    open func onPageDisappear()  -> Void {}
    open func onPageLoaded() -> Void {}
    open func onPageInit() -> Void {}
    open func onPageDestroy() -> Void {}
    open func onPageBoundsUpdated(_ bounds: CGRect) {}
    open func applicationDidBecomeActive(_ application: UIApplication) {}
    open func applicationWillResignActive(_ application: UIApplication) {}
    open func applicationDidEnterBackground(_ application: UIApplication) {}
    open func applicationWillEnterForeground(_ application: UIApplication) {}
    open func sceneDidBecomeActive() {}
    open func sceneWillResignActive() {}
    open func sceneWillEnterForeground() {}
    open func sceneDidEnterBackground() {}


}

open class GMListPage : UITableViewController, GMPageLifeCycle, GMAppLifeCycle, GMAppSceneCycle {
    
    public override init(style: UITableView.Style) {
        super.init(style: style)
        self.registerApplocationLifecycleNotification()
        self.onPageInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final public override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageLoaded()
    }
    
    final public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.enablePopGesture = self.enablePopGesture
        self.onPageAppear()
    }

    final public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    
    final public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.onPageBoundsUpdated(self.view.bounds)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    open func onPageAppear() -> Void {}
    open func onPageDisappear()  -> Void {}
    open func onPageLoaded() -> Void {}
    open func onPageInit() -> Void {}
    open func onPageDestroy() -> Void {}
    open func onPageBoundsUpdated(_ bounds: CGRect) {}
    open func applicationDidBecomeActive(_ application: UIApplication) {}
    open func applicationWillResignActive(_ application: UIApplication) {}
    open func applicationDidEnterBackground(_ application: UIApplication) {}
    open func applicationWillEnterForeground(_ application: UIApplication) {}
    open func sceneDidBecomeActive() {}
    open func sceneWillResignActive() {}
    open func sceneWillEnterForeground() {}
    open func sceneDidEnterBackground() {}

}

open class GMGridPage : UICollectionViewController, GMPageLifeCycle, GMAppLifeCycle, GMAppSceneCycle {
    
    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        self.registerApplocationLifecycleNotification()
        self.onPageInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final public override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageLoaded()
    }
    
    final public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.enablePopGesture = self.enablePopGesture
        self.onPageAppear()
    }

    final public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    final public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.onPageBoundsUpdated(self.view.bounds)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    open func onPageAppear() -> Void {}
    open func onPageDisappear()  -> Void {}
    open func onPageLoaded() -> Void {}
    open func onPageInit() -> Void {}
    open func onPageDestroy() -> Void {}
    open func onPageBoundsUpdated(_ bounds: CGRect) {}
    open func applicationDidBecomeActive(_ application: UIApplication) {}
    open func applicationWillResignActive(_ application: UIApplication) {}
    open func applicationDidEnterBackground(_ application: UIApplication) {}
    open func applicationWillEnterForeground(_ application: UIApplication) {}
    open func sceneDidBecomeActive() {}
    open func sceneWillResignActive() {}
    open func sceneWillEnterForeground() {}
    open func sceneDidEnterBackground() {}
}

/// Swift UI
@available(iOS 13.0, *)
public protocol GMSwiftUIPageView : View {
    var observedController:GMSwiftUIPageController? { get }
}

@available(iOS 13.0, *)
public extension GMSwiftUIPageView {
    
    var observedController:GMSwiftUIPageController? {
        return nil
    }
    
    var uiView:UIView? {
        return self.observedController?.uiView
    }
    
    var uiViewController:UIViewController? {
        return self.observedController?.uiViewController
    }
}

open class GMSwiftUIPageController : NSObject, GMPageLifeCycle, GMAppLifeCycle, GMAppSceneCycle, GMViewEventProtocol, GMPageAppearan {
    
    open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open weak fileprivate(set) var uiViewController:UIViewController?
    
    open weak fileprivate(set) var uiView:UIView?
    /// 绑定页面的bounds
    open fileprivate(set) var bounds:CGRect = .zero
    
    open func onPageBoundsUpdated(_ bounds: CGRect) {
        self.bounds = bounds
    }
    
    open func onPageAppear() -> Void {}
    open func onPageDisappear()  -> Void {}
    open func onPageLoaded() -> Void {}
    open func onPageInit() -> Void {}
    open func onPageDestroy() -> Void {}
    /// 开始
    open func touchesBegin() {}
    /// 移动
    open func touchesMove() {}
    ///  结束
    open func touchesEnd() {}
    /// 取消
    open func touchesCancel() {}
    
    open func applicationDidBecomeActive(_ application: UIApplication) {}
    open func applicationWillResignActive(_ application: UIApplication) {}
    open func applicationDidEnterBackground(_ application: UIApplication) {}
    open func applicationWillEnterForeground(_ application: UIApplication) {}
    open func sceneDidBecomeActive() {}
    open func sceneWillResignActive() {}
    open func sceneWillEnterForeground() {}
    open func sceneDidEnterBackground() {}
}

@available(iOS 13.0, *)
open class GMSwiftUIPage<Content> : UIHostingController<Content> where Content: GMSwiftUIPageView {
  
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return rootView.observedController?.preferredStatusBarStyle ?? .default
    }
    
    public override init(rootView: Content) {
        super.init(rootView: rootView)
        rootView.observedController?.uiViewController = self
        rootView.observedController?.uiView = self.view
        rootView.observedController?.registerApplocationLifecycleNotification()
        rootView.observedController?.onPageInit()
        rootView.observedController?.onPageLoaded()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    final public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.enablePopGesture = self.enablePopGesture
        rootView.observedController?.onPageAppear()
    }

    final public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.observedController?.onPageDisappear()
    }
    
    final public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.observedController?.onPageBoundsUpdated(self.view.bounds)
    }
    
    deinit {
        if let controller = self.rootView.observedController {
            NotificationCenter.default.removeObserver(controller)
        }
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.rootView.observedController?.onPageDestroy()
    }

}
