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
