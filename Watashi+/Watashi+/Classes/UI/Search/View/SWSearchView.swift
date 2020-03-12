//
//  SWSearchView.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/28.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

public enum SearchFieldStyle: Int {
    //home页
    case homeStyle = 0
    //搜索历史页面
    case searchHistoryStyle = 1
    //产品一览页面
    case productListStyle = 2
}

class SWSearchView: UIView, NibLoadable {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchField: SWHomeSearchField!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var backButtonWidthConstraint: NSLayoutConstraint!

    let disposBag = DisposeBag()

    let backButtonWidth: CGFloat = 44

    override func awakeFromNib() {
        super.awakeFromNib()

        backButtonWidthConstraint.constant = 0
        backButton.isHidden = true

        backButton.rx.tap.subscribe(onNext: {[weak self] () in
            guard let weakSelf = self else { return }
            weakSelf.removeFromSuperview()
            SWAppDelegate.nagvigationController()?.popViewController(animated: true)
        }).disposed(by: disposBag)

        rightButton.rx.tap.subscribe(onNext: {[weak self] () in
            guard let weakSelf = self else { return }
            weakSelf.removeFromSuperview()
            SWAppDelegate.nagvigationController()?.popViewController(animated: false)
            }).disposed(by: disposBag)
    }

    func setSearchFieldStyle(style: SearchFieldStyle = .homeStyle) {
        switch style {
        case .searchHistoryStyle:
            searchField.placeholder = ""
            searchField.becomeFirstResponder()
        case .productListStyle:
            backButton.isHidden = false
            backButtonWidthConstraint.constant = backButtonWidth
            searchField.placeholder = ""
        default:
            break
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
