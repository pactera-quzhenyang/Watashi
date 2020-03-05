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

            let lineView = UIView()
            lineView.backgroundColor = UIColor.init(hex: 0xeeeeee)
            self.addSubview(lineView)

            itemButton.snp.makeConstraints { (make) in
                make.width.equalTo(viewMaxWidth / 2)
                make.height.equalTo(viewHeight)
                make.left.equalTo(i % 2 == 0 ? viewSpace : viewMaxWidth / 2)
                make.top.equalTo(CGFloat(i / 2) * viewHeight + (CGFloat(i / 2) * viewSpace))
//                if i == list.count - 1 {
//                    make.bottom.equalTo(self.snp.bottom).offset(0)
//                }
            }

            lineView.snp.makeConstraints { (make) in
                make.left.equalTo(viewBeginX)
                make.top.equalTo(self.snp.bottom).offset(-19)
                make.bottom.equalTo(self.snp.bottom).offset(-20)
                make.height.equalTo(1)
                make.width.equalTo(viewMaxWidth)
            }
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
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
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
