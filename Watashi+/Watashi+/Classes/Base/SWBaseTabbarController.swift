//
//  SWBaseTabbarController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/21.
//  Copyright © 2020 曲振阳. All rights reserved.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SWBaseTabbarController: UITabBarController {

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .mainColor
        return lineView
    }()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = NotificationCenter.default.rx
        .notification(NSNotification.Name("badge"))
        .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe({ notify in
                for (index, item) in self.tabBar.items!.enumerated() {
                    if index == 2 {
                        item.badgeValue = SWTabbarBadgeValueManager.shared.badgeValue
                    }
                }
            })

        for (index, item) in tabBar.items!.enumerated() {
            if index == 2 || index == 3 {
                item.badgeValue = SWTabbarBadgeValueManager.shared.badgeValue
                item.badgeColor = .mainColor
            }
        }
        tabBar.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(screenWidth / 5)
            make.height.equalTo(1)
        }

        self.rx.didSelect.subscribe(onNext: { (selectController) in
            for (index, item) in self.viewControllers!.enumerated() {
                if selectController == item {
                    UIView.animate(withDuration: 0.3) {
                        self.lineView.snp.updateConstraints { (make) in
                            make.left.equalTo(Int(screenWidth / 5) * index)
                        }
                        self.tabBar.layoutIfNeeded()
                    }
                }
            }
            }).disposed(by: disposeBag)
    }
}
