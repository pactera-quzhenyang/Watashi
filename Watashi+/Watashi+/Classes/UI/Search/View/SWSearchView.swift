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

class SWSearchView: UIView, NibLoadable {

    @IBOutlet weak var searchField: SWHomeSearchField!
    @IBOutlet weak var cancelButton: UIButton!

    let disposBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
