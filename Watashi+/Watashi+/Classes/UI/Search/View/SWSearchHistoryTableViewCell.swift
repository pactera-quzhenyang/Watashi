//
//  SearchHistoryTableViewCell.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SWSearchHistoryTableViewCell: SWBaseTableViewCell {

    var disposBag = DisposeBag()
    func setModel(model: SWSearchHistoryModel) {
        let tagList = model.tagList

        selectionStyle = .none
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        let searchHistoryView = SWSearchHistoryView()
        contentView.addSubview(searchHistoryView)

        searchHistoryView.setupUI(list: tagList!)
    }

    func setSearchFound(model: SWSearchHistoryModel) {
        let tagList = model.tagList

        selectionStyle = .none
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        let searchFoundView = SWSearchFoundView()
        contentView.addSubview(searchFoundView)

        searchFoundView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(screenWidth)
            make.bottom.equalTo(contentView)
        }
        if tagList?.count == 0 {
            searchFoundView.setHideSearchFoundView()
        } else {
            searchFoundView.setupUI(list: tagList!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposBag = DisposeBag()
    }
}
