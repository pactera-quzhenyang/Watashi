//
//  CULoopCollectionViewCell.swift
//  Watashi+
//
//  Created by NULL on 2020/3/5.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class CULoopCollectionViewCell: SWBaseCollectionViewCell {
    var imageView = UIImageView()
    var scrollView = UIScrollView()
    var parllexSpeed: CGFloat = 0.5
    var indexRow = 0 {
        didSet {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scrollView)
        scrollView.isUserInteractionEnabled = false
        scrollView.isScrollEnabled = false
        scrollView.addSubview(imageView)      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = self.bounds.size
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.size.equalTo(self.bounds.size)
        }
    }
    
    
    func moveBackgroundImag(at index: CGFloat) {
        let minusX = index - self.frame.origin.x
        let imageOffsetX = -minusX * parllexSpeed
        scrollView.contentOffset = CGPoint(x: imageOffsetX, y: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
