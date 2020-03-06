//
//  SWUIButtonExtension.swift
//  Watashi+
//
//  Created by NULL on 2020/3/6.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 左の写真、右のタイトル
    /// - Parameter spacing: カスタム間隔
    func iconInLeft(_ spacing: CGFloat = 0) {
        self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                            left: spacing,
                                            bottom: 0,
                                            right: -spacing)
        self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                            left: -spacing,
                                            bottom: 0,
                                            right: spacing)
    }
    
    /// 右に画像、左にタイトル
    /// - Parameter spacing: カスタム間隔
    func iconInRight(_ spacing: CGFloat = 0) {
        let imageW = self.imageView!.width
        let titleW = self.titleLabel!.width
        self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                            left: -(imageW + spacing / 2),
                                            bottom: 0,
                                            right: imageW + spacing / 2)
        self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                            left: titleW + spacing / 2,
                                            bottom: 0,
                                            right: -(titleW + spacing / 2))
    }
    
    /// 上の写真、下のタイトル
    /// - Parameter spacing: カスタム間隔
    func iconInTop(_ spacing: CGFloat = 0) {
        let imageW = self.imageView!.width
        let imageH = self.imageView!.height
        let titleW = self.titleLabel!.width
        let titleH = self.titleLabel!.height
        
        self.titleEdgeInsets = UIEdgeInsets(top: titleH / 2 + spacing / 2,
                                            left: -(imageW / 2),
                                            bottom: -(titleH / 2 + spacing / 2),
                                            right: imageW / 2)
        self.imageEdgeInsets = UIEdgeInsets(top: -(imageH / 2 + spacing / 2),
                                            left: titleW / 2,
                                            bottom: imageH / 2 + spacing / 2,
                                            right: -(titleW / 2))
    }
    
    /// 下の写真、上のタイトル
    /// - Parameter spacing: カスタム間隔
    func iconInBottom(_ spacing: CGFloat = 0) {
        let imageW = self.imageView!.width
        let imageH = self.imageView!.height
        let titleW = self.titleLabel!.width
        let titleH = self.titleLabel!.height
        
        self.titleEdgeInsets = UIEdgeInsets(top: -(titleH / 2 + spacing / 2),
                                            left: -(imageW / 2),
                                            bottom: titleH / 2 + spacing / 2,
                                            right: imageW / 2)
        self.imageEdgeInsets = UIEdgeInsets(top: imageH / 2 + spacing / 2,
                                            left: titleW / 2,
                                            bottom: -(imageH / 2 + spacing / 2),
                                            right: -(titleW / 2))
    }
}
