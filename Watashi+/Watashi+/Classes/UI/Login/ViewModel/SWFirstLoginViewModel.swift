//
//  SWFirstLoginViewModel.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/9.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWFirstLoginViewModel: NSObject {
    var titleString: String!

    convenience init(title: String) {
        self.init()
        self.titleString = title
    }
}
