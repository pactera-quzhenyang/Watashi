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
            var lines = 1 // 当前行数
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

                    //每一排的第一个上下在一起
                    let lineMinX = currentLayoutAttributes.frame.minX
                    if lineMinX == 0 {
                        let prevLineAttributes = array[lineFirstIndexList[lines]!]
                        let prevLineNextAttributes = array[lineFirstIndexList[lines]! + 1] //找到上一行的第二个，防止向上顶的时候把第二个盖上
                        let currentLineAttributes = array[index]

                        var frame = currentLineAttributes.frame;
                        frame.origin.y =  prevLineAttributes.frame.maxY > prevLineNextAttributes.frame.maxY ? prevLineAttributes.frame.maxY : prevLineNextAttributes.frame.maxY
                        currentLineAttributes.frame = frame;

                        lines += 1
                        lineFirstIndexList[lines] = index
                    }
                    print(lineFirstIndexList)

                    if lines == 2 && lineMinX > 0 {
                        let prevLineAttributes = array[index - lineFirstIndexList[lines]!]
                        let currentLineAttributes = array[index]

                        var frame = currentLineAttributes.frame;
                        frame.origin.y = prevLineAttributes.frame.maxY
                        currentLineAttributes.frame = frame;
                    }
                }
            }
            return array
        }
        return [UICollectionViewLayoutAttributes]()
    }
}
