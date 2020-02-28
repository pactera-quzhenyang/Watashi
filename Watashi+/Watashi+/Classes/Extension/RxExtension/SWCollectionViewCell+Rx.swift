
//
//  SWCollectionView+Rx.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/28.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: SWSearchHistoryCollectionViewCell {

    var selectIndex: Binder<Int> {
        return Binder(self.base) { cell, index  in
            cell.selectIndex = index
        }
    }
}

extension Reactive where Base: SWSearchHistoryViewModel {

    var deleteItemAtIndexPath: Binder<Int> {
        return Binder(self.base) { model, index  in
            model.list.remove(at: index)
        }
    }
}
