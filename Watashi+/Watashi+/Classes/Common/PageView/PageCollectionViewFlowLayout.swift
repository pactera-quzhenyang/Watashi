//
//  PageCollectionViewFlowLayout.swift
//
//  Created by qzy on 2020/2/13.
//  Copyright © 2020 qzy. All rights reserved.

import UIKit

/*
 通过设置offset的值，达到初始化的pageView默认显示某一页的效果，默认显示第一页
 */
open class PageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var offset: CGFloat?
    
    override open func prepare() {
        super.prepare()
        guard let offset = offset else { return }
        collectionView?.contentOffset = CGPoint(x: offset, y: 0)
    }
}
