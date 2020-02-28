//
//  SWUITextFiled+Rx.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {

    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
