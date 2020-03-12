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

    var style: BarStyle!

    var barStyle: BarStyle {
        get {
            return style
        }
        set {
            let searchFiled = SWSearchView.loadFromNib()
            switch newValue {
            case .searchHome:
                navigationBar.addSubview(searchFiled)
            case .searchView:
                hideNaviLine()
                searchFiled.setSearchFieldStyle(style: .searchHistoryStyle)
                navigationBar.addSubview(searchFiled)
            case .productList:
                searchFiled.setSearchFieldStyle(style: .productListStyle)
                navigationBar.addSubview(searchFiled)
            }
            style = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = nil
    }

    func hideNaviLine() {
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
    }
}
