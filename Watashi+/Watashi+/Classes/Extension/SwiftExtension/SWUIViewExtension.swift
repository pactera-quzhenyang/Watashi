//
//  SWUIViewExtension.swift
//  Watashi+
//
//  Created by NULL on 2020/3/6.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

//MARK: frame
extension UIView {
    
    var x: CGFloat {
       get {
           return frame.origin.x
       }

       set(newX) {
           var tmpFrame: CGRect = frame
           tmpFrame.origin.x = newX
           frame = tmpFrame
       }
    }

    var y: CGFloat {
       get {
           return frame.origin.y
       }

       set(newY) {
           var tmpFrame: CGRect = frame
           tmpFrame.origin.y = newY
           frame = tmpFrame
       }
    }


    var width: CGFloat {
       get {
           return frame.size.width
       }

       set(newWidth) {
           var tmpFrameWidth: CGRect = frame
           tmpFrameWidth.size.width = newWidth
           frame = tmpFrameWidth
       }
    }

    var height: CGFloat {
       get {
           return frame.size.height
       }

       set(newHeight) {
           var tmpFrameHeight: CGRect = frame
           tmpFrameHeight.size.height = newHeight
           frame = tmpFrameHeight
       }
    }

    var centerX: CGFloat {
       get {
           return center.x
       }
       set(newCenterX) {
           center = CGPoint(x: newCenterX, y: center.y)
       }
    }

    var centerY: CGFloat {
       get {
           return center.y
       }

       set(newCenterY) {
           center = CGPoint(x: center.x, y: newCenterY)
       }
    }

    var origin: CGPoint {
       get {
           return CGPoint(x: x, y: y)
       }

       set(newOrigin) {
           x = newOrigin.x
           y = newOrigin.y
       }
    }

    var size: CGSize {
       get {
           return CGSize(width: width, height: height)
       }

       set(newSize) {
           width = newSize.width
           height = newSize.height
       }
    }

    var left: CGFloat {
       get {
           return x
       }

       set(newLeft) {
           x = newLeft
       }
    }

    var right: CGFloat {
       get {
           return x + width
       }

       set(newNight) {
           x = newNight - width
       }
    }

    var top: CGFloat {
       get {
           return y
       }

       set(newTop) {
           y = newTop
       }
    }

    var bottom: CGFloat {
       get {
           return  y + height
       }

       set(newBottom) {
           y = newBottom - height
       }
    }
}
