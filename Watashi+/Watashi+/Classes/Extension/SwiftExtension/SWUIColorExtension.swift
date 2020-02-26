//
//  UIColorExtension.swift
//  BTAB
//
//  Created by 曲振陽 on 2019/5/30.
//  Copyright © 2019 曲振陽. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        let red: CGFloat = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green: CGFloat = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue: CGFloat = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 16進文字初期化
    ///
    /// - Parameter hex: 16進文字, ex. FF00000 or #FF00000
    convenience init(hexWithString hex: String, alpha: CGFloat = 1.0) {

        // 数値処理
        var cString = hex.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        let length = (cString as NSString).length
        // エラー処理
        if length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7) {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }

        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }

        // 文字列切り出し
        var range = NSRange()
        range.location = 0
        range.length = 2

        let rString = (cString as NSString).substring(with: range)

        range.location = 2
        let gString = (cString as NSString).substring(with: range)

        range.location = 4
        let bString = (cString as NSString).substring(with: range)

        var rValue: UInt32 = 0, gValue: UInt32 = 0, bValue: UInt32 = 0
        Scanner(string: rString).scanHexInt32(&rValue)
        Scanner(string: gString).scanHexInt32(&gValue)
        Scanner(string: bString).scanHexInt32(&bValue)
        // 色値によって作成するUIColor
        self.init(red: CGFloat(rValue)/255.0, green: CGFloat(gValue)/255.0, blue: CGFloat(bValue)/255.0, alpha: 1.0)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}
