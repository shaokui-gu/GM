//
//  Common.swift
//  GMDemo
//
//  Created by gavin on 2021/12/22.
//

import Foundation
import UIKit

extension UIViewController {
        
    public var topPresentedViewController: UIViewController {
        return presentedViewController?.topPresentedViewController ?? self
    }
    
    public static var rootViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.first { window in
            return window.isKeyWindow
        }
        return keyWindow?.rootViewController?.topPresentedViewController
    }
}

extension UIApplication {
    public var getFirstKeyWindow: UIWindow? {
        self.windows.first(where: { $0.isKeyWindow })
    }
}

