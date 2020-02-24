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

class FirstTableViewCell: UITableViewCell, Reusable {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setModel(model: SectionDataModel) {
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
            make.width.equalTo(140*arrayCount+10*(arrayCount-1)+30)
            make.height.equalToSuperview()
        }

        for i in 0..<arrayCount {
            let itemImage = UIImageView()
            itemImage.backgroundColor = .gray
            itemImage.tag = i
            itemImage.image = UIImage(named: model.imageArray![i])
            bgView.addSubview(itemImage)


            itemImage.snp.makeConstraints { (make) in
                if i > 0 {
                    let prevView = bgView.viewWithTag(i-1)
                    make.left.equalTo(prevView!.snp.left).offset(i-1==0 ? 165 : 150)
                } else {
                    make.left.equalTo(15)
                }
                make.width.equalTo(140)
                make.height.equalTo(140)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
