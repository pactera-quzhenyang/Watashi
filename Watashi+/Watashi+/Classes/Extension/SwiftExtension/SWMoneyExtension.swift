//
//  Int64+Extension.swift
//  hachijuni-dev
//
//  Created by madao23 on 2018/11/28.
//  Copyright © 2018 SCSK Corporation. All rights reserved.
//

import Foundation

extension Int64 {

    public func formatMoney(currencyCode: String? = nil, isMinus: Bool = false) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        if let code = currencyCode, !code.isEmpty {
            if code == "JPY" {
                formatter.numberStyle = .currency
            } else {
                formatter.numberStyle = .currencyISOCode
            }
            formatter.currencyCode = code
        } else {
            formatter.numberStyle = .currency
            formatter.currencyCode = "JPY"
        }
        let number = NSNumber.init(value: abs(self))
        var money = formatter.string(from: number) ?? ""
        if let code = currencyCode, code != "JPY" {
            if isMinus || self < 0 {
                // other code add space and minus
                money = money.replacingOccurrences(of: code, with: "\(code) -")
            } else {
                // other code add space
                money = money.replacingOccurrences(of: code, with: "\(code) ")
            }
        } else {
            if isMinus || self < 0 {
                // JPY add minus2
                money = money.replacingOccurrences(of: "¥", with: "¥-")
            }
        }
        return money
    }
}

extension Double {

    public func formatMoney(currencyCode: String? = nil, isMinus: Bool = false) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        if let code = currencyCode, !code.isEmpty {
            if code == "JPY" {
                formatter.numberStyle = .currency
            } else {
                formatter.numberStyle = .currencyISOCode
            }
            formatter.currencyCode = code
        } else {
            formatter.numberStyle = .currency
            formatter.currencyCode = "JPY"
        }
        let number = NSNumber.init(value: abs(self))
        var money = formatter.string(from: number) ?? ""
        if let code = currencyCode, code != "JPY" {
            if isMinus || self < 0 {
                // other code add space and minus
                money = money.replacingOccurrences(of: code, with: "\(code) -")
            } else {
                // other code add space
                money = money.replacingOccurrences(of: code, with: "\(code) ")
            }
        } else {
            if isMinus || self < 0 {
                // JPY add minus
                money = money.replacingOccurrences(of: "¥", with: "¥-")
            }
        }
        return money
    }
}
