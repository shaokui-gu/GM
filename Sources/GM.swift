//
//  GM.swift
//  Polytime
//
//  Created by gavin on 2021/12/17.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation
import UIKit

public class GM {}

public class GMWindow : UIWindow {
    public override var rootViewController: UIViewController? {
        get {
            return super.rootViewController
        }
        set {
            assertionFailure("不可操作")
        }
    }
    
    public func setRootPage(_ name:String, params:[String : Any]? = nil) {
        guard let rootPage = Router.shared.routePageFor(name) else {
            assertionFailure("\(name) 页面未注册")
            return
        }
        let controller = rootPage.page(params)
        let page = Router.Page(name, id:0, controller: controller)
        GM.setRoot(page)
        super.rootViewController = GMNavigationPage(rootViewController: controller)
    }
}

public class GMAppDelegate : UIResponder, UIApplicationDelegate {
    public var window:GMWindow? {
        didSet {
            if let window = window {
                GM.windowSize = window.bounds.size
                var safeAreaInset = window.safeAreaInsets
                safeAreaInset.top = max(20, window.safeAreaInsets.top)
                safeAreaInset.bottom = max(15, window.safeAreaInsets.bottom)
                GM.safeArea = safeAreaInset
                let safeAreaSize = CGSize.init(width: window.bounds.size.width - window.safeAreaInsets.left - window.safeAreaInsets.right, height: window.bounds.size.height - window.safeAreaInsets.top - window.safeAreaInsets.bottom)
                GM.safeAreaSize = safeAreaSize
            }
        }
    }
}

public class  GMSceneDelegate: UIResponder, UIWindowSceneDelegate {
    public var window:GMWindow? {
        didSet {
            if let window = window {
                GM.windowSize = window.bounds.size
                var safeAreaInset = window.safeAreaInsets
                safeAreaInset.top = max(20, window.safeAreaInsets.top)
                safeAreaInset.bottom = max(15, window.safeAreaInsets.bottom)
                GM.safeArea = safeAreaInset
                let safeAreaSize = CGSize.init(width: window.bounds.size.width - window.safeAreaInsets.left - window.safeAreaInsets.right, height: window.bounds.size.height - window.safeAreaInsets.top - window.safeAreaInsets.bottom)
                GM.safeAreaSize = safeAreaSize
            }
        }
    }
}
