//
//  SectionDataModel.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/24.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxDataSources

struct SWCheckNewProductsModel {
    let imageArray: [String]?

    init(imageArray: [String]?) {
        self.imageArray = imageArray
    }
}
