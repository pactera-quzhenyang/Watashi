
//
//  BaseCollectionViewCell.swift
//  zst
//
//  Created by 曲振阳 on 2020/2/17.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

protocol CollectionViewCellProcotol {
   
}
@objc protocol SWSWBaseCollectionViewCellDelegate: NSObjectProtocol {
    @objc optional func shoppingCartA()
    @objc optional func shoppingCartB()
}
class SWBaseCollectionViewCell: UICollectionViewCell, Reusable, CollectionViewCellProcotol {
    var id: String = ""
    var delegate: SWSWBaseCollectionViewCellDelegate?
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    deinit {
        print("\(self.classForCoder) deinit")
    }
}
