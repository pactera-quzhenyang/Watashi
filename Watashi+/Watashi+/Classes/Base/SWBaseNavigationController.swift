//
//  SWBaseNavigationController.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/11.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum BarStyle: Int {
    //home页搜索
    case searchHome = 0
    //搜索页搜索框
    case searchView = 1
    //商品一览
    case productList = 2
}

class SWBaseNavigationController: UINavigationController {

    var searchString: String!

    var style: BarStyle!

    var barStyle: BarStyle {
        get {
            return style
        }
        set {
            let searchView = SWSearchView.loadFromNib()
            switch newValue {
            case .searchHome:
                navigationBar.addSubview(searchView)
            case .searchView:
                for subView in self.navigationBar.subviews {
                    if subView is SWSearchView {
                        let view = subView as! SWSearchView
                        if view.searchFieldStyle == .searchHistoryStyle {
                            return
                        }
                    }
                }
                searchView.setSearchFieldStyle(style: .searchHistoryStyle)
                navigationBar.addSubview(searchView)
                navigationBar.shadowImage = UIImage()
            case .productList:
                searchView.setSearchFieldStyle(style: .productListStyle)
                searchView.setSearchContentView(title: searchString)
                navigationBar.addSubview(searchView)
            }
            style = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        addNotification()
    }

    func addNotification() {
        _ = NotificationCenter.default.rx
            .notification(NSNotification.Name(NotificationName.getSearchText))
        .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe({ notify in
                let text = notify.element?.object as? String
                for subView in self.navigationBar.subviews {
                    if subView is SWSearchView {
                        let view = subView as! SWSearchView
                        if view.searchFieldStyle == .searchHistoryStyle {
                            
                            view.searchField.text = text
                        }
                    }
                }
            })
    }

    func setNaviBackButton() {
        let backButton = UIButton.init()
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 40)
        backButton.setImage(UIImage(named: "back"), for: UIControl.State.normal)
        let backItem = UIBarButtonItem.init(customView: backButton)
        self.navigationItem.leftBarButtonItems = [backItem]
    }
}
