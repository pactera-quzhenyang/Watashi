//
//  SWStringExtension.swift
//  Watashi+
//
//  Created by NULL on 2020/3/4.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

extension String {

    /// 文字列マッチ
    ///
    /// - Parameter regex: マッチ範囲
    /// - Returns: 必要ありの文字列
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }

    /// 日付を取得する
    ///
    /// - Parameter formatterString: インプットデータのフォマット
    /// - Returns: 日付
    func getDate(_ formatterString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        formatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        return formatter.date(from: self)
    }

    /// 文字の範囲を取得する
    ///
    /// - Parameter r: 文字の範囲
    subscript(r: Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return String(self[startIndex..<endIndex])
    }

    /// ファイルからメッセージを取得する
    ///
    /// - Parameter identifier: メッセージID
    /// - Returns: メッセージ内容
    func makeMessage() -> String {
        let message = NSLocalizedString(self, comment: "")
        return message
    }

    fileprivate func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    // 文字列は空っぽにするかどうか
    var isEmpty: Bool {
        if self.count == 0 || trim().count == 0 {
            return true
        }
        return false
    }

    // 文字列は有効数子である
    var isNumber: Bool {
        if self.count == 0 {
            return true
        }
        let regex = "^[\\d]+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    // メールのフォーマット
    var isEmail: Bool {
        let regex = "(?:[-!#-\\'*+\\x2f-9=?A-Z^-~]+(?:\\.[-!#-\\'*+\\x2f-9=?A-Z^-~]+)*|\"(?:[!#-\\[\\]-~]|\\\\[\\x09 -~])*\")@[-!#-\\'*+\\x2f-9=?A-Z^-~]+(?:\\.[-!#-\\'*+\\x2f-9=?A-Z^-~]+)*"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //携帯電話（日本）
    var isPhoneNo: Bool {
        let regex = "^[\\d]{11}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //携帯電話（日本）cardloan
    var isPhoneCardLoanNo: Bool {
        let regex = "^[\\d]{10}$|^[\\d]{11}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //自宅電話番号（日本)
    var isTeleNo: Bool {
        let regex = "^[\\d]{10}$|^[\\d]{11}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //郵便番号（日本)
    var isPostCode: Bool {
        let regex = "^[\\d]{7}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //氏名（カナ）
    var isKanaPersonName: Bool {
        // 半角文字が含まれている
        let regex = "(?:[ァ-ンー]|[ヾヽヷヰヸヴヱヹヲヺ])+"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //会社名（カナ）
    var isKanaCompanyName: Bool {
        if self != self.zenkakuString { return false }
        let regex = "(?:[アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン]|[ヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ]|[ァィゥェォヵヶッャュョヮ]|[０-９]|[ａ-ｚＡ-Ｚ])+"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //全角カナ住所
    var isKanaAddress: Bool {
        let regex = "^(?:[ァ-ン]|[ヾヽヷヰヸヴヱヹヲヺ]|[ａ-ｚＡ-Ｚ]|[0-9]|[\\uFF10-\\uFF19]|[ﾟﾞ]|[\\u3000]|[（）]|[ー|−|―|－])+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //全角漢字
    var isKanjiName: Bool {
        let regex = "(?:[一-龥]|[ぁ-んァ-ン]|[〃仝々]|[ゞゝゐゔゑ]|[ヾヽヷヰヸヴヱヹヲヺヶ]|[ａ-ｚＡ-Ｚ]|ー)+"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    var isJapanese: Bool {
        let regex = "(?:[一-龥]|[〃仝々]|[ゞゝゐゔゑ]|[ヾヽヷヰヸヴヱヹヲヺ]|ー)+"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    //半角英数記号文字を入力
    var isAlphanumeric: Bool {
        let regex = "^[0-9a-zA-Z\\u0000-\\u00FF]$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    // 住所（漢字）（全角）
    var isKanjiAddress: Bool {
        // 半角文字が含まれている
        if self != self.zenkakuString { return false }
        let regex = "^(?:[ぁ-んァ-ン]|[一-龥]|[〃仝々]|[ゞゝゐゔゑ]|[ヾヽヷヰヸヴヱヹヲヺヶ]|[ａ-ｚＡ-Ｚ]|[0-9\\uFF10-\\uFF19]|[ﾟﾞ]|[\\u3000]|[\\\\]|[（！“\"＃＄％＆'＊＋－～、。／：；＜＞＝？＠＾＿’｛｝「」│￥”～）]|[ー|−|―|－]|[〜])+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    //半角英文記号文字を入力
    var isEnCharacter: Bool {
        let regex = "^[a-zA-Z]+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    var isEnAddress: Bool {
        if self.contains(";") {
            return false
        }
        let regex = "^[a-zA-Z0-9#\\$%'\\(\\)\\* \\+,\\-_\\./:<=>\\?@\\|]+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    var isInternetBankPassword: Bool {
        let regex = "^[A-Z0-9]+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    // 文字列は暗号にするかどうか
    var isPassWord: Bool {
        if self.count == 0 {
            return true
        }
        //let regex = "[0-9A-Za-z]{6,20}"
        let regex = "[0-9A-Za-z]{6,}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    var isCardLoanPassWord: Bool {
        if self.count == 0 {
            return true
        }
        //let regex = "[0-9A-Za-z]{6,20}"
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    //非半角英数記号文字を入力
    var isNotAlphanumeric: Bool {
        let newString = self as NSString
        var isNotAlphanumeric = true
        for i in 0..<newString.length {
            let singlechar = newString.substring(with: NSRange.init(location: i, length: 1))
            if singlechar.isAlphanumeric {
                isNotAlphanumeric = false
            }
        }
        return isNotAlphanumeric
    }

    //kanji address
    var isAddressKanji: Bool {
        return !self.isEmpty
    }

    //全角カナ英数記号
    var isAddressKana: Bool {
        let regex = "^(?:[ぁ-んァ-ンー0-9a-zA-Zａ-ｚＡ-Ｚｱ-ﾝｰ\\uFF10-\\uFF19ﾟﾞ（!\"#$%&'()*+,-./:;<=>?@[\\\\]^_`{|}~）]|[一-龥ぁ-ん]|ー)+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    //電話番号（職場）
    var isWorkTeleNumber: Bool {
        let regex = "^[\\d]{10}$|^[\\d]{11}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    //記号（! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~）以外の記号文字を入力
    //"^(?:[ｱ-ﾝｰﾟﾞぁ-んァ-ンー0-9\uFF10-\uFF19a-zA-Zａ-ｚＡ-Ｚ（!\"#$%&'()*+,-./:;<=>?@[\\\\]^_`{|}~）]|[一-龥ぁ-ん]|ー)+$"
    var isSign: Bool {
        let regex = "^(?:[〃仝ゞゝヾヽ々ｱ-ﾝｰﾟﾞぁ-んァ-ンー0-9\\uFF10-\\uFF19a-zA-Zａ-ｚＡ-Ｚ（!\"#$%&'()*+,-./:;<=>?@[\\\\]^_`{|}~）]|[一-龥ぁ-ん]|ー)+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }

    //漢字第１、第２水準
    var isShiftJIS: Bool {
        var string = self
        for replacingString in ["～", "∥", "－", "￠", "￡", "￢", "―"] {
            string = string.replacingOccurrences(of: replacingString, with: "")
        }
        return string.canBeConverted(to: .iso2022JP)
    }

}

// MARK: - cardloan check
extension String {
    var isCardLoanTele: Bool {
        let tele = self
        if tele.count == 11 {
            return self.checkTeleAndPhoneCount11()
        }
        if tele.count == 10 {
            return tele[0] == "0" && tele[1] != "0"
        }
        return false
    }

    var isCardLoanPhone: Bool {
        let phone = self
        if phone.count == 11 {
            return self.checkTeleAndPhoneCount11()
        }
        return false
    }

    func checkTeleAndPhoneCount11() -> Bool {
        let allowNumberHeader = ["090", "080", "070", "050"]
        if self.count == 11 {
            let numberHeader = self[0...2]
            let index = allowNumberHeader.index(of: numberHeader)
            return index != nil
        }
        return false
    }
}

extension String {

    func toJapanDate() -> [String] {
        guard self.count == 8 else { return ["", "", "", "", ""] }
        /// get 月
        let month = self[4...5]
        var monthStr = ""
        if let intMonth = Int(month) {
            monthStr = "\(intMonth)"
        }
        /// get 日
        let day = self[6...7]
        var dayStr = ""
        if let intDay = Int(day) {
            dayStr = "\(intDay)"
        }
        /// get 年
        var eraCode = ""
        var yearString = ""
        if let yearInt = Int(self[0...1]) {
            switch yearInt {
            case 19:
                eraCode = "6"
                yearString = self[2...3]
            case 20:
                eraCode = "7"
                yearString = self[2...3]
            default:
                let (year, era) = self.toJapanEra()
                yearString = year.description
                switch era {
                case "大正":
                    eraCode = "1"
                case "昭和":
                    eraCode = "2"
                case "平成":
                    eraCode = "3"
                case "明治":
                    eraCode = "4"
                default:
                    break
                }
            }
        }
        return ["", yearString, monthStr, dayStr, eraCode]
    }
}

extension String {

    func prefectureCodeSeparated() -> [String] {
        guard self.count == 7 else {
            return ["", ""]
        }
        let three = self[0...2]
        let four = self[3...6]
        return [three, four]
    }

    func formatPrefectureCode() -> String {
        let str =  self.prefectureCodeSeparated()
        return str[0] + "-" + str[1]
    }
}

extension String {

    /// CD暗証番号
    ///
    /// - Parameter isReissue: カード再発行
    /// - Returns: スクランブル
    func scrambleCdPin(_ isReissue: Bool) -> String {

        guard self.count == 4 else {
            return self
        }

        var numbers = [Int]()
        for character in self {
            let string = String(character)
            if let number = Int(string) {
                numbers.append(number)
            }
        }

        var a = ""
        var b = ""
        var c = ""
        var d = ""

        if isReissue {
            a = String((numbers[1] + 6) % 10)
            b = String((numbers[3] + 4) % 10)
            c = String((numbers[0] + 1) % 10)
            d = String((numbers[2] + 7) % 10)
        } else {
            a = String((numbers[3] + 3) % 10)
            b = String((numbers[0] + 5) % 10)
            c = String((numbers[1] + 7) % 10)
            d = String((numbers[2] + 2) % 10)
        }

        let cdPin = a + b + c + d

        return cdPin
    }

    /// IBログインパスワード
    ///
    /// - Returns: スクランブル
    func scrambleLoginPassword() -> String {

        guard self.count == 6 else {
            return self
        }

        var characters = [String]()
        for character in self {
            let string = String(character)
            characters.append(string)
        }

        let e = characters[3]
        let f = characters[5]
        let g = characters[1]
        let h = characters[2]
        let i = characters[0]
        let j = characters[4]

        let loginPassword = e + f + g + h + i + j

        return loginPassword
    }

    /// IB暗証番号
    ///
    /// - Returns: スクランブル
    func scrambleIbPin() -> String {

        guard self.count == 4 else {
            return self
        }

        var numbers = [Int]()
        for character in self {
            let string = String(character)
            if let number = Int(string) {
                numbers.append(number)
            }
        }

        let k = String((numbers[2] + 2) % 10)
        let l = String((numbers[0] + 9) % 10)
        let m = String((numbers[3] + 6) % 10)
        let n = String((numbers[1] + 3) % 10)

        let ibPin = k + l + m + n

        return ibPin
    }

}

/*-------matchStringDrawing--------------*/

extension String {
    
    func width(font: UIFont, height: CGFloat) -> CGFloat {
        return size(font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
    }
    
    func height(font: UIFont, width: CGFloat) -> CGFloat {
        return size(font, size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    func size(_ font: UIFont, size: CGSize) -> CGSize {
        return self.boundingRect(with: size,
                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                 attributes: [NSAttributedString.Key.font: font],
                                 context: nil).size
    }
}

extension String {

    func subString(from: Int) -> String {
        if from >= self.count {
            return ""
        }
        let rang = self.index(startIndex, offsetBy: from)..<self.endIndex
        return String(self[rang])
    }

    func subString(to: Int) -> String {
        if to >= self.count {
            return self
        }
        let rang = self.startIndex..<self.index(startIndex, offsetBy: to)
        return String(self[rang])
    }

    func subString(location: Int, length: Int) -> String {
        if location >= self.count {
            return ""
        }
        if location + length >= self.count {
            return self
        }
        let locationIndex = self.index(startIndex, offsetBy: location)
        let range = locationIndex..<self.index(locationIndex, offsetBy: length)
        return String(self[range])
    }

    subscript(begin: Int, end: Int) -> String {
        if begin >= self.count {
            return ""
        }
        if end >= self.count {
            return subString(from: begin)
        }
        let range = self.index(startIndex, offsetBy: begin)...self.index(startIndex, offsetBy: end)
        return String(self[range])
    }

    subscript(range: ClosedRange<Int>) -> String {
        if range.lowerBound >= self.count {
            return ""
        }
        if range.upperBound >= self.count {
            return subString(from: range.lowerBound)
        }
        let range = self.index(startIndex, offsetBy: range.lowerBound )...self.index(startIndex, offsetBy: range.upperBound)
        return String(self[range])
    }

    subscript(idx: Int) -> String {
        return subString(location: idx, length: 1)
    }
}

extension String {

    // 和暦
    func toJapanEra() -> (Int, String) {
        // 和暦を配列に入れる
        guard self.count > 3 else { return (0, "") }
        guard let year = Int(self[0...3]) else { return (0, "") }
        // デートフォーマットを yyyy/MM/dd の形式にセットする
        // (リアルタイムな日付じゃないので、JPフォーマットにする必要はなし)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        // 引数から来た、年月日を2001年１月１日 0:0 00 から何秒かに変換
        let convertDay = dateFormatter.date(from: self)!.timeIntervalSinceReferenceDate

        // 各年号（明治、大正、昭和、平成）の開始日の年月日を2001年１月１日 0:0 00 から何秒かに変換
        let maiji  = dateFormatter.date(from: "18681023")!.timeIntervalSinceReferenceDate  //明治
        let taisyo = dateFormatter.date(from: "19120730")!.timeIntervalSinceReferenceDate   //大正
        let syowa  = dateFormatter.date(from: "19261225")!.timeIntervalSinceReferenceDate  //昭和
        let heisei = dateFormatter.date(from: "19890108")!.timeIntervalSinceReferenceDate    //平成

        /*
         *  引数から来た、年月日が年号の間にあるか比較
         *
         *  return 元号と和暦
         */
        switch convertDay {
        case maiji..<taisyo:
            return (year - 1867, "明治")
        case taisyo..<syowa:
            return (year - 1911, "大正")
        case syowa..<heisei:
            return (year - 1925, "昭和")
        default:
            return (year - 1988, "平成")
        }
    }

}

extension String {
    //String 同一文字
    func isSameString() -> Bool {
        let newString = self as NSString
        var isSame = true
        if newString.length > 1 {
            let firstString = newString.substring(with: NSRange.init(location: 0, length: 1))
            for i in 0..<newString.length {
                if firstString != newString.substring(with: NSRange.init(location: i, length: 1)) {
                    isSame = false
                }
            }
        }
        return isSame
    }

    //生年月日、電話番号、同一文字、連続数字を入力
    func validatePassword(_ sitiveList: [String], checkSame: Bool) -> Bool {
        if checkSame {
            if self.isSameString() == true {
                return false
            }
        }
        for sensitive in sitiveList {
            if sensitive.contains(self) == true {
                return false
            }
        }
        return true
    }

    func getDate(_ formatterString: String, calendarIdentifier: Calendar.Identifier) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        formatter.calendar = Calendar.init(identifier: calendarIdentifier)
        return formatter.date(from: self)
    }

    func indexString(_ index: Int) -> String {
        if index > self.count - 1 {
            return ""
        }
        let string = self as NSString
        return string.substring(with: NSRange.init(location: index, length: 1))
    }

    func getNumberString() -> String {
        let numberString = "0123456789０１２３４５６７８９"
        return self.components(separatedBy: CharacterSet.init(charactersIn: numberString).inverted).joined(separator: "")
    }
}

func disallowedPasswordsFormAddress(address: String) -> [String] {
    let numberAddress = address.getNumberString().halfwidthcaseString
    if numberAddress.count >= 4 {
        return [numberAddress]
    } else {
        let number1 = "0000" + numberAddress
        let number2 = numberAddress + "0000"
        return [number1, number2]
    }
}

//許可されないパスワード
func disallowedPasswordsFormBirthDay(_ birthDayDate: Date) -> [String] {
    let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    let components = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: birthDayDate)
    let xDisallowedPasswords = getNormalCalendarDisallowedPasswords(components)
    let jDisallowedPasswords = getJapaneseCalendarDisallowedPasswords(components)
    debugPrint(xDisallowedPasswords + jDisallowedPasswords)
    return xDisallowedPasswords + jDisallowedPasswords
}

//許可されないパスワード  和暦
func getJapaneseCalendarDisallowedPasswords(_ components: DateComponents) -> [String] {
    let year = adFromEra(components.year!, month: components.month!, day: components.day!)
    let cDateYear  = String(format: "%02d", year.0)                  //AB   年号年
    let brithDateMonth = String(format: "%02d", components.month!)  //CD
    let brithDateDay   = String(format: "%02d", components.day!)    //EF
    let A = cDateYear.indexString(0)
    let B = cDateYear.indexString(1)
    let C = brithDateMonth.indexString(0)
    let D = brithDateMonth.indexString(1)
    let E = brithDateDay.indexString(0)
    let F = brithDateDay.indexString(1)
    let disPwd1 = A + B + C + D
    let disPwd2 = C + D + E + F
    let disPwd3 = A + B + E + F
    let disPwd4 = B + D + E + F
    let disPwd5 = A + B + D + F
    let disPwd6 = A + B + C + E
    let disPwd7 = B + C + D + F
    let disPwd8 = "0" + B + D + F
    return [disPwd1, disPwd2, disPwd3, disPwd4, disPwd5, disPwd6, disPwd7, disPwd8]
}

//許可されないパスワード  西暦
func getNormalCalendarDisallowedPasswords(_ components: DateComponents) -> [String] {
    let xbrithDateYear  = String(format: "%04d", components.year!)     //AB 西暦年
    let xbrithDateMonth  = String(format: "%02d", components.month!)   //CD 西暦年
    let xbrithDateDay  = String(format: "%02d", components.day!)       //EF 西暦年
    let A = xbrithDateYear.indexString(0)
    let B = xbrithDateYear.indexString(1)
    let A2 = xbrithDateYear.indexString(2)
    let B2 = xbrithDateYear.indexString(3)

    let C = xbrithDateMonth.indexString(0)
    let D = xbrithDateMonth.indexString(1)
    let E = xbrithDateDay.indexString(0)
    let F = xbrithDateDay.indexString(1)
    let disPwd1 = A + B + A2 + B2
    let disPwd2 = A2 + B2 + C + D
    let disPwd3 = C + D + E + F
    let disPwd4 = A2 + B2 + E + F
    let disPwd5 = B2 + D + E + F
    let disPwd6 = B2 + C + D + F
    let disPwd7 = A2 + B2 + D + F
    let disPwd8 = A2 + B2 + C + E
    let disPwd9 = "0" + B2 + D + F
    return [disPwd1, disPwd2, disPwd3, disPwd4, disPwd5, disPwd6, disPwd7, disPwd8, disPwd9]
}

func adFromEra(_ year: Int, month: Int, day: Int) -> (Int, String) {
    // 和暦を配列に入れる
    // 引数 year, month, day をデートフォーマット用にString(YYYY/MM/DD)にする
    let strConverDay: String = String(year) + "/" + String(month) + "/" + String(day)

    // デートフォーマットを yyyy/MM/dd の形式にセットする
    // (リアルタイムな日付じゃないので、JPフォーマットにする必要はなし)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"

    // 引数から来た、年月日を2001年１月１日 0:0 00 から何秒かに変換
    let convertDay = dateFormatter.date(from: strConverDay)!.timeIntervalSinceReferenceDate

    // 各年号（明治、大正、昭和、平成）の開始日の年月日を2001年１月１日 0:0 00 から何秒かに変換
    let maiji  = dateFormatter.date(from: "1868/10/23")!.timeIntervalSinceReferenceDate  //明治
    let taisyo = dateFormatter.date(from: "1912/7/30")!.timeIntervalSinceReferenceDate   //大正
    let syowa  = dateFormatter.date(from: "1926/12/25")!.timeIntervalSinceReferenceDate  //昭和
    let heisei = dateFormatter.date(from: "1989/1/8")!.timeIntervalSinceReferenceDate    //平成

    /*
     *  引数から来た、年月日が年号の間にあるか比較
     *
     *  return 元号と和暦
     */
    switch convertDay {
    case maiji..<taisyo:
        return  (year - 1867, "明治")
    case taisyo..<syowa:
        return (year - 1911, "大正")
    case syowa..<heisei:
        return (year - 1925, "昭和")
    default:
        return (year - 1988, "平成")
    }

}

func adFromEra(_ date: Date) -> (Int, String) {
    let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    let components = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
    return adFromEra(components.year!, month: components.month!, day: components.day!)
}

extension String {

    func halfToFull() -> String {
        let str = NSMutableString(string: self)
        let success = CFStringTransform(str, nil, "Halfwidth-Fullwidth" as CFString, false)
        if success {
            return str as String
        }
        return self
    }

    mutating func hiraToKata() -> String {
        let str = NSMutableString(string: self)
        let success = CFStringTransform(str, nil, "Hiragana-Katakana" as CFString, false)
        if success {
            return str as String
        }
        return self
    }

    func formatStringToYMD() -> String {

        guard self.count == 8 else {
            return self
        }

        let year = self[0...3]
        let month = self[4...5]
        let day = self[6...7]
        return year + "年" + month + "月" + day + "日"
    }

    func formatStringToHM() -> String {
        guard self.count == 4 else {
            return self
        }

        let hour = self[0...1]
        let minute = self[2...3]
        return hour + ":" + minute
    }

    func convertJapanDate() -> String {
        let year = Int(self)
        if year != nil {
            if year! >= 1952 && year! <= 1988 {
                return "昭和" + String(year! - 1925) + "年"
            } else if year! > 1989 {
                return "平成" + String(year! - 1988) + "年"
            } else if year == 1989 {
                return "平成元年"
            }
        }
        return ""
    }

    // 19830627 平成3年6月27日
    func convertDateToJapan() -> String {
        if self.count == 8 {
            let year = self[0...3]
            var month = self[4...5]
            var day = self[6...7]
            let yearJapan = year.convertJapanDate()
            if month.count == 2 && month.hasPrefix("0") {
                month = month.subString(from: 1)
            }
            if day.count == 2 && day.hasPrefix("0") {
                day = day.subString(from: 1)
            }
            return yearJapan + " " + month + " 月 " + day + " 日"
        } else if self.count == 6 {
            let year = self[0...3]
            var month = self[4...5]
            let yearJapan = year.convertJapanDate()
            if month.count == 2 && month.hasPrefix("0") {
                month = month.subString(from: 1)
            }
            return yearJapan + " " + month + " 月"
        } else {
            return ""
        }
    }

    //01 ->1
    func monthOmitZero() -> String {
        if self.count == 2 && self.hasPrefix("0") {
            return self.subString(from: 1)
        }
        return self
    }
    //1->01
    func monthAddZero() -> String {
        if self.count == 1 {
            return "0" + self
        }
        return self
    }

    //01 -> 1,001->1
    func formatNumber() -> String {
        if Int(self) == nil {
            return self
        }

        if self == "0"{
            return self
        }

        var tempStr = self
        while tempStr.hasPrefix("0") {
            tempStr = tempStr.subString(from: 1)
        }
        return tempStr
    }

    //123,45 ->12345
    func removeComma() -> String {
        return self.replacingOccurrences(of: ",", with: "")
    }
}

extension String {
    func kanjiAddressFormat() -> String {
        return self.replacingOccurrences(of: "-", with: "－")
    }
    /*!
     @var halfwidthcaseString
     @abstract 全角文字列を半角文字列に変換した文字列
     */
    public var halfwidthcaseString: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, false)
        return text as String
    }

    /*!
     @var fullwidthcaseString
     @abstract 半角文字列を全角文字列に変換した文字列
     */
    public var fullwidthcaseString: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, true)
        return (text as String).kanjiAddressFormat()
    }

    /*!
     @var hiraganacaseString
     @abstract カタカナをひらがなに変換した文字列
     */
    public var hiraganacaseString: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformHiraganaKatakana, true)
        return text as String
    }

    /*!
     @var katakanacaseString
     @abstract ひらがなをカタカナに変換した文字列
     */
    public var katakanacaseString: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformHiraganaKatakana, false)
        return text as String
    }
}

extension String {

    private func convertFullWidthToHalfWidth(reverse: Bool) -> String {
        let str = NSMutableString(string: self) as CFMutableString
        CFStringTransform(str, nil, kCFStringTransformFullwidthHalfwidth, reverse)
        return str as String
    }

    var hankakuString: String {
        return convertFullWidthToHalfWidth(reverse: false)
    }

    var zenkakuString: String {
        return convertFullWidthToHalfWidth(reverse: true)
    }

}

/*-------color--------------*/
extension String {
    func addWord(_ word: String?, color: UIColor?, font: UIFont?, singleLine: Bool) -> NSMutableAttributedString {

        let attributedString = NSMutableAttributedString.init(string: self)
        if word == nil {
            return attributedString
        }
        let tmpString = NSString.init(string: self)
        let range = tmpString.range(of: word!)
        if font != nil {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        }
        if color != nil {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color!, range: range)
        }
        if singleLine {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single, range: range)
        }
        return attributedString
    }

    func addWord(_ word: String?, color: UIColor?, font: UIFont?, singleLine: Bool, url: URL?) -> NSMutableAttributedString {

        let attributedString = NSMutableAttributedString.init(string: self)
        if word == nil {
            return attributedString
        }
        let tmpString = NSString.init(string: self)
        let range = tmpString.range(of: word!)
        if font != nil {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        }
        if color != nil {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color!, range: range)
        }
        if url != nil {
            attributedString.addAttributes([NSAttributedString.Key.link: url!, NSAttributedString.Key.underlineStyle: 1, NSAttributedString.Key.foregroundColor: color ?? UIColor.blue], range: range)
        }
        if singleLine {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single, range: range)
        }
        return attributedString
    }

    func addWord(_ words: [String]?, color: UIColor?, font: UIFont?) -> NSMutableAttributedString {

        let attributedString = NSMutableAttributedString.init(string: self)
        if words == nil {
            return attributedString
        }
        let tmpString = NSString.init(string: self)
        for word in words! {
            let range = tmpString.range(of: word)
            if font != nil {
                attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
            }
            if color != nil {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color!, range: range)
            }
            //attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle, range: range)
        }
        return attributedString
    }

}

extension String {
    func projectName() -> String {
        let pName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
        if var name = pName {
            name = name.replacingOccurrences(of: "-", with: "_")
            name = name.replacingOccurrences(of: "+", with: "_")
            return name
        }
        return ""
    }
    
    func className() -> String {
        return projectName() + "." + self
    }
    
}
