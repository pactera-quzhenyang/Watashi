//
//  FirstModel.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/20.
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

//IdentifiableType声明一个唯一的标识符（在同一具体类型的对象中是唯一的），以便RxDataSources唯一标识对象
//这里是将secondName属性值作为唯一标识对象
extension SectionDataModel: IdentifiableType{
    typealias Identity = String
    var identity:Identity {return "haha"}

}
