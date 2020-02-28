//
//  SWABTestBViewModel.swift
//  Watashi+
//
//  Created by NULL on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
class SWABTestBViewModel: NSObject, ABTestProtocol {
//    typealias T = UIButton
    
//    func testButton<T>() -> T {
//        let but = UIButton()
//        but.backgroundColor = .green
//        but.rx.tap.subscribe { (event) in
//            print("bbbbbb")
//        }
//
//        return but as! T
//    }
    
    func testButton() -> UIButton {
        let but = UIButton()
        but.backgroundColor = .green
        but.rx.tap.subscribe { (event) in
            print("bbbbbbbb")
        }
        
        return but
    }
}
