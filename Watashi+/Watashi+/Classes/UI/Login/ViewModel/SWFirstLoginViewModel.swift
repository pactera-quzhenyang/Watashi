//
//  SWFirstLoginViewModel.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/9.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWFirstLoginViewModel: NSObject {
    var dataList = [String]()

    override init() {
        super.init()
        dataList.append("ナチュラル")
        dataList.append("マキアージュ")
        dataList.append("モードスタイル")
        dataList.append("ベタつき")
        dataList.append("マキアージュ")
        dataList.append("にびき")
        dataList.append("乾燥肌")
        dataList.append("ｄプログラム")
        dataList.append("インテグレート")
    }
}
