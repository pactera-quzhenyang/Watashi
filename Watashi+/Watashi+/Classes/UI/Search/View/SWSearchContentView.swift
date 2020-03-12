//
//  SWSearchContentVIew.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/3/12.
//  Copyright © 2020 Watashi+. All rights reserved.
//

import UIKit
import RxSwift

class SWSearchContentView: UIScrollView {

    var contentList = [String]()

    let radius:CGFloat = 12

    var isSetContentOffset = false

    let disposeBag = DisposeBag()

    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()

    func setupUI(title: String) {

        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        self.addGestureRecognizer(tap)

        let textWidth = title.size(UIFont.systemFont(ofSize: 14), size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width

        let itemButton = UIButton()
        itemButton.setTitle(title, for: .normal)
        itemButton.setTitleColor(.white, for: .normal)
        itemButton.setImage(UIImage(named: "delete"), for: .normal)
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        itemButton.contentHorizontalAlignment = .left
        itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        itemButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: textWidth + 15, bottom: 0, right: 0)
        itemButton.tag = 100 + contentList.count
        itemButton.backgroundColor = .gray
        itemButton.layer.cornerRadius = radius
        self.addSubview(itemButton)

        var originX: CGFloat = 0
        if let prevButton = viewWithTag(100 + contentList.count - 1) {
            originX = prevButton.frame.maxX + 5
        }

        itemButton.snp.makeConstraints { (make) in
            make.width.equalTo(textWidth + 35)
            make.left.equalTo(originX)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }

        bindButton(button: itemButton)

        if !contentList.contains(title) {
            contentList.append(title)
        }
    }


    func bindButton(button: UIButton) {
        button.rx.tap.subscribe(onNext: {[weak self]() in
            guard let weakSelf = self else { return }
            if weakSelf.contentList.count > 1 {

            } else {
                weakSelf.superview?.removeFromSuperview()
                SWAppDelegate.nagvigationController()?.popViewController(animated: false)
                NotificationCenter.default.post(name: Notification.Name(NotificationName.getSearchText), object: "")
            }
            }).disposed(by: disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if contentList.count > 1 {

        } else {
            let itemButton = viewWithTag(100 + contentList.count - 1)
            if itemButton?.frame.width ?? 0 > self.frame.width {
                if !isSetContentOffset {
                    self.contentSize = CGSize(width: self.contentSize.width + 50, height: self.contentSize.height)
                    self.setContentOffset(CGPoint(x: self.contentSize.width - self.frame.width, y: 0), animated: true)
                    isSetContentOffset = true
                }
            }
        }
    }
}
