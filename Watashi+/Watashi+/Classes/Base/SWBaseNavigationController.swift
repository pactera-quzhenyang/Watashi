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
}

class SWBaseNavigationController: UINavigationController {

    var style: BarStyle!

    lazy var searchFiled: SWSearchView = {
        let searchFiled = SWSearchView.loadFromNib()
        return searchFiled
    }()

    var barStyle: BarStyle {
        get {
            return style
        }
        set {
            switch newValue {
            case .searchHome:
                navigationBar.addSubview(searchFiled)
            case .searchView:
                hideNaviLine()
                searchFiled.setSearchFieldStyle(style: .navigationView)
                navigationBar.addSubview(searchFiled)
            }
            style = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func hideNaviLine() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
