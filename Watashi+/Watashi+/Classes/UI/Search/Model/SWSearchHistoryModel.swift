//
//  SWSearchHistoryModel.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxDataSources

class SWSearchHistoryModel: NSObject {
    let tagList:[String]?

    init(tagList: [String]?) {
        self.tagList = tagList
    }
}


enum SectionItem {
    case SearchResultItem(title: String)
    case SearchHistoryItem(model: SWSearchHistoryModel)
}

//自定义Section
struct MySection {
    var header: String
    var items: [SectionItem]
}

extension MySection : SectionModelType {
    typealias Item = SectionItem

    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
