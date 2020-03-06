//
//  SWSearchFoundViewModel.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/4.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWSearchFoundViewModel: NSObject {
    var list = [String]()
    var saveList = [String]()

    override init() {
        list.append("ラップトップ")
        list.append("ニューオリエンタルルービックキューブ")
        list.append("抗流行状況に関する無料相談")
        list.append("Xiaomiコンピューター")
        list.append("オルゴール")
        list.append("ダブルヘッドUディスク")
        list.append("カジュアルパンツ")
        list.append("よく購入するリスト")
        list.append("使用済みのApple 8p")
        list.append("iphone11")
    }

    func removeAllData() -> [String] {
        for item in list.enumerated() {
            saveList.append(item.element)
        }
        list.removeAll()
        return list
    }

    func showAllData() -> [String] {
        for item in saveList.enumerated() {
            list.append(item.element)
        }
        saveList.removeAll()
        return list
    }
}
