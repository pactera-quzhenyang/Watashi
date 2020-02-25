//
//  HomeSearchField.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/24.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class HomeSearchField: UITextField {

    public lazy var searchImageView: UIImageView = {
        let searchImageView = UIImageView()
        searchImageView.backgroundColor = self.backgroundColor
        searchImageView.image = UIImage(named: "search")
        return searchImageView
    }()

    let leftViewX: CGFloat = 10
    let leftViewWidth: CGFloat = 30

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: leftViewX, y: (self.frame.height - leftViewWidth) / 2, width: leftViewWidth, height: leftViewWidth)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: leftViewX + leftViewWidth + leftViewX, y: 0, width: self.frame.width, height: self.frame.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let x = leftViewX + leftViewWidth + leftViewX
        return CGRect(x: x, y: 0, width: self.frame.width - x, height: self.frame.height)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        leftView = searchImageView
        leftViewMode = .always
        attributedPlaceholder = attributePlaceHolder(.black)
    }
}
