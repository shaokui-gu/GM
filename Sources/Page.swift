//
//  Page.swift
//  Polytime
//
//  Created by gavin on 2021/12/18.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation
import SwiftUI

protocol GMPageLifeCycle {
    func onPageAppear() -> Void
    func onPageDisappear()  -> Void
    func onPageInit() -> Void
    func onPageLoaded() -> Void
    func onPageDestroy() -> Void
    func onPageBoundsUpdated(_ bounds:CGRect) -> Void
}

protocol GMViewEventProtocol {
    
    /// 开始
    func touchesBegin() -> Void
    /// 移动
    func touchesMove() -> Void
    ///  结束
    func touchesEnd() -> Void
    /// 取消
    func touchesCancel() -> Void
    
}

open class GMPage : UIViewController, GMPageLifeCycle {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
    
    deinit {
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

    
}
 
open class GMNavigationPage : UINavigationController, GMPageLifeCycle {
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
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
    
    deinit {
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

}

open class GMTabBarPage : UITabBarController, GMPageLifeCycle {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
    
    deinit {
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

}

open class GMListPage : UITableViewController, GMPageLifeCycle {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
    
    deinit {
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
}

/// Swift UI
public protocol GMSwiftUIPageView : View {
    var observedController:GMSwiftUIPageController? { get }
}

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

open class GMSwiftUIPageController : NSObject, GMPageLifeCycle, GMViewEventProtocol {
    public weak fileprivate(set) var uiViewController:UIViewController?
    public weak fileprivate(set) var uiView:UIView?
    /// 绑定页面的bounds
    public fileprivate(set) var bounds:CGRect = .zero
    
    func onPageBoundsUpdated(_ bounds: CGRect) {
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

}

open class GMSwiftUIPage<Content> : UIHostingController<Content> where Content: GMSwiftUIPageView {
  
    public override init(rootView: Content) {
        super.init(rootView: rootView)
        rootView.observedController?.uiViewController = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final public override func viewDidLoad() {
        super.viewDidLoad()
        rootView.observedController?.uiView = self.view
        rootView.observedController?.onPageInit()
        rootView.observedController?.onPageLoaded()
    }
    
    final public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.rootView.observedController?.onPageDestroy()
    }

}
