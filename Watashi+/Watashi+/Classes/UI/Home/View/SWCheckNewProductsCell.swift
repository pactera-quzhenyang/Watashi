//
//  FirstTableViewCell.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/20.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import RxDataSources
import RxSwift
class SWCheckNewProductsCell: UITableViewCell, Reusable, SWGAProtocol {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "SWCheckNewProductsCollectionViewCellA", bundle: nil), forCellWithReuseIdentifier: SWRemoteConfigValue.shoppingCartA.rawValue)
        collectionView.register(UINib(nibName: "SWCheckNewProductsCollectionViewCellB", bundle: nil), forCellWithReuseIdentifier: SWRemoteConfigValue.shoppingCartB.rawValue)
        return collectionView
    }()

    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrowleft")
        return arrowImageView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Product.lookDetail
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .mainDarkGray
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(15)
            make.left.equalTo(contentView.snp.right)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.left.equalTo(arrowImageView.snp.right)
        }
    }
    
    func setModel(model: SWCheckNewProductsModel) {
        collectionView.delegate = nil
        collectionView.dataSource = nil

//        let type = SWABTestingManager.shoppingCartsTypes() as? SWShoppingABTestProtocol
//        type?.bindCheckNewProducts(collectionView, imageArray: model.imageArray ?? [], cell: self)
        bindCheckNewProducts(model.imageArray ?? [])
    }

    func bindCheckNewProducts(_ images: [String]) {
        
        let items = Observable.just([
         SectionModel(model: "", items: images)
        ])
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, collectionView, indexPath, element) -> SWBaseCollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SWABTestingManager.string(forKey: shoppingCart), for: indexPath) as! SWBaseCollectionViewCell

             cell.delegate = self
             cell.id = element
             return cell
           }
        )
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    
        collectionView.rx.contentOffset.subscribe(onNext: { [weak self] (offset) in
            guard let strongSelf = self else { return }
            guard strongSelf.collectionView.contentSize.width > 0 else { return }
            let x = offset.x - (strongSelf.collectionView.contentSize.width - screenWidth + 30)
            if x >= 0 && x <= 100 {
                strongSelf.arrowImageView.snp.updateConstraints { (make) in
                    make.left.equalTo(strongSelf.contentView.snp.right).offset(-x+15)
                }
                strongSelf.titleLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(strongSelf.arrowImageView.snp.right)
                }
            }
            }).disposed(by: disposeBag)
        collectionView.rx.didEndDragging.subscribe(onNext: { (end) in
            if end {

            }
        }).disposed(by: disposeBag)
    }


 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SWCheckNewProductsCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: self.height)
    }
    
}

extension SWCheckNewProductsCell: SWSWBaseCollectionViewCellDelegate {
    
    func shoppingCartA() {
      
        logEvent(list: ["cartClick"])
        SWTabbarBadgeValueManager.shared.addBadgeValue()
        NotificationCenter.default.post(name: Notification.Name(NotifyName.badgeValueChange), object: TabbarItem.shoppingCartItem)
    }
    
    func shoppingCartB() {
       
       logEvent(list: ["cartClick"])
       
       let goods = SWGoodsViewController()
       SWAppDelegate.nagvigationController()?.pushViewController(goods, animated: true)

    }
}

protocol SWShoppingABTestProtocol: NSObjectProtocol {
    init()
    func bindCheckNewProducts(_ collectionView: UICollectionView, imageArray: [String], cell: SWCheckNewProductsCell)
}


