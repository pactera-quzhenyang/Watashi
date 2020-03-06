//
//  SWGoodsViewController.swift
//  Watashi+
//
//  Created by NULL on 2020/3/6.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
class SWGoodsViewController: SWBaseViewController {
    
    /// 列表布局
    lazy var listLayout: UICollectionViewFlowLayout = {
        let listLayout = UICollectionViewFlowLayout()
        listLayout.minimumInteritemSpacing = 0
        listLayout.itemSize = CGSize(width: screenWidth, height: 80)
        return listLayout
    }()
    
    /// 网格布局
    lazy var gridLayout: UICollectionViewFlowLayout = {
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.minimumLineSpacing = 10
        gridLayout.minimumInteritemSpacing = 10
        listLayout.itemSize = CGSize(width: (screenWidth - 10) / 2, height: 80)
        return gridLayout
    }()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.gridLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var filterHeaderView: SWGoodsFilterHeaderView = {
        let filterHeaderView = Bundle.main.loadNibNamed("SWGoodsFilterHeaderView", owner: self, options: nil)?.last as! SWGoodsFilterHeaderView
        return filterHeaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Goods"
        self.navigationController?.navigationBar.isHidden = false
        bindView()
    }
    
    func bindView() {
        self.view.addSubview(filterHeaderView)
        filterHeaderView.snp.makeConstraints { (make) in
            make.top.equalTo(88)
            make.leading.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(filterHeaderView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
}
