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
    lazy var procotols: [Any] = []
    
    private init() {
        
    }
}

extension SWABTestingManager {
    class func add(_ procotols: [Any]) {
        SWABTestingManager.shared.procotols = procotols
    }
    
    class func testProtocol(at index: Int) -> Any {
        return SWABTestingManager.shared.procotols[index]
    }
}
