//
//  Log.swift
//  Polytime
//
//  Created by gavin on 2021/12/17.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation

extension GM {
    
    static let LifeCycleLogPrefix = "【 LIFECYCLE 】:"
    static let NetworkLogPrefix = "【 NETWORK 】:"
    static let StateLogPrefix = "【 STATE 】:"
    static let ErrorLogPrefix = "【 ERROR 】:"
    
    static func log(_ logPrefix:String = "【GM】:",_ items: Any...) {
        print(logPrefix, items)
    }
    static func logErr(_ items: Any...) {
        print(ErrorLogPrefix, items)
    }
}
