//
//  SWSearchContentVIew.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/3/12.
//  Copyright © 2020 Watashi+. All rights reserved.
//

import UIKit

class SWSearchContentView: UIView {

    let buttonHeight: CGFloat = 36

    func setupUI(list: [String]) {
        for i in 0..<list.count {
            let title = list[i]

            let itemButton = UIButton()
            itemButton.setTitle(title, for: .normal)
            itemButton.setTitleColor(.white, for: .normal)
            itemButton.setImage(UIImage(named: "delete"), for: .normal)
            itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            itemButton.contentHorizontalAlignment = .left
            itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            itemButton.tag = i + 99
            self.addSubview(itemButton)

            let textWidth = title.size(UIFont.systemFont(ofSize: 14), size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: buttonHeight)).width

            itemButton.snp.makeConstraints { (make) in
                make.width.equalTo(textWidth)
                make.height.equalTo(buttonHeight)
                make.left.equalTo(0)
                make.top.equalTo(0)
            }
        }
    }
}
