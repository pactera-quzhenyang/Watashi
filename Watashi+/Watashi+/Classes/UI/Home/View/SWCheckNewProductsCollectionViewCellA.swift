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
    
    override var id: String {
        didSet {
            priceLabel.text = "¥\(Int(arc4random_uniform(10000) + 0))"
            imageView.image = UIImage(named: id)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       let _ = cartButton.rx.tap.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.shoppingCartA?()
            })
    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        disposeBag = DisposeBag()
//    }
    
}
