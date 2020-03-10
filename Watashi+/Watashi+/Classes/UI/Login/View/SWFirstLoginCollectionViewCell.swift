//
//  SWFirstLoginCollectionViewCell.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/9.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SWFirstLoginCollectionViewCell: SWBaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .mainDarkGray
        titleLabel.backgroundColor = .clear
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = frame.width / 2
        contentView.layer.borderColor = UIColor.firstLoginBorder.cgColor
        contentView.layer.borderWidth = 1

        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
    }
}
