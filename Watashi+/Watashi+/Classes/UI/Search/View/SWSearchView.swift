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

public enum searchFieldStyle: Int {
    case home = 0
    case navigationView = 1
}

class SWSearchView: UIView, NibLoadable {

    @IBOutlet weak var searchField: SWHomeSearchField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var filedHeightConstraint: NSLayoutConstraint!

    let disposBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setSearchFieldStyle(style: searchFieldStyle = .home) {
        switch style {
        case .navigationView:
            filedHeightConstraint.constant = 34
            searchField.placeholder = ""
            searchField.backgroundColor = .mainWhite
            searchField.layer.cornerRadius = 17
            searchField.becomeFirstResponder()
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
