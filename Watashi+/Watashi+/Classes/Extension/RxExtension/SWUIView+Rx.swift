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

    var touchbegin: Binder<Void> {
        return Binder(self.base) { view, void in
            
        }
    }
}

extension Reactive where Base: SWSearchHistoryView {
    var selectIndex: Binder<Int> {
        return Binder(self.base) { view, index in
            view.selectIndex = index
        }
    }

    var isShowAll: Binder<Bool> {
        return Binder(self.base) { view, isShowAll in
            view.isShowAll = isShowAll
        }
    }
}

extension Reactive where Base: UIButton {

    var showImage: Binder<Bool> {
        return Binder(self.base) { view, select in
            if select {
                view.setImage(UIImage(named: "up"), for: .normal)
            } else {
                view.setImage(UIImage(named: "down"), for: .normal)
            }
        }
    }
}
