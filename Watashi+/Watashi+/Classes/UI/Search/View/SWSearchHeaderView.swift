
//
//  SWSearchHeaderView.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/2.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SWSearchHeaderView: BaseView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var allDeleteButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var lineView: UIView!

    let disposeBag = DisposeBag()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        trashButton.rx.tap
            .map({ _ in !self.trashButton.isSelected})
            .bind(to: self.trashButton.rx.isHidden)
        .disposed(by: disposeBag)
        trashButton.rx.tap
            .map({ _ in self.trashButton.isSelected})
            .bind(to: allDeleteButton.rx.isHidden)
        .disposed(by: disposeBag)
        trashButton.rx.tap
            .map({ _ in self.trashButton.isSelected})
            .bind(to: finishButton.rx.isHidden)
        .disposed(by: disposeBag)
        trashButton.rx.tap
            .map({ _ in self.trashButton.isSelected})
            .bind(to: lineView.rx.isHidden)
        .disposed(by: disposeBag)

        finishButton.rx.tap
            .map({_ in self.finishButton.isSelected})
            .bind(to: trashButton.rx.isHidden)
            .disposed(by: disposeBag)
        finishButton.rx.tap
            .map({_ in !self.finishButton.isSelected})
            .bind(to: allDeleteButton.rx.isHidden)
            .disposed(by: disposeBag)
        finishButton.rx.tap
            .map({_ in !self.finishButton.isSelected})
            .bind(to: lineView.rx.isHidden)
            .disposed(by: disposeBag)
        finishButton.rx.tap
            .map({_ in !self.finishButton.isSelected})
            .bind(to: self.finishButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    @IBAction func allDeleteButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name(NotifyName.searchListChange), object: nil)
    }
}
