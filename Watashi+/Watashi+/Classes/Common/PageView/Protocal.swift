//
//  Protocal.swift
//  zst
//
//  Created by 曲振阳 on 2020/2/14.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

@objc public protocol PageTitleViewDelegate: class {
    func titleView(_ titleView: PageTitleView, didSelectAt index: Int)
}

@objc public protocol PageEventHandleable: class {

    /// 重复点击pageTitleView后调用
    @objc optional func titleViewDidSelectSameTitle()

    /// pageContentView的上一页消失的时候，上一页对应的controller调用
    @objc optional func contentViewDidDisappear()

    /// pageContentView滚动停止的时候，当前页对应的controller调用
    @objc optional func contentViewDidEndScroll()

}

@objc public protocol PageContentViewDelegate: class {
    func contentView(_ contentView: PageContentView, didEndScrollAt index: Int)
}
