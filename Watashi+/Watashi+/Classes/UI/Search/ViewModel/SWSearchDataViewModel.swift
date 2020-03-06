//
//  SWSearchDataViewModel.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/5.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SWSearchDataViewModel: NSObject {
    var dataList = [String]()

    func getData() {
        for _ in 0...10 {
            dataList.append("\(Int(arc4random()))")
        }
    }
}


extension Reactive where Base: SWSearchDataViewModel {
    var dataList: Binder<[String]> {
        return Binder(self.base) { viewModel, list in
            viewModel.dataList = list
        }
    }
}
