//
//  SWCheckNewProductsCollectionViewCellB.swift
//  Watashi+
//
//  Created by NULL on 2020/3/3.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
class SWCheckNewProductsCollectionViewCellB: SWBaseCollectionViewCell {
    
    /// 图片
    @IBOutlet weak var imageView: UIImageView!
    
    /// 价格
    @IBOutlet weak var priceLabel: UILabel!
    
    /// 购买
    @IBOutlet weak var buyButton: UIButton!
    
    override var id: String {
        didSet {
            priceLabel.text = "¥\(Int(arc4random_uniform(10000) + 0))"
            imageView.image = UIImage(named: id)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buyButton.addTarget(self, action: #selector(buy), for: .touchUpInside)
    }

    @objc func buy() {
        delegate?.shoppingCartB?()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        disposeBag = DisposeBag()
//    }
    
   
}
