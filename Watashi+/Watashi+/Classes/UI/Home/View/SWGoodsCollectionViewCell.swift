//
//  SWGoodsCollectionViewCell.swift
//  Watashi+
//
//  Created by NULL on 2020/3/6.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift


public enum SWGoodsCellStyle {
    case list
    case grid
    
    mutating func stype() -> SWGoodsCellStyle {
        switch self {
        case .list:
            return .grid
        case .grid:
            return .list
        }
    }
}

class SWGoodsCollectionViewCell: SWBaseCollectionViewCell {

    lazy var goodsImageView = UIImageView()
    lazy var bottomView = UIView()
    lazy var goodsNameLabel = UILabel()
    lazy var goodsParams = ["GTX1650", "MX250", "i5-9300H"]
    lazy var priceLabel = UILabel()
    lazy var priceTypes = ["スパイク価格", "原価"]
    lazy var shopTypes = ["自営業者", "地元の倉庫"]
    lazy var commentLabel = UILabel()
    lazy var shopNameLabel = UILabel()
    lazy var intoShopButton = UIButton(type: .custom)
    
    var style: SWGoodsCellStyle = .grid {
        didSet {
            switch style {
            case .list:
                UIView.animate(withDuration: 0.25) {
                    self.listLayout()
                }
                
                break
            case .grid:
                UIView.animate(withDuration: 0.25) {
                    self.gridLayout()
                }
                break
            }
        }
    }
    
    let viewLeft: CGFloat = 10
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubviews() {
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(goodsImageView)
        self.contentView.addSubview(bottomView)
        bottomView.addSubview(goodsNameLabel)
        bottomView.addSubview(priceLabel)
        bottomView.addSubview(commentLabel)
        bottomView.addSubview(shopNameLabel)
        bottomView.addSubview(intoShopButton)
        goodsImageView.image = UIImage(named: "1")
        goodsNameLabel.font = UIFont.systemFont(ofSize: 13)
        priceLabel.font = UIFont.systemFont(ofSize: 13)
        commentLabel.font = UIFont.systemFont(ofSize: 13)
        shopNameLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    func listLayout() {
        
        goodsImageView.snp.remakeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
       
        bottomView.snp.remakeConstraints { (make) in
            make.left.equalTo(goodsImageView.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-viewLeft)
        }
       
        goodsNameLabel.text = "シーフード 電化製品 軽食 エレクトロニクス 工業製品 シーフード 電化製品 軽食 エレクトロニクス 工業製品 シーフード 電化製品 軽食 エレクトロニクス 工業製品 シーフード 電化製品 軽食 エレクトロニクス 工業製品"
        var nameH = goodsNameLabel.text!.height(font: goodsNameLabel.font, width: self.width - viewLeft - 45) + 1
        if nameH > 40 {
            nameH = 40
        }
        goodsNameLabel.snp.remakeConstraints { (make) in
           make.top.equalToSuperview()
           make.left.equalToSuperview()
           make.right.equalToSuperview()
           make.height.equalTo(nameH)
        }

        for i in 0 ..< goodsParams.count {
           let label = UILabel()
           label.textAlignment = .center
           label.font = UIFont.systemFont(ofSize: 13)
           label.text = goodsParams[i]
           label.cornerRadius = 5
           label.backgroundColor = .gray
           bottomView.addSubview(label)
           let width = label.text!.width(font: label.font, height: 15) + 1
           label.snp.remakeConstraints { (make) in
               make.top.equalTo(goodsNameLabel.snp.bottom).offset(5)
               make.width.equalTo(width)
               make.height.equalTo(15)
               make.left.equalTo((width + 5) * CGFloat(i))
           }
        }

        priceLabel.text = "¥\(Int(arc4random_uniform(10000) + 0))"
        let priceW = priceLabel.text!.width(font: priceLabel.font, height: 15) + 1
        priceLabel.snp.remakeConstraints { (make) in
           make.left.equalToSuperview()
           make.top.equalTo(goodsNameLabel.snp.bottom).offset(25)
           make.height.equalTo(15)
           make.width.equalTo(priceW)
        }

        for i in 0 ..< priceTypes.count {
           let label = UILabel()
           label.textAlignment = .center
           label.font = UIFont.systemFont(ofSize: 10)
           label.text = priceTypes[i]
           label.backgroundColor = .red
           bottomView.addSubview(label)
           let width = label.text!.width(font: label.font, height: 10) + 1
           label.snp.remakeConstraints { (make) in
               make.bottom.equalTo(priceLabel.snp.bottom)
               make.width.equalTo(width)
               make.height.equalTo(10)
               make.left.equalTo(priceLabel.snp.right).offset((width + 5) * CGFloat(i))
           }
        }

        for i in 0 ..< shopTypes.count {
           let label = UILabel()
           label.textAlignment = .center
           label.font = UIFont.systemFont(ofSize: 10)
           label.text = shopTypes[i]
           label.backgroundColor = .red
           bottomView.addSubview(label)
           let width = label.text!.width(font: label.font, height: 10) + 1
           label.snp.remakeConstraints { (make) in
               make.top.equalTo(priceLabel.snp.bottom).offset(5)
               make.width.equalTo(width)
               make.height.equalTo(10)
               make.left.equalTo((width + 5) * CGFloat(i))
           }
        }
        commentLabel.text = "20万 + レビュー 95%賞賛"
        commentLabel.snp.remakeConstraints { (make) in
           make.top.equalTo(priceLabel.snp.bottom).offset(20)
           make.left.equalToSuperview()
           make.right.equalToSuperview()
           make.height.equalTo(10)
        }
        shopNameLabel.text = "自己旗艦店"
        shopNameLabel.snp.remakeConstraints { (make) in
           make.top.equalTo(commentLabel.snp.bottom).offset(5)
           make.left.equalToSuperview()
           make.height.equalTo(10)
           make.right.equalToSuperview()
        }
        intoShopButton.setTitle("店に", for: .normal)
        intoShopButton.snp.remakeConstraints { (make) in
           make.centerX.equalTo(shopNameLabel.centerX)
           make.left.equalTo(shopNameLabel.snp.right).offset(5)
           make.width.equalTo(30)
           make.height.equalTo(15)
        }
        self.contentView.layoutIfNeeded()
    }
    
    func gridLayout()  {
        print(#function)
        
        goodsImageView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        bottomView.snp.remakeConstraints { (make) in
            make.top.equalTo(goodsImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        goodsNameLabel.text = "シーフード 電化製品 軽食 エレクトロニクス 工業製品 シーフード 電化製品 軽食 エレクトロニクス 工業製品 シーフード 電化製品 軽食 エレクトロニクス 工業製品 シーフード 電化製品 軽食 エレクトロニクス 工業製品"
        goodsNameLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(viewLeft)
            make.right.equalToSuperview().offset(-viewLeft)
            make.height.equalTo(21)
        }
        
        for i in 0 ..< goodsParams.count {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            label.text = goodsParams[i]
            label.cornerRadius = 5
            label.backgroundColor = .gray
            bottomView.addSubview(label)
            let width = label.text!.width(font: label.font, height: 15) + 1
            label.snp.remakeConstraints { (make) in
                make.top.equalTo(goodsNameLabel.snp.bottom).offset(5)
                make.width.equalTo(width)
                make.height.equalTo(15)
                make.left.equalTo(viewLeft + (width + 5) * CGFloat(i))
            }
        }
        
        priceLabel.text = "¥\(Int(arc4random_uniform(10000) + 0))"
        let priceW = priceLabel.text!.width(font: priceLabel.font, height: 15) + 1
        priceLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(viewLeft)
            make.top.equalTo(goodsNameLabel.snp.bottom).offset(25)
            make.height.equalTo(15)
            make.width.equalTo(priceW)
        }
        
        for i in 0 ..< priceTypes.count {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = priceTypes[i]
            label.backgroundColor = .red
            bottomView.addSubview(label)
            let width = label.text!.width(font: label.font, height: 10) + 1
            label.snp.remakeConstraints { (make) in
                make.bottom.equalTo(priceLabel.snp.bottom)
                make.width.equalTo(width)
                make.height.equalTo(10)
                make.left.equalTo(priceLabel.snp.right).offset((width + 5) * CGFloat(i))
            }
        }
        
        for i in 0 ..< shopTypes.count {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.text = shopTypes[i]
            label.backgroundColor = .red
            bottomView.addSubview(label)
            let width = label.text!.width(font: label.font, height: 10) + 1
            label.snp.remakeConstraints { (make) in
                make.top.equalTo(priceLabel.snp.bottom).offset(5)
                make.width.equalTo(width)
                make.height.equalTo(10)
                make.left.equalTo(viewLeft + (width + 5) * CGFloat(i))
            }
        }
        commentLabel.text = "20万 + レビュー 95%賞賛"
        commentLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.left.equalTo(viewLeft)
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        shopNameLabel.text = "自己旗艦店"
        shopNameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(commentLabel.snp.bottom).offset(5)
            make.left.equalTo(viewLeft)
            make.height.equalTo(10)
            make.right.equalToSuperview()
        }
        intoShopButton.setTitle("店に", for: .normal)
        intoShopButton.snp.remakeConstraints { (make) in
            make.centerX.equalTo(shopNameLabel.centerX)
            make.left.equalTo(shopNameLabel.snp.right).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(15)
        }
        self.contentView.layoutIfNeeded()
    }
}

extension SWGoodsCollectionViewCell {
//    public enum SWGoodsCellStyle {
//        case list
//        case grid
//    }
}
