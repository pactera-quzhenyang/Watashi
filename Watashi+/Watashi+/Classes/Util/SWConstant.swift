//
//  ErrorMessageManager.swift
//  BTAB
//
//  Created by 曲振陽 on 2019/6/12.
//  Copyright © 2019年 曲振陽. All rights reserved.
//

import UIKit

//页面文言提取
struct NavigationTitle {
    static let firstLogin = "情報登録"
}

struct PageTitles {
    static let checkNewProducts = "新商品をチェック"
    static let trend = "トレンド"
    static let seasonRecommend = "季節のおすすめ"
}

struct SearchPage {
    static let searchHistory = "搜索历史"
    static let searchFound = "搜索发现"
    static let hideSearchFound = "已隐藏搜索发现"
}

/********************************************************************/
/********************************************************************/


/*
//////通知名
*/
struct NotificationName {
    //搜索
    static let searchListChange = "SWSearchListChangeNotificationKey"
    //tabbar角标
    static let badgeValueChange = "SWBadgeValueChangeNotificationKey"
    //商品一览搜索点击空白区域
    static let getSearchText = "SWGetSearchTextNotificationKey"
}
/*
//////搜索页面
*/
struct SearchListChangeType {
    //搜索历史删除某一项
    static let removeObjectAtIndex = "removeObjectAtIndex"
    //搜索历史清空
    static let removeAllObject = "removeAllObject"
    //搜索历史点击上下箭头
    static let reloadCellHeight = "reloadCellHeight"
    //搜索发现隐藏按钮
    static let hideSearchDiscover = "hideSearchDiscover"
    //商品一览搜索框
    static let productListBack = "productListBack"
}
/*
//////产品
*/
struct Product {
    //右滑查看更多
    static let lookDetail = "も\nっ\nと"
}
