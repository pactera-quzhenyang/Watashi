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
        list.append("笔记本电脑")
        list.append("东方小魔方新品")
        list.append("免费问诊抗疫情")
        list.append("小米电脑")
        list.append("八音盒")
        list.append("双头u盘")
        list.append("休闲西裤")
        list.append("常购清单")
        list.append("二手苹果8p")
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
