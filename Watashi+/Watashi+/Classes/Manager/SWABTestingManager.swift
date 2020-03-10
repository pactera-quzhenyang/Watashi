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
    
    class func string(forKey key: String) -> String {
        return SWRCValueManager.shared.string(forKey: key)
    }
}

extension SWABTestingManager {
    class func fetchShoppingCartTest<T: SWShoppingABTestProtocol>(_ type: T.Type) -> T {
        return T()
    }
    
    class func shoppingCartsTypes() -> Any {
        let key = string(forKey: shoppingCart)
        switch key {
        case SWRemoteConfigValue.shoppingCartA.rawValue:
            return SWShoppingABTestViewModelA()
        case SWRemoteConfigValue.shoppingCartB.rawValue:
            return SWShoppingABTestViewModelB()
        default:
            return Any.self
        }
    }
    
    
    class func shoppingCartsHeight() -> CGFloat {
        let key = string(forKey: shoppingCart)
        switch key {
        case SWRemoteConfigValue.shoppingCartA.rawValue:
            return 170
        case SWRemoteConfigValue.shoppingCartB.rawValue:
            return 200
        default:
            return 0
        }
    }
    
    class func shoppingCartsRequest() {
        
    }
}
