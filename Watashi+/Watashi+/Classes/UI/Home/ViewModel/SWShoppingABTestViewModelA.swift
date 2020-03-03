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
class SWShoppingABTestViewModelA: NSObject, SWShoppingABTestProtocol, UITableViewDelegate {
    
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
    
    
    // MARK: UITableViewDelegate
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
