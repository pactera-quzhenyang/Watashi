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

    lazy var searchContentView: SWSearchContentView = {
        let searchContentView = SWSearchContentView()
        return searchContentView
    }()

    let disposBag = DisposeBag()

    let backButtonWidth: CGFloat = 44

    var searchFieldStyle: SearchFieldStyle?

    var getText: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        backButtonWidthConstraint.constant = 0
        backButton.isHidden = true

        searchField.delegate = self

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
        searchFieldStyle = style
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


    func setSearchContentView(title: String) {
        guard title.count > 0 else { return }
        self.addSubview(searchContentView)
        searchContentView.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.left.equalTo(searchField.snp.left).offset(40)
            make.right.equalTo(searchField.snp.right)
            make.height.equalTo(24)
        }
        searchContentView.setupUI(title: title)
        searchContentView.tap.rx.event.subscribe(onNext: { (gesture) in
            self.removeFromSuperview()
            SWAppDelegate.nagvigationController()?.popViewController(animated: false)
            NotificationCenter.default.post(name: Notification.Name(NotificationName.getSearchText), object: self.searchContentView.contentList.first!)
        }).disposed(by: disposBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension SWSearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchFieldStyle == .searchHistoryStyle {
            return true
        }
        return false
    }
}
