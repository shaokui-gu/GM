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

extension GMViewEventProtocol {
    /// 开始
    func touchesBegin() {
        
    }
    /// 移动
    func touchesMove() {
        
    }
    ///  结束
    func touchesEnd() {
        
    }
    /// 取消
    func touchesCancel() {
        
    }

}

class GMPage : UIViewController, GMPageLifeCycle {

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.onPageInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageLoaded()
    }
    
    final override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onPageAppear()
    }

    final override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    deinit {
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    func onPageAppear() -> Void {}
    func onPageDisappear()  -> Void {}
    func onPageLoaded() -> Void {}
    func onPageInit() -> Void {}
    func onPageDestroy() -> Void {}
    func onPageBoundsUpdated(_ bounds: CGRect) {}
    
}

class GMNavigationPage : UINavigationController, GMPageLifeCycle {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.onPageInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageLoaded()
    }
    
    final override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onPageAppear()
    }

    final override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    deinit {
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    func onPageAppear() -> Void {}
    func onPageDisappear()  -> Void {}
    func onPageLoaded() -> Void {}
    func onPageInit() -> Void {}
    func onPageDestroy() -> Void {}
    func onPageBoundsUpdated(_ bounds: CGRect) {}
}

class GMTabBarPage : UITabBarController, GMPageLifeCycle {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.onPageInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageLoaded()
    }
    
    final override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onPageAppear()
    }

    final override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    deinit {
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    func onPageAppear() -> Void {}
    func onPageDisappear()  -> Void {}
    func onPageLoaded() -> Void {}
    func onPageInit() -> Void {}
    func onPageDestroy() -> Void {}
    func onPageBoundsUpdated(_ bounds: CGRect) {}
}

class GMListPage : UITableViewController, GMPageLifeCycle {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.onPageInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        self.onPageInit()
    }
    
    final override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onPageAppear()
    }

    final override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onPageDisappear()
    }
    
    deinit {
        if let identifire = self.routeIdentifire {
            Router.shared.removePage(identifire)
        }
        self.onPageDestroy()
    }
    
    func onPageAppear() -> Void {}
    func onPageDisappear()  -> Void {}
    func onPageLoaded() -> Void {}
    func onPageInit() -> Void {}
    func onPageDestroy() -> Void {}
    func onPageBoundsUpdated(_ bounds: CGRect) {}
}

/// Swift UI
protocol GMSwiftUIPageView : View {
    var observedController:GMSwiftUIPageController? { get }
}

extension GMSwiftUIPageView {
    
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

class GMSwiftUIPageController : NSObject, GMPageLifeCycle, GMViewEventProtocol {
    weak fileprivate(set) var uiViewController:UIViewController?
    weak fileprivate(set) var uiView:UIView?
    /// 绑定页面的bounds
    fileprivate(set) var bounds:CGRect = .zero
    func onPageBoundsUpdated(_ bounds: CGRect) {
        self.bounds = bounds
    }
    func onPageAppear() -> Void {}
    func onPageDisappear()  -> Void {}
    func onPageLoaded() -> Void {}
    func onPageInit() -> Void {}
    func onPageDestroy() -> Void {}
}

class GMSwiftUIPage<Content> : UIHostingController<Content> where Content: GMSwiftUIPageView {
  
    override init(rootView: Content) {
        super.init(rootView: rootView)
        rootView.observedController?.uiViewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        rootView.observedController?.uiView = self.view
        rootView.observedController?.onPageInit()
        rootView.observedController?.onPageLoaded()
    }
    
    final override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.observedController?.onPageAppear()
    }

    final override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.observedController?.onPageDisappear()
    }
    
    final override func viewDidLayoutSubviews() {
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
