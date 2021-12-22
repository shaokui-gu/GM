//
//  KKGM.swift
//  kroknow (iOS)
//
//  Created by gavin on 2021/6/8.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import UIKit
import MBProgressHUD

extension MBProgressHUD {
    
    // MARK: 显示信息
    private class func show(_ text:String? = nil, icon:String? = nil, view:UIView? = nil) {
        let view = view ?? GM.firstKeyWindow!
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.detailsLabel.text = text
        hud.contentColor = .white
        hud.detailsLabel.textColor = .white
        hud.detailsLabel.font = .systemFont(ofSize: 16)
        hud.bezelView.style = .solidColor;
        hud.bezelView.color = UIColor(named: "343A40_FFFFFF")
        // 设置图片
        if let icon = icon {
            hud.customView = UIImageView(image: UIImage(named: "GM.bundle/\(icon)"))
        }
        // 再设置模式
        hud.mode = .customView
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = true
        // 2秒之后再消失
        hud.hide(animated: true, afterDelay: 2.0)
    }
    
    // MARK: 显示错误信息
    class func showError(_ msg:String = "", to view:UIView?) {
        self.show(msg, icon: "error.png", view: view)
    }
    
    // MARK: 显示成功信息
    class func showSuccess(_ msg:String = "", to view:UIView?) {
        self.show(msg, icon: "success.png", view: view)
    }

    // MARK: 显示提示信息
    class func showTips(_ msg:String = "", to view:UIView?) {
        self.show(msg, view: view)
    }

    // MARK: 显示一些信息
    @discardableResult
    class func showMessage(_ msg:String = "", to view:UIView? = nil, hiddenDelay:TimeInterval? = nil) -> MBProgressHUD {
        let view = view ?? GM.firstKeyWindow!
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.detailsLabel.text = msg
        hud.contentColor = .white
        hud.detailsLabel.textColor = .white
        hud.detailsLabel.font = .systemFont(ofSize: 16)
        hud.bezelView.style = .solidColor;
        hud.bezelView.color = UIColor(named: "343A40_FFFFFF")
        hud.mode = .text
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = true
        if let hiddenDelay = hiddenDelay {
            hud.hide(animated: true, afterDelay: hiddenDelay)
        }
        return hud
    }
}


extension GM {
    
    static func showLoading(msg:String = "", view:UIView? = nil) {
        MBProgressHUD.showMessage(msg, to: view)
    }
    
    static func hideLoading(view:UIView? = nil) {
        MBProgressHUD.hide(for: view ??  GM.firstKeyWindow!, animated: true)
    }

    static func showSuccess(msg:String = "", view:UIView? = nil) {
        MBProgressHUD.showSuccess(msg, to: view)
    }
    
    static func showError(msg:String = "", view:UIView? = nil) {
        MBProgressHUD.showError(msg, to: view)
    }
    
    static func showMessage(msg:String = "", view:UIView? = nil) {
        MBProgressHUD.showTips(msg, to: view)
    }
}

extension GM {
    static var firstKeyWindow: UIWindow? {
        UIApplication.shared.getFirstKeyWindow
    }
}

