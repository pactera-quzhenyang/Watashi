//
//  SWTabbarBadgeValueManager.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/6.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWTabbarBadgeValueManager: NSObject {

    static let shared = SWTabbarBadgeValueManager()

    private(set) var badgeValue: String = "6"

    fileprivate let maxBadgeValue = 99

    func addBadgeValue() {
        let newBadgeValue = (Int(badgeValue)!) + 1
        guard newBadgeValue <= maxBadgeValue else {
            badgeValue = "\(maxBadgeValue)+"
            return
        }
        badgeValue = "\(newBadgeValue)"
    }

    func reduceBadgeValue() {
        badgeValue = "\(Int(badgeValue)! - 1)"
    }
}
