//
//  States.swift
//  Polytime
//
//  Created by gavin on 2021/12/17.
//  Copyright © 2021 cn.kroknow. All rights reserved.
//

import Foundation

public protocol StateObjectProtocol {
    var identifire:String { get set }
}

class States {
    public class Weak {
      weak var value : NSObject?
      init (value: NSObject) {
        self.value = value
      }
    }

    static let shared = States()
    
    /// States
    /// 状态列表
    private(set) var all:[Weak] = []
    
    private init(){}
    
    /// 添加状态
    /// - Parameter state: 状态
    func put<T:NSObject>(_ state:T) {
        all.append(States.Weak(value: state))
    }
    
    /// 删除状态
    /// - Parameter state: 状态
    func pop<T:NSObject>(_ state:T) {
        all.removeAll { item in
            return item.value == state
        }
    }
}


extension GM {
    
    /// 添加状态
    /// - Parameter state: 状态
    public static func put<T:NSObject>(_ state:T) {
        GM.log(GM.StateLogPrefix, "添加状态", state)
        States.shared.put(state)
    }
    
    /// 删除状态
    /// - Parameter state: 状态
    public static func pop<T:NSObject>(_ state:T) {
        GM.log(GM.StateLogPrefix, "删除状态", state)
        States.shared.pop(state)
    }
    
    /// 查找状态
    /// - Parameters:
    ///   - state: 状态类型
    ///   - identifire: 状态id
    /// - Returns: 状态
    public static func find<T:StateObjectProtocol>(_ state:T.Type, identifire:String) -> T? {
        let result = States.shared.all.filter { state in
            return (state.value as? T)?.identifire == identifire
        }.last
        return result?.value as? T
    }
    
    /// 查找状态
    /// - Parameter state: 状态类型
    /// - Returns: 状态
    public static func find<T:NSObject>(_ state:T.Type) -> T? {
        let result = States.shared.all.filter { state in
            return state.value is T
        }.last
        return result?.value as? T
    }
}
