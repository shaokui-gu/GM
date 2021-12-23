//
//  App.swift
//  Polytime
//
//  Created by gavin on 2021/12/17.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation

extension GM {
    /// app 版本号
    public static var appVersion:String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String) ?? "0"
    }
        
    /// Build Version
    public static var buildVersion:String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
}
