
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
    @IBOutlet weak var discoverButton: UIButton!

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

        allDeleteButton.rx.tap.subscribe(onNext: { () in            
            NotificationCenter.default.post(name: Notification.Name(NotificationName.searchListChange), object: nil, userInfo: [SearchListChangeType.removeAllObject: SearchListChangeType.removeAllObject])
            }).disposed(by: disposeBag)

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

        Observable.just(SWSearchHistoryManager.shared.isHideSearchHistory ? UIImage(named: "hide") : UIImage(named: "discover")).bind(to: discoverButton.rx.image()).disposed(by: disposeBag)

        discoverButton.rx.tap.subscribe(onNext: { () in
            SWSearchHistoryManager.shared.isHideSearchHistory = !SWSearchHistoryManager.shared.isHideSearchHistory
            NotificationCenter.default.post(name: Notification.Name(NotificationName.searchListChange), object: nil, userInfo: [SearchListChangeType.hideSearchDiscover: SWSearchHistoryManager.shared.isHideSearchHistory])
            }).disposed(by: disposeBag)
    }
}
