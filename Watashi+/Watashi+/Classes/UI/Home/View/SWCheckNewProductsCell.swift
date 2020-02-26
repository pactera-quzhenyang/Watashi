//
//  FirstTableViewCell.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/20.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class SWCheckNewProductsCell: UITableViewCell, Reusable {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setModel(model: SWCheckNewProductsModel) {
        let arrayCount = model.imageArray?.count ?? 0

        for subView in scrollView.subviews {
            subView.removeFromSuperview()
        }

        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
         }
        let bgView = UIView()
        scrollView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(140*arrayCount+10*(arrayCount-1))
            make.height.equalToSuperview()
        }

        for i in 0..<arrayCount {
            let itemImage = UIImageView()
            itemImage.backgroundColor = .gray
            itemImage.tag = i
            itemImage.image = UIImage(named: model.imageArray![i])
            bgView.addSubview(itemImage)

            let priceLabel = UILabel()
            priceLabel.text = "¥\(Int(arc4random_uniform(10000) + 0))"
            priceLabel.textColor = UIColor.init(hex: 0x666666)
            priceLabel.font = UIFont.systemFont(ofSize: 14)
            priceLabel.textAlignment = .center
            bgView.addSubview(priceLabel)

            itemImage.snp.makeConstraints { (make) in
                if i > 0 {
                    let prevView = bgView.viewWithTag(i-1)
                    make.left.equalTo(prevView!.snp.left).offset(150)
                } else {
                    make.left.equalTo(0)
                }
                make.width.equalTo(140)
                make.height.equalTo(140)
            }
            priceLabel.snp.makeConstraints { (make) in
                if i > 0 {
                    let prevView = bgView.viewWithTag(i-1)
                    make.left.equalTo(prevView!.snp.left).offset(150)
                } else {
                    make.left.equalTo(0)
                }
                make.top.equalTo(itemImage.snp.bottom)
                make.width.equalTo(itemImage.snp.width)
                make.height.equalTo(30)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
