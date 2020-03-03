

//
//  SWSearchHistoryView.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SWSearchHistoryView: UIView {

    var list: [String]! //title list
    var tapGestures: [UILongPressGestureRecognizer] = [UILongPressGestureRecognizer]()

    let viewHeight: CGFloat = 30 //tagView高度
    let maxWidth: CGFloat = screenWidth - 30 //tagView最大宽度
    let viewBeginX: CGFloat = 15 //tagView起始x
    let viewSpace: CGFloat = 10 //tagView之间间距(上下左右)
    let labelTextSpace: CGFloat = 30 //文字左右空出来的大小总和

    let lineViewWidth: CGFloat = 1
    let lineViewHeight: CGFloat = 15

    var selectIndex: Int = -1 //删除的index
    var lines: Int = 0 //默认显示两行

    let disposeBag = DisposeBag()

    func setupUI(list: [String]) {
        self.list = list
        for i in 0..<list.count {
            let title = list[i]

            let tagView = UIView()
            tagView.backgroundColor = UIColor.init(hex: 0xf5f5f5)
            tagView.layer.cornerRadius = 15
            tagView.tag = i + 100
            self.addSubview(tagView)

            let tagLabel = UILabel()
            tagLabel.text = title
            tagLabel.textColor = UIColor.init(hex: 0x666666)
            tagLabel.font = UIFont.systemFont(ofSize: 14)
            tagLabel.textAlignment = .center
            tagLabel.lineBreakMode = .byTruncatingMiddle
            tagLabel.tag = i + 200
            tagView.addSubview(tagLabel)

            let lineView = UIView()
            lineView.backgroundColor = .gray
            lineView.isHidden = true
            lineView.tag = i + 300
            tagView.addSubview(lineView)

            let deleteButton = UIButton()
            deleteButton.setImage(UIImage(named: "delete"), for: .normal)
            deleteButton.isHidden = true
            deleteButton.tag = i + 400
            tagView.addSubview(deleteButton)

            let tap = UITapGestureRecognizer()
            tagView.addGestureRecognizer(tap)

            let longPress = UILongPressGestureRecognizer()
            tagView.addGestureRecognizer(longPress)
            tapGestures.append(longPress)

            let prevTagButton = viewWithTag(i+99) //上一个button
            let remainingWidth = prevTagButton != nil ? (maxWidth - prevTagButton!.frame.maxX) : maxWidth //剩余宽度
            let buttonWidth = tagButtonWidth(title: title) //button总宽度
            let isNewLine = remainingWidth - buttonWidth <= 0 //是否换行
            if isNewLine {
                lines += 1
            }

            let x = isNewLine ? viewBeginX : (prevTagButton != nil ? prevTagButton!.frame.maxX + viewSpace : viewBeginX)
            let y = isNewLine ? (prevTagButton != nil ? (prevTagButton!.frame.maxY) + viewSpace : 0) : (prevTagButton != nil ? (prevTagButton!.frame.minY) : 0)

            tagView.frame = CGRect(x: x, y: y, width: buttonWidth + labelTextSpace, height: viewHeight)
            tagLabel.frame = CGRect(x: labelTextSpace / 2, y: 0, width: buttonWidth, height: viewHeight)
            lineView.frame = CGRect(x: tagLabel.frame.maxX - 5, y: (viewHeight - lineViewHeight) / 2, width: lineViewWidth, height: lineViewHeight)
            deleteButton.frame = CGRect(x: lineView.frame.maxX + 1, y: 0, width: labelTextSpace / 2, height: viewHeight)

            bindDeleteButton(deleteButton: deleteButton)
        }

        if let lastButton = viewWithTag(list.count + 99) {
            let arrowButton = UIButton()
            arrowButton.setImage(UIImage(named: "down"), for: .normal)
            arrowButton.setImage(UIImage(named: "up"), for: .selected)
            self.addSubview(arrowButton)

            arrowButton.frame = CGRect(x: lastButton.frame.maxX, y: lastButton.frame.minY, width: viewHeight, height: viewHeight)
            self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: lastButton.frame.maxY)
        }

        bindLongPress()
    }

    func bindLongPress() {
        let selectedView = Observable.from(
            self.tapGestures.map { gesture in gesture.rx.event.map { ele in ele } }
            ).merge()
        self.tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let tagLabel: UILabel = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 200) as! UILabel
            let subsciption = selectedView.filter({ $0.view?.tag == gesture.view?.tag})
                .map({$0.isEnabled})
                .bind(to: tagLabel.rx.isSelected)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
        self.tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let lineView = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 300)
            let subsciption = selectedView.filter({ $0.view?.tag == gesture.view?.tag})
                .map({!$0.isEnabled})
                .bind(to: (lineView?.rx.isHidden)!)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
        self.tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let deleteButton: UIButton = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 400) as! UIButton
            let subsciption = selectedView.filter({ $0.view?.tag == gesture.view?.tag})
                .map({!$0.isEnabled})
                .bind(to: (deleteButton.rx.isHidden))
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)

        self.tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let subsciption = selectedView.filter({ $0.view?.tag == gesture.view?.tag})
                .map({$0.view!.tag - 100})
                .bind(to: rx.selectIndex)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)

        self.tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let tagLabel: UILabel = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 200) as! UILabel
            let subsciption = selectedView.filter({ $0.view?.tag != gesture.view?.tag})
                .map({!$0.isEnabled})
                .bind(to: tagLabel.rx.isSelected)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
        self.tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let lineView = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 300)
            let subsciption = selectedView.filter({ $0.view?.tag != gesture.view?.tag})
                .map({$0.isEnabled})
                .bind(to: (lineView?.rx.isHidden)!)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
        self.tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let deleteButton: UIButton = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 400) as! UIButton
            let subsciption = selectedView.filter({ $0.view?.tag != gesture.view?.tag})
                .map({$0.isEnabled})
                .bind(to: (deleteButton.rx.isHidden))
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
    }

    func bindDeleteButton(deleteButton: UIButton) {
        deleteButton.rx.tap.subscribe(onNext: { () in
            NotificationCenter.default.post(name: Notification.Name(NotifyName.searchListChange), object: self.selectIndex)
        }).disposed(by: disposeBag)
    }

    func bindArrowButton(arrowButton: UIButton) {
        arrowButton.rx.tap
    }

    func tagButtonWidth(title: String) -> CGFloat {
        let att: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        var textWidth = (title.boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 30), options: .usesLineFragmentOrigin, attributes:att, context: nil)).size.width + 2
        textWidth = textWidth >= screenWidth - 60 ? screenWidth - 60 : textWidth
        return textWidth
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
