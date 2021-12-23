//
//  Log.swift
//  Polytime
//
//  Created by gavin on 2021/12/17.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation

extension GM {
    
    public static let LifeCycleLogPrefix = "【 LIFECYCLE 】:"
    public static let NetworkLogPrefix = "【 NETWORK 】:"
    public static let StateLogPrefix = "【 STATE 】:"
    public static let ErrorLogPrefix = "【 ERROR 】:"
    
    public static func log(_ logPrefix:String = "【GM】:",_ items: Any...) {
        print(logPrefix, items)
    }
    public static func logErr(_ items: Any...) {
        print(ErrorLogPrefix, items)
    }
}
