//
//  SWGridFlowLayout.swift
//  RXSwiftDemo
//
//  Created by NULL on 2020/2/26.
//  Copyright © 2020 NULL. All rights reserved.
//

import UIKit

@objc protocol SWGridFlowLayoutDelegate: NSObjectProtocol {
    
    /// 返回item的大小
    /// - Parameter layout: layout
    /// - Parameter indexPath: indexPath
    func gridFlowLayout(layout: SWGridFlowLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    
    /// 头视图Size
    /// - Parameter layout: layout
    /// - Parameter section: section
    @objc optional func gridFlowLayout(layout: SWGridFlowLayout, sizeForHeaderViewInSection section: Int) -> CGSize
    
    /// 尾视图Size
    /// - Parameter layout: layout
    /// - Parameter section: section
    @objc optional func gridFlowLayout(layout: SWGridFlowLayout, sizeForFooterViewInSection section: Int) -> CGSize
    
    /// 列数
    /// - Parameter layout: layout
    @objc optional func columnCountInGridFlowLayout(_ layout: SWGridFlowLayout) -> Int
    
    /// 列间距
    /// - Parameter layout: layout
    @objc optional func columnMarginInGridFlowLayout(_ layout: SWGridFlowLayout) -> CGFloat
    
    /// 行数
    /// - Parameter layout: layout
    @objc optional func rowCountInGridFlowLayout(_ layout: SWGridFlowLayout) -> Int
    /// 行间距
    /// - Parameter layout: layout
    @objc optional func rowMarginInGridFlowLayout(_ layout: SWGridFlowLayout) -> CGFloat
    
    /// 边缘之间的间距
    /// - Parameter layout: layout
    @objc optional func edgeInsetsInGridFlowLayout(_ layout: SWGridFlowLayout) -> UIEdgeInsets
}

class SWGridFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: SWGridFlowLayoutDelegate?
    var flowLayoutStyle: FlowLayoutStyle = .verticalEqualWidth
    
    fileprivate let defaultColumnCount: Int = 2
    fileprivate let defaultColumnMargin: CGFloat = 10
    fileprivate let defaultRowCount: Int = 5
    fileprivate let defaultRowMargin: CGFloat = 10
    fileprivate let defaultEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// 内容高度
    fileprivate var maxColumnHeight: CGFloat = 0
    
    /// 内容宽度
    fileprivate var maxRowWidth: CGFloat = 0
    
    /// 存放cell布局属性
    fileprivate lazy var attrsArray: [UICollectionViewLayoutAttributes] = []
    
    /// 存放每一列的最大y值
    fileprivate lazy var columnHeights: [CGFloat] = []
    
    /// 存放每一行的最大x值
    fileprivate lazy var rowWidths: [CGFloat] = []
    
    /// 列数
    fileprivate var columnCount: Int {
//        if  delegate?.responds(to: #selector(delegate?.columnCountInGridFlowLayout(_:))) ?? false {
//            return (delegate?.columnCountInGridFlowLayout?(self))!
//        }
//        return defaultColumnCount
        return delegate?.columnCountInGridFlowLayout?(self) ?? defaultColumnCount
    }
    
    /// 每一列之间的间距
    fileprivate var columnMargin: CGFloat {
//        if delegate?.responds(to: #selector(delegate?.columnMarginInGridFlowLayout(_:))) ?? false {
//            return (delegate?.columnMarginInGridFlowLayout?(self))!
//        }
        return delegate?.columnMarginInGridFlowLayout?(self) ?? defaultColumnMargin
    }
    
    /// 行数
    fileprivate var rowCount: Int {
        return delegate?.rowCountInGridFlowLayout?(self) ?? defaultRowCount
    }
    
    /// 每一行之间的间距
    fileprivate var rowMargin: CGFloat {
        return delegate?.rowMarginInGridFlowLayout?(self) ?? defaultRowMargin
    }
    
    /// 边缘之间的间距
    fileprivate var edgeInsets: UIEdgeInsets {
        return delegate?.edgeInsetsInGridFlowLayout?(self) ?? defaultEdgeInsets
    }
    
    override func prepare() {
        super.prepare()
        
        switch flowLayoutStyle {
        case .verticalEqualWidth:
            verticalEqualWidthPrepare()
            break
        case .verticalEqualHeight:
            verticalEqualHeightPrepare()
            break
        }
        //清除之前数组
        attrsArray.removeAll()
        
        let sections = collectionView?.numberOfSections ?? 0
        for section in 0 ..< sections {
            // 获取每一组头视图header的UICollectionViewLayoutAttributes
            if delegate?.responds(to: #selector(delegate?.gridFlowLayout(layout:sizeForHeaderViewInSection:))) ?? false {
                let headerAttrs = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))
                attrsArray.append(headerAttrs!)
            }
            
            // 开始创建组内的每一个cell的布局属性
            
            let rows = collectionView?.numberOfItems(inSection: section) ?? 0
            for row in 0 ..< rows {
                let attrs = layoutAttributesForItem(at: IndexPath(item: row, section: section))
                attrsArray.append(attrs!)
            }
            
            //获取每一组脚视图footer的UICollectionViewLayoutAttributes
            if delegate?.responds(to: #selector(delegate?.gridFlowLayout(layout:sizeForFooterViewInSection:))) ?? false {
                let footerAttrs = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section))
                attrsArray.append(footerAttrs!)
            }
        }
    }
    
    func verticalEqualWidthPrepare() {
        //清除以前计算的所有高度
        maxColumnHeight = 0;
        columnHeights.removeAll()
        for _ in 0 ..< columnCount {
            columnHeights.append(edgeInsets.top)
        }
    }
    
    func verticalEqualHeightPrepare() {
        //记录最后一个的内容的横坐标和纵坐标
        maxColumnHeight = 0;
        columnHeights.removeAll()
        columnHeights.append(edgeInsets.top)
        
        maxRowWidth = 0;
        rowWidths.removeAll()
        rowWidths.append(edgeInsets.left)
    }
    
    
    /// 决定一段区域所有cell和头尾视图的布局属性
    /// - Parameter rect: rect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    
    /// 返回indexPath位置cell对应的布局属性
    /// - Parameter indexPath: indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        switch flowLayoutStyle {
        case .verticalEqualWidth:
            attrs.frame = itemFrameOfVerticalEqualWidthFlow(indexPath: indexPath)
            break
        case .verticalEqualHeight:
            attrs.frame = itemFrameOfVerticalEqualHeightFlow(indexPath: indexPath)
            break
        }
        
        
        return attrs
    }
    
    /// 返回indexPath位置头和尾视图对应的布局属性
    /// - Parameter elementKind: 头和尾视图标识
    /// - Parameter indexPath: indexPath
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attrs: UICollectionViewLayoutAttributes?
        if UICollectionView.elementKindSectionHeader == elementKind {
            attrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attrs?.frame = headerViewFrameOfVerticalWaterFlow(indexPath: indexPath)
        } else {
            attrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            attrs?.frame = footerViewFrameOfVerticalWaterFlow(indexPath: indexPath)
        }
        return attrs
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxColumnHeight + edgeInsets.bottom)
    }
    
}

extension SWGridFlowLayout {
    
    /// 竖向瀑布流 item等宽不等高
    /// - Parameter indexPath: indexPath
    fileprivate func itemFrameOfVerticalEqualWidthFlow(indexPath: IndexPath) -> CGRect {
        let collectionW = collectionView?.frame.width
        // 设置布局属性item的frame
        let w = collectionW! - edgeInsets.left - edgeInsets.right
        let width = (w - CGFloat((columnCount - 1)) * columnMargin) / CGFloat(columnCount)
        let height = delegate?.gridFlowLayout(layout: self, sizeForItemAtIndexPath: indexPath).height
        // 找出高度最短的那一列
        var destColumn = 0
        var minColumnHeight = columnHeights[0]
        for i in 1 ..< columnCount {
            let columnHeight = columnHeights[i]
            if minColumnHeight > columnHeight {
                minColumnHeight = columnHeight
                destColumn = i
            }
        }
        
        let x = edgeInsets.left + CGFloat(destColumn) * (width + columnMargin)
        var y = minColumnHeight
        if y != edgeInsets.top {
            y += rowMargin
        }
        
        // 更新最短那列的高度
        columnHeights[destColumn] = CGRect(x: x, y: y, width: width, height: height!).maxY
        
        // 记录内容的高度
        let columnHeight = columnHeights[destColumn]
        if columnHeight > maxColumnHeight {
            maxColumnHeight = columnHeight
        }
        return CGRect(x: x, y: y, width: width, height: height!)
    }
    
    /// 竖向瀑布流 item等高不等宽
    /// - Parameter indexPath: indexPath
    fileprivate func itemFrameOfVerticalEqualHeightFlow(indexPath: IndexPath) -> CGRect {
        let collectionW = collectionView!.frame.width
        var headViewSize = CGSize(width: 0, height: 0)
        if delegate?.responds(to: #selector(delegate?.gridFlowLayout(layout:sizeForHeaderViewInSection:))) ?? false {
            headViewSize = (delegate?.gridFlowLayout!(layout: self, sizeForHeaderViewInSection: indexPath.section))!
        }
        
        let width = (delegate?.gridFlowLayout(layout: self, sizeForItemAtIndexPath: indexPath).width)!
        let height = (delegate?.gridFlowLayout(layout: self, sizeForItemAtIndexPath: indexPath).height)!
        var x: CGFloat = 0
        var y: CGFloat = 0
        // 记录最后一行的内容的横坐标和纵坐标
        let rowWidth = rowWidths.first ?? 0
        let columnHeight = columnHeights.first ?? 0
        if (collectionW - rowWidth) > (width + edgeInsets.right) {
            x = rowWidth == edgeInsets.left ? edgeInsets.left : rowWidth + columnMargin
            
            if columnHeight == edgeInsets.top {
                y = edgeInsets.top
            } else if columnHeight == edgeInsets.top + headViewSize.height {
                y = edgeInsets.top + headViewSize.height + rowMargin
            } else {
                y = columnHeight - height
            }
            rowWidths[0] = (x + width)
            
            if columnHeight == edgeInsets.top || columnHeight == edgeInsets.top + headViewSize.height {
                columnHeights[0] = (y + height)
            }
        } else if (collectionW - rowWidth) == (width + edgeInsets.right) {
            // 换行
            x = edgeInsets.left
            y = columnHeight + rowMargin
            rowWidths[0] = (x + width)
            columnHeights[0] = (y + height)
        } else {
            x = edgeInsets.left
            y = columnHeight  + rowMargin;
            rowWidths[0] = (x + width)
            columnHeights[0] = (y + height)
        }
        
        //记录内容的高度
        maxColumnHeight = columnHeights.first!
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    func headerViewFrameOfVerticalWaterFlow(indexPath: IndexPath) -> CGRect {
        var size = CGSize.zero
        if delegate?.responds(to: #selector(delegate?.gridFlowLayout(layout:sizeForHeaderViewInSection:))) ?? false {
            size = (delegate?.gridFlowLayout!(layout: self, sizeForHeaderViewInSection: indexPath.section))!
        }
        
        switch flowLayoutStyle {
        case .verticalEqualWidth:
            let x: CGFloat = 0
            var y = maxColumnHeight == 0 ? edgeInsets.top : maxColumnHeight
            if (delegate?.responds(to: #selector(delegate?.gridFlowLayout(layout:sizeForFooterViewInSection:))))! || delegate?.gridFlowLayout!(layout: self, sizeForFooterViewInSection: indexPath.section).height == 0 {
                y = maxColumnHeight == 0 ? edgeInsets.top : maxColumnHeight + rowMargin
            }
            
            maxColumnHeight = y + size.height
            columnHeights.removeAll()
            
            for _ in 0 ..< columnCount {
                columnHeights.append(maxColumnHeight)
            }
            return CGRect(x: x, y: y, width: collectionView!.frame.width, height: size.height)
            
          
        case .verticalEqualHeight:
            let x: CGFloat = 0
            var y = maxColumnHeight == 0 ? edgeInsets.top : maxColumnHeight
            if (delegate?.responds(to: #selector(delegate?.gridFlowLayout(layout:sizeForFooterViewInSection:))))! || delegate?.gridFlowLayout!(layout: self, sizeForFooterViewInSection: indexPath.section).height == 0 {
                y = maxColumnHeight == 0 ? edgeInsets.top : maxColumnHeight + rowMargin
            }
            maxColumnHeight = y + size.height
            rowWidths[0] = collectionView!.frame.width
            columnHeights[0] = maxColumnHeight
            return CGRect(x: x, y: y, width: collectionView!.frame.width, height: size.height)
        }
        
    }
    
    func footerViewFrameOfVerticalWaterFlow(indexPath: IndexPath) -> CGRect {
        var size = CGSize.zero
        if delegate?.responds(to: #selector(delegate?.gridFlowLayout(layout:sizeForFooterViewInSection:))) ?? false {
            size = (delegate?.gridFlowLayout!(layout: self, sizeForFooterViewInSection: indexPath.section))!
        }
        
        switch flowLayoutStyle {
        case .verticalEqualWidth:
            let x: CGFloat = 0
            let y = size.height == 0 ? maxColumnHeight : maxColumnHeight + rowMargin
            maxColumnHeight = y + size.height
            columnHeights.removeAll()
            
            for _ in 0 ..< columnCount {
                columnHeights.append(maxColumnHeight)
            }
            return CGRect(x: x, y: y, width: collectionView!.frame.width, height: size.height)
            
          
        case .verticalEqualHeight:
            let x: CGFloat = 0
            let y = size.height == 0 ? maxColumnHeight : maxColumnHeight + rowMargin
            maxColumnHeight = y + size.height
            rowWidths[0] = collectionView!.frame.width
            columnHeights[0] = maxColumnHeight
            return CGRect(x: x, y: y, width: collectionView!.frame.width, height: size.height)
        }
    }
}


extension SWGridFlowLayout {
    enum FlowLayoutStyle {
        case verticalEqualWidth // 竖向布局等宽不等高
        case verticalEqualHeight // 竖向布局等高不等宽
    }
}

