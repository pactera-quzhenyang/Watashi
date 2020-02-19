//
//  UIView+Rx.swift
//  zst
//
//  Created by 曲振阳 on 2020/2/14.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    //x轴移动动画
    var moveAnimated: Binder<UIButton> {
        return Binder(self.base) { view, button in
            UIView.animate(withDuration: 0.3, animations: {
                view.center.x = button.center.x
            })
        }
    }
}
