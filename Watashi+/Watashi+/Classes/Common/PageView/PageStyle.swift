//
//  PageStyle.swift
//  DNSPageView
//
//  Created by qzy on 2020/2/13.
//  Copyright © 2020 qzy. All rights reserved.

import UIKit

public class PageStyle {
    
    /// titleView
    public var titleViewHeight: CGFloat = 44
    public var titleColor: UIColor = UIColor.black
    public var titleSelectedColor: UIColor = UIColor.blue
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    public var titleViewBackgroundColor: UIColor = UIColor.white
    public var titleMargin: CGFloat = 30
    public var titleViewSelectedColor: UIColor = UIColor.clear

    
    /// titleView滑动
    public var isTitleViewScrollEnabled: Bool = false
    
    /// title下划线
    public var isShowBottomLine: Bool = false
    public var bottomLineColor: UIColor = UIColor.blue
    public var bottomLineHeight: CGFloat = 2
    public var bottomLineWidth: CGFloat = 0
    public var bottomLineRadius: CGFloat = 1

    
    /// title缩放
    public var isTitleScaleEnabled: Bool = false
    public var titleMaximumScaleFactor: CGFloat = 1.2

    /// title遮罩
    public var isShowCoverView: Bool = false
    public var coverViewBackgroundColor: UIColor = UIColor.black
    public var coverViewAlpha: CGFloat = 0.4
    public var coverMargin: CGFloat = 8
    public var coverViewHeight: CGFloat = 25
    public var coverViewRadius: CGFloat = 12
    
    
    /// contentView
    public var isContentScrollEnabled : Bool = true
    public var contentViewBackgroundColor = UIColor.white
    
    
    public init() {
        
    }
}
