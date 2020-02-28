//
//  SearchHistoryTableViewCell.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/2/27.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import SnapKit

class SWSearchHistoryTableViewCell: SWBaseTableViewCell {

    lazy var searchHistoryView: SWSearchHistoryView = {
        let searchHistoryView = SWSearchHistoryView()
        return searchHistoryView
    }()

    func setModel(model: SWSearchHistoryModel) {
        let tagList = model.tagList

        contentView.addSubview(searchHistoryView)

        searchHistoryView.setupUI(list: tagList!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
