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
        listLayout.itemSize = CGSize(width: screenWidth, height: 140)
        return listLayout
    }()
    
    /// 网格布局
    lazy var gridLayout: UICollectionViewFlowLayout = {
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.minimumLineSpacing = 10
        gridLayout.minimumInteritemSpacing = 10
        gridLayout.itemSize = CGSize(width: (screenWidth - 10) / 2, height: 240)
        return gridLayout
    }()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.listLayout)
        collectionView.backgroundColor = .lightGray
        collectionView.register(SWGoodsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    lazy var filterHeaderView: SWGoodsFilterHeaderView = {
        let filterHeaderView = Bundle.main.loadNibNamed("SWGoodsFilterHeaderView", owner: self, options: nil)?.last as! SWGoodsFilterHeaderView
        return filterHeaderView
    }()
    var style: SWGoodsCellStyle  = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseNavigationController?.barStyle = .productList

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
        
        let items = Observable.just([SectionModel(model: "", items: Array(repeating: "1", count: 50))])
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: {(dataSource, collectionView, indexPath, element) -> SWGoodsCollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SWGoodsCollectionViewCell
            
            cell.style = self.style
            return cell
            })
        
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        style = style.stype()
        let visibleItems = collectionView.indexPathsForVisibleItems
        for indexPath in visibleItems {
            let cell = collectionView.cellForItem(at: indexPath) as! SWGoodsCollectionViewCell
            cell.style = style
        }
        
        if style == .list {
            collectionView.setCollectionViewLayout(listLayout, animated: true)
        } else {
            collectionView.setCollectionViewLayout(gridLayout, animated: true)
        }
        
    }
}

extension SWGoodsViewController: UIScrollViewDelegate {
    
}




