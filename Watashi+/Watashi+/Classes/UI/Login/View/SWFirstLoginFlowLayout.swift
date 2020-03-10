//
//  SWFirstLoginFlowLayout.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/3/9.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWFirstLoginFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let array = super.layoutAttributesForElements(in: rect) {
            let lines = 1 // 当前行数
            var lineFirstIndexList = [Int: Int]()
            lineFirstIndexList[lines] = 0
            for (index, _) in array.enumerated() {
                if index > 0 {
                    let prevLayoutAttributes = array[index - 1]
                    let currentLayoutAttributes = array[index]

                    let maximumSpacing: CGFloat = 0
                    let originX = prevLayoutAttributes.frame.maxX

                    //每一行的每一个紧挨着
                    if originX + maximumSpacing + currentLayoutAttributes.frame.width < screenWidth {
                        var frame = currentLayoutAttributes.frame;
                        frame.origin.x = originX + maximumSpacing;
                        currentLayoutAttributes.frame = frame;
                    }

//                    //每一排的第一个上下在一起
//                    let lineMinX = currentLayoutAttributes.frame.minX
//                    if lineMinX == 0 {
//                        let prevLineAttributes = array[lineFirstIndexList[lines]!]
//                        let currentLineAttributes = array[index]
//
//                        var frame = currentLineAttributes.frame;
//                        frame.origin.y = prevLineAttributes.frame.maxY - 5
//                        currentLineAttributes.frame = frame;
//
//                        let prevLineNextAttributes = array[lineFirstIndexList[lines]! + 1] //找到上一行的第二个，防止向上顶的时候把第二个盖上
//
//                        if prevLineNextAttributes.frame.maxY > currentLineAttributes.frame.maxY {
//                            var frame = currentLineAttributes.frame;
//                            frame.origin.y = prevLineNextAttributes.frame.maxY
//                            currentLineAttributes.frame = frame;
//                        }
//
//                        lines += 1
//                        lineFirstIndexList[lines] = index
//                    }
//
//                    //修改每一行的第二个item以及d之后的item的位置
//                    if lines > 1 && lineMinX > 0 {
//                        let prevLineAttributes = array[index - lineFirstIndexList[lines]!]
//
//                        //防止顶上去的时候把前后高出的部分覆盖
//                        let prevLinePreviousAttributes = array[index - lineFirstIndexList[lines]! - 1] //当前行对应上一行的前一个
//                        let prevLineNextAttributes = array[index - lineFirstIndexList[lines]! + 1] //当前行对应上一行的后一个
//
//                        let currentLineAttributes = array[index]
//
//                        var getMaxY = prevLineAttributes.frame.maxY > prevLinePreviousAttributes.frame.maxY ? prevLineAttributes.frame.maxY : prevLinePreviousAttributes.frame.maxY
//                        getMaxY = getMaxY > prevLineNextAttributes.frame.maxY ? getMaxY : prevLineNextAttributes.frame.maxY
//
//                        var frame = currentLineAttributes.frame;
//                        frame.origin.y = getMaxY
//                        currentLineAttributes.frame = frame;
//                    }
                }
            }
            return array
        }
        return [UICollectionViewLayoutAttributes]()
    }
}
