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

    fileprivate let minBadgeValue = 0

    fileprivate let maxBadgeValue = 99

    func addBadgeValue(count: Int = 1) {
        let newBadgeValue = (Int(badgeValue)!) + count
        guard newBadgeValue <= maxBadgeValue else {
            badgeValue = "\(maxBadgeValue)+"
            return
        }
        badgeValue = "\(newBadgeValue)"
    }

    func reduceBadgeValue(count: Int = 1) {
        let newBadgeValue = (Int(badgeValue)!) - count
        badgeValue = newBadgeValue >= minBadgeValue ? "\(newBadgeValue)" : "\(minBadgeValue)"
    }

    func clearBadgeValue() {
        badgeValue = "\(minBadgeValue)"
    }
}
