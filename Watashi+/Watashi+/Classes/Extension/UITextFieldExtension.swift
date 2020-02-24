//
//  UITextFieldExtension.swift
//  BTAB
//
//  Created by 曲振陽 on 2019/6/11.
//  Copyright © 2019年 曲振陽. All rights reserved.
//

import UIKit

extension UITextField {
    //デフォルトのテキストスタイルを設定
    open func attributePlaceHolder(_ color: UIColor) -> NSAttributedString {
        let att = NSMutableAttributedString(string: self.placeholder ?? "")
        att.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: self.placeholder?.count ?? 0))
        att.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: self.placeholder?.count ?? 0))
        return att
    }
}
