//
//  SWShoppingABTestViewModelB.swift
//  Watashi+
//
//  Created by NULL on 2020/3/3.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
final class SWShoppingABTestViewModelB: NSObject, SWShoppingABTestProtocol, SWGAProtocol {

    let disposeBag = DisposeBag()
   
    // MARK: SWShoppingABTestProtocol
    func bindCheckNewProducts(_ collectionView: UICollectionView, imageArray: [String], cell: SWCheckNewProductsCell) {
        collectionView.register(UINib(nibName: "SWCheckNewProductsCollectionViewCellB", bundle: nil), forCellWithReuseIdentifier: "cell")
        let items = Observable.just([
        SectionModel(model: "", items: imageArray)
        ])
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, collectionView, indexPath, element) -> SWCheckNewProductsCollectionViewCellB in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SWCheckNewProductsCollectionViewCellB
//            Observable.just(UIImage(named: element)).bind(to: cell.imageView.rx.image).disposed(by: self.disposeBag)
            cell.imageView.image = UIImage(named: element)
            cell.priceLabel.text = "¥\(Int(arc4random_uniform(10000) + 0))"
            cell.buyButton.rx.tap.asDriver().drive(onNext: {
                self.logEvent(list: ["buyClick"])
                let goods = SWGoodsViewController()
                SWAppDelegate.nagvigationController()?.pushViewController(goods, animated: true)
//                self.navigationController?.pushViewController(goods, animated: true)
            }).disposed(by: cell.disposeBag)
            cell.buyButton.rx.tap.map{ cell.buyButton.isSelected ? "立即购买" : "已购买" }.bind(to: cell.buyButton.rx.title()).disposed(by: cell.disposeBag)
            cell.buyButton.rx.tap.map{ !cell.buyButton.isSelected }.bind(to: cell.buyButton.rx.isSelected).disposed(by: cell.disposeBag)
            return cell
            }
        )
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SWShoppingABTestViewModelB: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
}
