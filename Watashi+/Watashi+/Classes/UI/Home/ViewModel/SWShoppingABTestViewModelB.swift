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
class SWShoppingABTestViewModelB: NSObject, SWShoppingABTestProtocol, SWGAProtocol {

    let disposeBag = DisposeBag()
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String,SWCheckNewProductsModel>>?
    
    // MARK: SWShoppingABTestProtocol
    func shoppingButton(forProduct product: SWCheckNewProductsModel, superView: UIView) {
        
        let button = UIButton()
        button.backgroundColor = UIColor(red: 31, green: 143, blue: 246)
        button.cornerRadius = 10
        Observable.just("立即购买").bind(to: button.rx.title()).disposed(by: disposeBag)
        superView.addSubview(button)
        var label: UILabel?
        for view in superView.subviews {
            if view.isKind(of: UILabel.classForCoder()) {
                label = view as? UILabel
                break
            }
        }
        
        button.snp.makeConstraints { (make) in
            make.left.equalTo(superView.snp.left).offset(10)
            make.right.equalTo(superView.snp.right).offset(-10)
            make.bottom.equalToSuperview()
            make.top.equalTo(label!.snp.bottom)
        }
        button.rx.tap.map{ button.isSelected ? "立即购买" : "已购买" }.bind(to: button.rx.title()).disposed(by: disposeBag)
        button.rx.tap.map{ !button.isSelected }.bind(to: button.rx.isSelected).disposed(by: disposeBag)
        button.rx.tap.subscribe(onNext: {
            print("testb")
        }).disposed(by: disposeBag)

    }
    
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

// MARK: UITableViewDelegate
extension SWShoppingABTestViewModelB: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
