//
//  SWSearchHistoryManager.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/3.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWSearchHistoryManager: NSObject {
    static let shared = SWSearchHistoryManager()

    var isShowAll = false //是否展示全部
    var isHideSearchHistory = false // 是否隐藏搜索发现
    let SWSearchHistoryListUserDefaultKey = "SWSearchHistoryListUserDefaultKey"

    func getSearchHistoryList() -> [String] {
        if let historyList = UserDefaults.standard.array(forKey: SWSearchHistoryListUserDefaultKey) {
            return historyList as! [String]
        }
        return []
    }

    func saveSearchText(_ text: String) {
        if var historyList = UserDefaults.standard.array(forKey: SWSearchHistoryListUserDefaultKey) as? [String] {
            if !historyList.contains(text) {
                historyList.append(text)
                UserDefaults.standard.set(historyList, forKey: SWSearchHistoryListUserDefaultKey)
            }
        } else {
            UserDefaults.standard.set([text], forKey: SWSearchHistoryListUserDefaultKey)
        }
    }

    func deleteSearchHistoryAtIndex(index: Int) {
        if var historyList = UserDefaults.standard.array(forKey: SWSearchHistoryListUserDefaultKey) {
            historyList.remove(at: index)
            UserDefaults.standard.set(historyList, forKey: SWSearchHistoryListUserDefaultKey)
        }
    }

    func deleteAllSearchHistory() {
        UserDefaults.standard.removeObject(forKey: SWSearchHistoryListUserDefaultKey)
    }
}
