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

open class GMWindow : UIWindow {
    open override var rootViewController: UIViewController? {
        get {
            return super.rootViewController
        }
        set {
            assertionFailure("不可操作")
        }
    }
    
    open func setRootPage(_ name:String, params:[String : Any]? = nil, useNavigation:Bool = true) {
        guard let rootPage = Router.shared.routePageFor(name) else {
            assertionFailure("\(name) 页面未注册")
            return
        }
        let controller = rootPage.page(params)
        let page = Router.Page(name, id:0, controller: controller)
        GM.setRoot(page)
        if useNavigation {
            super.rootViewController = GMNavigationPage(rootViewController: controller)
        } else {
            super.rootViewController = controller
        }
    }
}

open class GMAppDelegate : UIResponder, UIApplicationDelegate {
    open var window:GMWindow? {
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

open class  GMSceneDelegate: UIResponder, UIWindowSceneDelegate {
    open var window:GMWindow? {
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
