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
    var list = Array<String>()
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
}
