//
//  CULoopBannerView.swift
//  Watashi+
//
//  Created by NULL on 2020/3/5.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class CULoopBannerView: UIView {
    lazy var images = Array<String>()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(CULoopCollectionViewCell.self, forCellWithReuseIdentifier: "loopCell")
        return collectionView
    }()
    
    lazy var countButton: UIButton = {
        let countButton = UIButton(type: .custom)
        countButton.backgroundColor = .brown
        return countButton
    }()
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        self.addSubview(countButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        countButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalTo(15)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    func bindCollection() {
        let items = Observable.just([
                SectionModel(model: "", items: images)
            ])
            
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, collectionView, indexPath, element) -> CULoopCollectionViewCell in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loopCell", for: indexPath) as! CULoopCollectionViewCell

            cell.imageView.image = UIImage(named: element)!
            let itemIndex = indexPath.item % self.images.count
            cell.indexRow = itemIndex
            return cell
            }
        )
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        countButton.setTitle("1/\(images.count)", for: .normal)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CULoopBannerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: 300)
    }
}

extension CULoopBannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = collectionView.visibleCells
        for visibleCell in visibleCells {
            guard let cell = visibleCell as? CULoopCollectionViewCell else { return }
            handleEffect(cell)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(collectionView.contentOffset.x / collectionView.frame.width) + 1
        countButton.setTitle("\(page)/\(images.count)", for: .normal)
    }
    
    func handleEffect(_ cell: CULoopCollectionViewCell) {
        cell.moveBackgroundImag(at: collectionView.contentOffset.x)
    }
}
