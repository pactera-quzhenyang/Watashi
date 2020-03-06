//
//  SWAppDelegateExtension.swift
//  Watashi+
//
//  Created by NULL on 2020/3/6.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

extension SWAppDelegate {
    
    /// ナビゲーションコントローラー
    class func nagvigationController() -> UINavigationController? {
        if (UIApplication.shared.keyWindow?.rootViewController?.isKind(of: UINavigationController.self) ?? false)  {
            return (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController)
        } else if (UIApplication.shared.keyWindow?.rootViewController?.isKind(of: UITabBarController.self) ?? false) {
            let tabBar = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
            let selectVC = tabBar.selectedViewController
            if selectVC?.isKind(of: UINavigationController.self) ?? false {
                return (selectVC as! UINavigationController)
            }
        }
        return nil
    }
}
