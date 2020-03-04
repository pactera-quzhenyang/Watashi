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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
