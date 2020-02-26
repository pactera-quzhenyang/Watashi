//
//  SWBaseTabbarController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/21.
//  Copyright © 2020 曲振阳. All rights reserved.
//
import UIKit

class SWBaseTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for item in self.tabBar.items ?? Array<UITabBarItem>() {
            item.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11),NSAttributedString.Key.foregroundColor : UIColor.init(hex: 0x333333)], for: .normal)
        }
    }
}
