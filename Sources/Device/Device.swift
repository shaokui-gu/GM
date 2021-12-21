//
//  Device.swift
//  Polytime
//
//  Created by gavin on 2021/12/17.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation
import UIKit
import OpenUDID
import SwiftUI

extension GM {
    
    private class GMDevice {
        
        static let current = GMDevice()
        
        private init(){}
        
        /// 微微震动
        let softImpack = UIImpactFeedbackGenerator.init(style: .soft)
        
        /// 默认震动
        let defaultImpack = UIImpactFeedbackGenerator.init()
        
        /// 强烈震动
        let heavyImpack = UIImpactFeedbackGenerator.init(style: .heavy)

        /// 安全区域
        var safeArea:UIEdgeInsets = .zero
        
        /// 屏幕尺寸
        var windowSize:CGSize = CGSize.zero
        
        /// 安全区域尺寸
        var safeAreaSize:CGSize = CGSize.zero
        
        /// 系统是否是中文
        var isChinese:Bool {
            let language = systemLanguage()
            return language == "zh-Hans-CN"
        }
        
        /// 获取系统语言
        func systemLanguage() -> String {
            let userDefault = UserDefaults.standard
            let languages:[String]? = userDefault.object(forKey:"AppleLanguages") as? [String]
            return languages?.first ?? ""
        }
        
        /// 设备ID
        lazy var deviceID:String = {
            let udid = OpenUDID.value()!
            return udid
        }()

    }
    
    /// 微微震动
    static func shakeSoft() {
        GMDevice.current.softImpack.prepare()
        GMDevice.current.softImpack.impactOccurred()
    }
    
    /// 强烈震动
    static func shakeHeavy() {
        GMDevice.current.heavyImpack.prepare()
        GMDevice.current.heavyImpack.impactOccurred()
    }
    
    /// 默认震动
    static func shake() {
        GMDevice.current.defaultImpack.prepare()
        GMDevice.current.defaultImpack.impactOccurred()
    }
    
    /// 安全区域
   static  var safeArea:UIEdgeInsets {
        get {
            return GMDevice.current.safeArea
        }
        set {
            GMDevice.current.safeArea = newValue
        }
    }
    
    /// 屏幕尺寸
    static var windowSize:CGSize {
        get {
            return GMDevice.current.windowSize
        }
        set {
            GMDevice.current.windowSize = newValue
        }
    }
    
    /// 安全区域尺寸
    static var safeAreaSize:CGSize  {
        get {
            return GMDevice.current.safeAreaSize
        }
        set {
            GMDevice.current.safeAreaSize = newValue
        }
    }
    
    /// 系统是否是中文
    static var isChinese:Bool {
        return  GMDevice.current.isChinese
    }
    
    /// 获取系统语言
    static func systemLanguage() -> String {
        return  GMDevice.current.systemLanguage()
     }
    
    /// 设备ID
    static var deviceID:String {
        return GMDevice.current.deviceID
    }

}

