//
//  SectionDataModel.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/24.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxDataSources

struct SectionDataModel {
    let imageArray: [String]?

    init(imageArray: [String]?) {
        self.imageArray = imageArray
    }
}

extension SectionDataModel: IdentifiableType{
    typealias Identity = String
    var identity:Identity {
        return "haha"
    }
}
