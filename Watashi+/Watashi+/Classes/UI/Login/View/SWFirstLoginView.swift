
//
//  SWFirstLoginView.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/9.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWFirstLoginView: UIView {

    private (set) public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.delegate = self
        if #available(iOS 10, *) {
            collectionView.isPrefetchingEnabled = false
        }
        collectionView.collectionViewLayout = layout
        collectionView.register(cellType: SWFirstLoginCollectionViewCell.self)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getItemRadius(max: UInt32, min: UInt32) -> UInt32 {
        return arc4random_uniform(max - min) + min
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension SWFirstLoginView: UICollectionViewDelegateFlowLayout {
    func gridFlowLayout(layout: SWGridFlowLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(getItemRadius(max: 50, min: 130)), height: CGFloat(getItemRadius(max: 50, min: 130)))
    }
}
