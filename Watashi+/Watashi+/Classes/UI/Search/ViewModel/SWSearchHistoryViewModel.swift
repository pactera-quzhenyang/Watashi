//
//  SWSearchHistoryViewModel.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SWSearchHistoryViewModel: NSObject {
    var list = [String]()
    var surplusList = [String]()
    var toIndex: Int!
    override init() {
        list.append("iphonexsmadaskldaskldjalskdjalsjdlaskdjalskdjalskdjalskdjalskdjaslkdjalskdjalskdjalskdjaslkdjalskdjdjaskldjaklsjax")
        list.append("iphone")
        list.append("面膜")
        list.append("电脑桌")
        list.append("电竞椅")
        list.append("iphone8 plus")
        list.append("氨基酸洗面奶")
        list.append("空气清新剂")
        list.append("iphonexsmax")
    }

    func getDefaultData(toIndex: Int) -> [String] {
        self.toIndex = toIndex
        var newData = [String]()
        for item in list.enumerated() {
            if item.offset > toIndex {
                surplusList.append(item.element)
            } else {
                newData.append(item.element)
            }
        }
        return newData
    }

    func getAllHistoryData() -> [String] {
        var newData = list
        for item in surplusList.enumerated() {
            newData.append(item.element)
        }
        surplusList.removeAll()
        return newData
    }

    func addItemAtLast() -> [String] {
        var newData = list
        if let nextData = surplusList.first {
            newData.append(nextData)
            surplusList.removeFirst()
        }
        return newData
    }
}
