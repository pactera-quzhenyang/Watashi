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
class SWShoppingABTestViewModelA: NSObject, SWShoppingABTestProtocol, SWGAProtocol {
    
    let disposeBag = DisposeBag()
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String,SWCheckNewProductsModel>>?
    
    
    // MARK: SWShoppingABTestProtocol
    func shoppingButton(forProduct product: SWCheckNewProductsModel, superView: UIView) {
        let button = UIButton()
        
        Observable.just(UIImage(named: "cartNormal")).bind(to: button.rx.image()).disposed(by: disposeBag)
        superView.addSubview(button)
//        var label: UILabel?
//        
//        for view in superView.subviews {
//            if view.isKind(of: UILabel.classForCoder()) {
//                label = view as? UILabel
//                break
//            }
//        }
        
        button.snp.makeConstraints { (make) in
            make.right.equalTo(superView.snp.right).offset(5)
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        button.rx.tap.subscribe(onNext: {
            print("aaaaa")
        }).disposed(by: disposeBag)
    }
    
    
    func bindCheckNewProducts(_ collectionView: UICollectionView, imageArray: [String]) {
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
                let goods = SWGoodsViewController()
                SWAppDelegate.nagvigationController()?.pushViewController(goods, animated: true)
            }).disposed(by: cell.disposeBag)
            return cell
            }
        )
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SWShoppingABTestViewModelA: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 170)
    }
}

// MARK: UITableViewDelegate
extension SWShoppingABTestViewModelA: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SWCheckNewProductsHeaderView.loadFromNib()
        headerView.setTitle(title: (dataSource?[section].model)!)
        return headerView
    }

        //返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)
        -> CGFloat {
        return 50
    }
}
