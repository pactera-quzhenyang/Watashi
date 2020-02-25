//
//  FirstHeaderView.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/20.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import Reusable

class SWCheckNewProductsHeaderView: UIView, NibLoadable {

    @IBOutlet weak var titleLabel: UILabel!
    func setTitle(title: String) {
        titleLabel.text = title
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
