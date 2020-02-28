

//
//  SWSearchHistoryView.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWSearchHistoryView: UIView {

    var list: [String]!

    func setupUI(list: [String]) {
        self.list = list
        for i in 0..<list.count {
            let title = list[i]
            let tagButton = UIButton()
            tagButton.setTitle(title, for: .normal)
            tagButton.setTitleColor(UIColor.init(hex: 0x666666), for: .normal)
            tagButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            tagButton.backgroundColor = UIColor.init(hex: 0xf5f5f5)
            tagButton.layer.cornerRadius = 15
            tagButton.tag = i + 100
            self.addSubview(tagButton)

            let prevTagButton = viewWithTag(i+99) //上一个button
            let remainingWidth = prevTagButton != nil ? (screenWidth - prevTagButton!.frame.maxX) : screenWidth - 30 //剩余宽度
            let buttonWidth = tagButtonWidth(title: title) //button总宽度
            let isNewLine = remainingWidth - buttonWidth <= 0

            let x = isNewLine ? 15 : (prevTagButton != nil ? prevTagButton!.frame.maxX + 10 : 15)
            let y = isNewLine ? (prevTagButton != nil ? (prevTagButton!.frame.maxY) + 10 : 0) : (prevTagButton != nil ? (prevTagButton!.frame.minY) : 0)

            tagButton.frame = CGRect(x: x, y: y, width: buttonWidth, height: 30)
        }
        let lastButton = viewWithTag(list.count + 99)
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: lastButton!.frame.maxY)
    }

    func tagButtonWidth(title: String) -> CGFloat {
        let att: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        var textWidth = (title.boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 30), options: .usesLineFragmentOrigin, attributes:att, context: nil)).size.width + 2
        textWidth = textWidth >= screenWidth - 60 ? screenWidth - 60 : textWidth
        return textWidth + 30
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
