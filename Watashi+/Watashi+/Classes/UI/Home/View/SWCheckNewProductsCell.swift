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
import RxDataSources
class SWCheckNewProductsCell: UITableViewCell, Reusable {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrowleft")
        return arrowImageView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Product.lookDetail
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .mainDarkGray
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(15)
            make.left.equalTo(contentView.snp.right)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(arrowImageView.snp.right)
        }
    }
    
    func setModel(model: SWCheckNewProductsModel) {
        collectionView.delegate = nil
        collectionView.dataSource = nil

        let type = SWABTestingManager.shoppingCartsTypes() as? SWShoppingABTestProtocol
        type?.bindCheckNewProducts(collectionView, imageArray: model.imageArray ?? [], cell: self)
    }

 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol SWShoppingABTestProtocol: NSObjectProtocol {
    init()
    func bindCheckNewProducts(_ collectionView: UICollectionView, imageArray: [String], cell: SWCheckNewProductsCell)
}


