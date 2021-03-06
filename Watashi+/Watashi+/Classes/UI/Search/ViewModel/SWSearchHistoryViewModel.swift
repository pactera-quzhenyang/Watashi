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
        list = SWSearchHistoryManager.shared.getSearchHistoryList()
    }

    func getDefaultData(toIndex: Int) -> [String] {
        guard toIndex > 0 else {
            return list
        }
        self.toIndex = toIndex
        var newData = [String]()
        for item in list.enumerated() {
            if item.offset > toIndex {
                if !surplusList.contains(item.element) {
                    surplusList.append(item.element)
                }
            } else {
                newData.append(item.element)
            }
        }
        return newData
    }

    func getAllHistoryData() -> [String] {
        var newData = list
        for item in surplusList.enumerated() {
            if !newData.contains(item.element) {
                newData.append(item.element)
            }
        }
        return newData
    }

    func addItemAtLast() -> [String] {
        var newData = list
        if let nextData = surplusList.first {
            newData.append(nextData)
        }
        return newData
    }

    func addItemAtSurplusListLast() {
        let list = SWSearchHistoryManager.shared.getSearchHistoryList()
        surplusList.append(list.last!)
    }
}
