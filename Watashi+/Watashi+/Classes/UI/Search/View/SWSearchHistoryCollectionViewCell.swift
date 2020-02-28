//
//  SWSearchHistoryCollectionViewCell.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SWSearchHistoryCollectionViewCell: SWBaseCollectionViewCell {

    var disposBag = DisposeBag()
    var selectIndex: Int = 0

    lazy var tagLabel: UILabel = {
        let tagLabel = UILabel()
        tagLabel.textColor = UIColor.init(hex: 0x666666)
        tagLabel.font = UIFont.systemFont(ofSize: 14)
        tagLabel.textAlignment = .center
        tagLabel.lineBreakMode = .byTruncatingMiddle
        return tagLabel
    }()

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray
        lineView.isHidden = true
        return lineView
    }()

    lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        deleteButton.isHidden = true
        return deleteButton
    }()

    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()

    lazy var longPress: UILongPressGestureRecognizer = {
        let tap = UILongPressGestureRecognizer()
        return tap
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    func initUI() {
        backgroundColor = UIColor.init(hex: 0xf5f5f5)
        layer.cornerRadius = 15
        addSubview(tagLabel)
        addSubview(lineView)
        addSubview(deleteButton)
        addGestureRecognizer(tap)
        addGestureRecognizer(longPress)
    }

    func bindLongPress() {
        tap.rx.event.subscribe(onNext: { (gesture) in
            print(gesture)
            }).disposed(by: disposBag)

        longPress.rx.event.asObservable()
            .map({$0.isEnabled})
            .bind(to: tagLabel.rx.isLongPress)
            .disposed(by: disposBag)
        longPress.rx.event.asObservable()
            .map({!$0.isEnabled})
            .bind(to: lineView.rx.isHidden)
            .disposed(by: disposBag)
        longPress.rx.event.asObservable()
            .map({!$0.isEnabled})
            .bind(to: deleteButton.rx.isHidden)
            .disposed(by: disposBag)
        longPress.rx.event.asObservable()
            .map({$0.view!.tag - 1000})
            .bind(to: self.rx.selectIndex)
            .disposed(by: disposBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        initUI()
        bindLongPress()

        tagLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(tagLabel.snp.right).offset(-3)
            make.centerY.equalTo(tagLabel.snp.centerY)
            make.width.equalTo(1)
            make.height.equalTo(15)
        }
        deleteButton.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right)
            make.height.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposBag = DisposeBag()
    }
}
