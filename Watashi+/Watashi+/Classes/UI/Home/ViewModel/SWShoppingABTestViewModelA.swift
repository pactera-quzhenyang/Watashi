//
//  SWShoppingABTestViewModelA.swift
//  Watashi+
//
//  Created by NULL on 2020/3/3.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
final class SWShoppingABTestViewModelA: NSObject, SWShoppingABTestProtocol, SWGAProtocol {
    
    let disposeBag = DisposeBag()
   
    // MARK: SWShoppingABTestProtocol
    func bindCheckNewProducts(_ collectionView: UICollectionView, imageArray: [String], cell: SWCheckNewProductsCell) {
        collectionView.register(UINib(nibName: "SWCheckNewProductsCollectionViewCellA", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        let items = Observable.just([
        SectionModel(model: "", items: imageArray)
        ])
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: {(dataSource, collectionView, indexPath, element) -> SWCheckNewProductsCollectionViewCellA in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SWCheckNewProductsCollectionViewCellA

//            Observable.just(UIImage(named: element)).bind(to: cell.imageView.rx.image).disposed(by: cell.disposeBag)
            cell.imageView.image = UIImage(named: element)!
            cell.priceLabel.text = "¥\(Int(arc4random_uniform(10000) + 0))"
            cell.cartButton.rx.tap.subscribe(onNext: {
                self.logEvent(list: ["cartClick"])
                SWTabbarBadgeValueManager.shared.addBadgeValue()
                let goods = SWGoodsViewController()
                SWAppDelegate.nagvigationController()?.pushViewController(goods, animated: true)

                NotificationCenter.default.post(name: Notification.Name(NotifyName.badgeValueChange), object: nil)

            }).disposed(by: cell.disposeBag)
            return cell
            }
        )
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.rx.contentOffset.subscribe(onNext: { (offset) in
            guard collectionView.contentSize.width > 0 else { return }
            let x = offset.x - (collectionView.contentSize.width - screenWidth + 30)
            if x >= 0 && x <= 100 {
                cell.arrowImageView.snp.updateConstraints { (make) in
                    make.left.equalTo(cell.contentView.snp.right).offset(-x+15)
                }
                cell.titleLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(cell.arrowImageView.snp.right)
                }
            }
            }).disposed(by: disposeBag)
        collectionView.rx.didEndDragging.subscribe(onNext: { (end) in
            if end {

            }
            }).disposed(by: disposeBag)
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SWShoppingABTestViewModelA: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 170)
    }
}

