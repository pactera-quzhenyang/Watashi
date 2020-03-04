//
//  SWCheckNewProductsCollectionViewCellA.swift
//  Watashi+
//
//  Created by NULL on 2020/3/3.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
class SWCheckNewProductsCollectionViewCellA: SWBaseCollectionViewCell {
    
    /// 图片
    @IBOutlet weak var imageView: UIImageView!
    
    /// 价格
    @IBOutlet weak var priceLabel: UILabel!
    
    /// 添加购物车
    @IBOutlet weak var cartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
  
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}
