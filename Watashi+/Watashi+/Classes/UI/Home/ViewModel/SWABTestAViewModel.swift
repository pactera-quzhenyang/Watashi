//
//  SWABTestAViewModel.swift
//  Watashi+
//
//  Created by NULL on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
class SWABTestAViewModel: NSObject, ABTestProtocol {
//    typealias Item = UIButton
//    func testButton<Item>() -> Item {
//        let but = UIButton()
//        but.backgroundColor = .red
//        but.rx.tap.subscribe { (event) in
//            print("aaaaaaaa")
//        }
//        return but as! Item
//    }
    
    func testButton() -> UIButton {
        let but = UIButton()
        but.backgroundColor = .red
        but.rx.tap.subscribe { (event) in
            print("aaaaaaaa")
        }
        return but
    }
}
