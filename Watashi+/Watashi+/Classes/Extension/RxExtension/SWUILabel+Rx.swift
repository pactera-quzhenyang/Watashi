
//
//  SWUILabel+Rx.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

extension Reactive where Base: UILabel {

    var isLongPress: Binder<Bool> {
        return Binder(self.base) { label, isLongPress  in
            if isLongPress {
                label.snp.updateConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                }
            } else {
                label.snp.updateConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
                }
            }
        }
    }
}
