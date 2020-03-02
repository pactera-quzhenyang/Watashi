//
//  SWABTestingManager.swift
//  Watashi+
//
//  Created by NULL on 2020/2/28.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWABTestingManager {
    static let shared = SWABTestingManager()
    lazy var shoppingCarts: [String: Any] = [:]
    private init() {
        
    }
}

extension SWABTestingManager {
    
    /// 添加购物车类型
    /// - Parameter shoppingCarts: 购物车类型
    class func add(_ shoppingCarts: [String: Any]) {
        SWABTestingManager.shared.shoppingCarts = shoppingCarts
    }
    
    /// 获取购物车类型
    class func shoppingCartsType() -> Any {
        let key = SWRCValueManager.shared.string(forKey: .shoppingCart)
        return SWABTestingManager.shared.shoppingCarts[key] as Any
    }
}
