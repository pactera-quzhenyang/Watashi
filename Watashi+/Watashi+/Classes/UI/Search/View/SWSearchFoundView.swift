//
//  SWSearchFoundView.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/4.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import SnapKit

class SWSearchFoundView: SWSearchHistoryView {

    override func setupUI(list: [String]) {
        for i in 0..<list.count {
            let title = list[i]

            let itemButton = UIButton()
            itemButton.setTitle(title, for: .normal)
            itemButton.setTitleColor(UIColor.init(hex: 0x666666), for: .normal)
            itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            itemButton.contentHorizontalAlignment = .left
            itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            itemButton.tag = i + 99
            self.addSubview(itemButton)

            itemButton.snp.makeConstraints { (make) in
                make.width.equalTo(viewMaxWidth / 2)
                make.height.equalTo(viewHeight)
                make.left.equalTo(i % 2 == 0 ? viewSpace : viewMaxWidth / 2)
                make.top.equalTo(CGFloat(i / 2) * viewHeight + (CGFloat(i / 2) * viewSpace))
                if i == list.count - 1 {
                    make.bottom.equalTo(self.snp.bottom).offset(-10)
                }
            }
        }
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(viewBeginX)
            make.right.equalTo(-viewBeginX)
            make.top.equalTo(CGFloat(list.count / 2) * viewHeight + (CGFloat(list.count / 2) * viewSpace))
            make.height.equalTo(1)
        }
    }

    func setHideSearchFoundView() {
        let label = UILabel()
        label.text = SearchPage.hideSearchFound
        label.textColor = UIColor.init(hex: 0x666666)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        self.addSubview(label)

        label.snp.makeConstraints { (make) in
            make.left.equalTo(viewBeginX)
            make.right.equalTo(-viewBeginX)
            make.top.equalTo(0)
        }

        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(viewBeginX)
            make.right.equalTo(-viewBeginX)
            make.top.equalTo(label.snp.bottom).offset(1)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(1)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
