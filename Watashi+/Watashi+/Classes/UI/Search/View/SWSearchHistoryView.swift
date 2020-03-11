

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

    let viewHeight: CGFloat = 30 //tagView高度
    let viewMaxWidth: CGFloat = screenWidth - 30 //tagView最大宽度
    let viewBeginX: CGFloat = 15 //tagView起始x
    let viewSpace: CGFloat = 10 //tagView之间间距(上下左右)
    let labelTextSpace: CGFloat = 30 //文字左右空出来的大小总和

    let lineViewWidth: CGFloat = 1
    let lineViewHeight: CGFloat = 15

    var selectIndex: Int = -1 //删除的index
    var isShowAll = false //默认显示两行
    var stopAtIndex: Int = 0 //默认显示到index

    let disposeBag = DisposeBag()

    lazy var arrowButton: UIButton = {
        let arrowButton = UIButton()
        return arrowButton
    }()

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .mainLightGray
        return lineView
    }()

    func setupUI(list: [String]) {
        self.list = list

        var lines: Int = 0 //获取当前行数
        let defalutShowLines = 2 //默认显示两行
        var getPrevViewMaxX: CGFloat = 0
        var tapGestures: [UILongPressGestureRecognizer] = [UILongPressGestureRecognizer]()

        for i in 0..<list.count {
            let title = list[i]

            let prevTagButton = viewWithTag(i+99) //上一个button
            let buttonWidth = tagButtonWidth(title: title) //button总宽度
            getPrevViewMaxX += buttonWidth + labelTextSpace + viewSpace
            let remainingWidth = prevTagButton != nil ? (viewMaxWidth - getPrevViewMaxX) : viewMaxWidth //剩余宽度
            let isNewLine = remainingWidth <= 0 //是否换行
            if isNewLine && i > 0 {
                getPrevViewMaxX = buttonWidth + labelTextSpace + viewSpace
                lines += 1
                if lines == defalutShowLines && !SWSearchHistoryManager.shared.isShowAll {
                    stopAtIndex = i - 1
                    break
                }
            }

            let tagView = UIView()
            tagView.backgroundColor = .mainWhite
            tagView.layer.cornerRadius = 15
            tagView.tag = i + 100
            self.addSubview(tagView)

            let tagLabel = UILabel()
            tagLabel.text = title
            tagLabel.textColor = .mainDarkGray
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

            tagView.snp.makeConstraints { (make) in
                make.width.equalTo(buttonWidth + labelTextSpace)
                make.height.equalTo(viewHeight)
                if isNewLine {
                    make.left.equalTo(viewBeginX)
                    make.top.equalTo(prevTagButton != nil ? prevTagButton!.snp.bottom : 0).offset(prevTagButton != nil ? viewSpace : 0)
                } else {
                    if let prevTagView = prevTagButton {
                        make.left.equalTo(prevTagView.snp.right).offset(viewSpace)
                        make.top.equalTo(prevTagView.snp.top)
                    } else {
                        make.left.equalTo(viewBeginX)
                        make.top.equalTo(0)
                    }
                }
            }
            tagLabel.snp.makeConstraints { (make) in
                make.left.equalTo(labelTextSpace / 2)
                make.top.equalToSuperview()
                make.width.equalTo(buttonWidth)
                make.height.equalTo(viewHeight)
            }
            lineView.snp.makeConstraints { (make) in
                make.left.equalTo(tagLabel.snp.right).offset(5)
                make.top.equalTo((viewHeight - lineViewHeight) / 2)
                make.width.equalTo(lineViewWidth)
                make.height.equalTo(lineViewHeight)
            }
            deleteButton.snp.makeConstraints { (make) in
                make.left.equalTo(lineView.snp.right).offset(2)
                make.top.equalToSuperview()
                make.width.equalTo(labelTextSpace / 2)
                make.height.equalTo(viewHeight)
            }

            bindDeleteButton(deleteButton: deleteButton)
        }

        if let lastView = (viewWithTag(list.count + 99) != nil) ? viewWithTag(list.count + 99) : viewWithTag(stopAtIndex + 99){
            self.addSubview(arrowButton)
            self.addSubview(lineView)

            let newLine = viewMaxWidth - getPrevViewMaxX < 30
            if newLine && !SWSearchHistoryManager.shared.isShowAll && lines == defalutShowLines - 1 {
                stopAtIndex -= 1
            }

            arrowButton.snp.makeConstraints { (make) in
                if newLine {
                    make.left.equalTo(viewBeginX)
                    make.top.equalTo(lastView.snp.bottom).offset(viewSpace)
                } else {
                    make.left.equalTo(lastView.snp.right)
                    make.top.equalTo(lastView.snp.top)
                }
                make.width.equalTo(viewHeight)
                make.height.equalTo(viewHeight)
            }

            lineView.snp.makeConstraints { (make) in
                make.left.equalTo(viewBeginX)
                make.right.equalTo(-viewBeginX)
                make.top.equalTo(arrowButton.snp.bottom).offset(30)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }

        bindLongPress(tapGestures: tapGestures)
        bindArrowButton()
    }

    func bindLongPress(tapGestures: [UILongPressGestureRecognizer]) {
        let selectedView = Observable.from(
            tapGestures.map { gesture in gesture.rx.event.map { ele in ele } }
            ).merge()
        tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let tagLabel: UILabel = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 200) as! UILabel
            let subsciption = selectedView.filter({ $0.view?.tag == gesture.view?.tag})
                .map({$0.isEnabled})
                .bind(to: tagLabel.rx.isSelected)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
        tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let lineView = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 300)
            let subsciption = selectedView.filter({ $0.view?.tag == gesture.view?.tag})
                .map({!$0.isEnabled})
                .bind(to: (lineView?.rx.isHidden)!)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
        tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let deleteButton: UIButton = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 400) as! UIButton
            let subsciption = selectedView.filter({ $0.view?.tag == gesture.view?.tag})
                .map({!$0.isEnabled})
                .bind(to: (deleteButton.rx.isHidden))
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)

        tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let subsciption = selectedView.filter({ $0.view?.tag == gesture.view?.tag})
                .map({$0.view!.tag - 100})
                .bind(to: rx.selectIndex)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)

        tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let tagLabel: UILabel = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 200) as! UILabel
            let subsciption = selectedView.filter({ $0.view?.tag != gesture.view?.tag})
                .map({!$0.isEnabled})
                .bind(to: tagLabel.rx.isSelected)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
        tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let lineView = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 300)
            let subsciption = selectedView.filter({ $0.view?.tag != gesture.view?.tag})
                .map({$0.isEnabled})
                .bind(to: (lineView?.rx.isHidden)!)
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
        tapGestures.reduce(Disposables.create()) { disposable, gesture in
            let deleteButton: UIButton = gesture.view?.viewWithTag((gesture.view?.tag)! - 100 + 400) as! UIButton
            let subsciption = selectedView.filter({ $0.view?.tag != gesture.view?.tag})
                .map({$0.isEnabled})
                .bind(to: (deleteButton.rx.isHidden))
                return Disposables.create(disposable, subsciption)
            }.disposed(by: disposeBag)
    }

    func bindDeleteButton(deleteButton: UIButton) {
        deleteButton.rx.tap.subscribe(onNext: {[weak self] () in
            guard let weakSelf = self else { return }
            NotificationCenter.default.post(name: Notification.Name(NotificationName.searchListChange), object: nil, userInfo: [SearchListChangeType.removeObjectAtIndex: weakSelf.selectIndex])
        }).disposed(by: disposeBag)
    }

    func bindArrowButton() {
        Observable.just(SWSearchHistoryManager.shared.isShowAll ? UIImage(named: "up") : UIImage(named: "down")).bind(to: arrowButton.rx.image()).disposed(by: disposeBag)
        arrowButton.rx.tap.subscribe(onNext: { () in
            SWSearchHistoryManager.shared.isShowAll = !SWSearchHistoryManager.shared.isShowAll
            NotificationCenter.default.post(name: Notification.Name(NotificationName.searchListChange), object: nil, userInfo: [SearchListChangeType.reloadCellHeight: SWSearchHistoryManager.shared.isShowAll])
        }).disposed(by: disposeBag)
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
