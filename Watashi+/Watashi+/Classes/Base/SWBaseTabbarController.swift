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

enum TabbarItem: Int {
    case homeItem = 0 //ホーム
    case searchItem = 1 //さがす
    case shoppingCartItem = 2 //カート
    case repurchaseItem = 3 //再購入
    case accountItem = 4 //アカウント
}

class SWBaseTabbarController: UITabBarController {

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .mainColor
        return lineView
    }()

    let disposeBag = DisposeBag()

    let lineViewWidth = screenWidth / 5

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setBadgeValue()
        addLineView()
        bindView()
    }

    func setBadgeValue() {
        _ = NotificationCenter.default.rx
            .notification(NSNotification.Name(NotifyName.badgeValueChange))
        .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe({ notify in
                let item = notify.element?.object as? TabbarItem
                if item! == .shoppingCartItem {
                    self.tabBar.items![item!.rawValue].badgeValue = SWTabbarBadgeValueManager.shared.badgeValue
                }
            })

        for (_, item) in tabBar.items!.enumerated() {
            if item == tabBar.items![TabbarItem.shoppingCartItem.rawValue] || item == tabBar.items![TabbarItem.repurchaseItem.rawValue] {
                item.badgeValue = SWTabbarBadgeValueManager.shared.badgeValue
                item.badgeColor = .mainColor
            }
        }
    }

    func addLineView() {
        tabBar.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(lineViewWidth)
            make.height.equalTo(1)
        }
    }

    func bindView() {
        self.rx.didSelect.subscribe(onNext: { (selectController) in
            for (index, item) in self.viewControllers!.enumerated() {
                if selectController == item {
                    UIView.animate(withDuration: 0.3) {
                        self.lineView.snp.updateConstraints { (make) in
                            make.left.equalTo(Int(self.lineViewWidth) * index)
                        }
                        self.tabBar.layoutIfNeeded()
                    }
                }
            }
            }).disposed(by: disposeBag)
    }
}
