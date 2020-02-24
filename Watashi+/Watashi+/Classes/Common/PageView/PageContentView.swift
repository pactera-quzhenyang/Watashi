//
//  PageContentView.swift
//  DNSPageView
//
//  Created by qzy on 2020/2/13.
//  Copyright © 2020 qzy. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

open class PageContentView: UIView {
    
    public weak var delegate: PageContentViewDelegate?
    
    public weak var eventHandler: PageEventHandleable?
    
    public var style: PageStyle
    
    public var childViewControllers : Observable<[UIViewController]>
    
    /// 初始化后，默认显示的页数
    public var currentIndex: Int
    
    private var startOffsetX: CGFloat = 0
    
    private var isForbidDelegate: Bool = false

    let disposeBag = DisposeBag()

    public var titleView: PageTitleView!
    
    private (set) public lazy var collectionView: UICollectionView = {
        let layout = PageCollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        if #available(iOS 10, *) {
            collectionView.isPrefetchingEnabled = false
        }
        collectionView.register(cellType: BaseCollectionViewCell.self)
        return collectionView
    }()
    
    
    public init(frame: CGRect, style: PageStyle, childViewControllers: Observable<[UIViewController]>, currentIndex: Int) {
        self.childViewControllers = childViewControllers
        self.style = style
        self.currentIndex = currentIndex
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.childViewControllers = Observable<[UIViewController]>.just([])
        self.style = PageStyle()
        self.currentIndex = 0
        super.init(coder: aDecoder)
    }
    

    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        let layout = collectionView.collectionViewLayout as! PageCollectionViewFlowLayout
        layout.itemSize = bounds.size
        layout.offset = CGFloat(currentIndex) * bounds.size.width
    }
}


extension PageContentView {
    public func setupUI() {
        addSubview(collectionView)
        
        collectionView.backgroundColor = style.contentViewBackgroundColor
        collectionView.isScrollEnabled = false

        bind()
    }

    func bind() {
        collectionView.rx.willBeginDragging
            .subscribe {[weak self] () in
                self?.isForbidDelegate = false
                self?.startOffsetX = self?.collectionView.contentOffset.x ?? 0
        }.disposed(by: disposeBag)

        collectionView.rx.didEndDragging
            .subscribe(onNext:{[weak self] (decelerate) in
                if !decelerate {
                    self?.collectionViewDidEndScroll()
                }
            }).disposed(by: disposeBag)

        collectionView.rx.didEndDecelerating
            .subscribe(onNext:{[weak self] () in
                self?.collectionViewDidEndScroll()
            }).disposed(by: disposeBag)

        collectionView.rx.didEndDragging
            .map({[weak self] (didEnd) in
                let index = Int(round((self?.collectionView.contentOffset.x)! / (self?.collectionView.bounds.width)!))
                return index
            })
            .bind(to: rx.currentIndex)
            .disposed(by: disposeBag)

        collectionView.rx.didEndDecelerating
            .map({[weak self] () in
                let index = Int(round((self?.collectionView.contentOffset.x)! / (self?.collectionView.bounds.width)!))
                return index
            })
            .bind(to: rx.currentIndex)
            .disposed(by: disposeBag)

        collectionView.rx.didEndDragging
            .map({[weak self] (didEnd) in
                let index = Int(round((self?.collectionView.contentOffset.x)! / (self?.collectionView.bounds.width)!))
                return index
            })
            .bind(to: titleView.rx.currentIndex)
            .disposed(by: disposeBag)

        collectionView.rx.didEndDecelerating
            .map({[weak self] () in
                let index = Int(round((self?.collectionView.contentOffset.x)! / (self?.collectionView.bounds.width)!))
                return index
            })
            .bind(to: titleView.rx.currentIndex)
            .disposed(by: disposeBag)

        collectionView.rx.didEndDragging
            .map({[weak self] (didEnd) in
                let index = Int(round((self?.collectionView.contentOffset.x)! / (self?.collectionView.bounds.width)!))
                return self?.titleView.titleButtons[index] ?? UIButton()
            })
            .bind(to: titleView.bottomLine.rx.moveAnimated)
            .disposed(by: disposeBag)

        collectionView.rx.didEndDecelerating
            .map({[weak self] () in
                let index = Int(round((self?.collectionView.contentOffset.x)! / (self?.collectionView.bounds.width)!))
                return self?.titleView.titleButtons[index] ?? UIButton()
            })
            .bind(to: titleView.bottomLine.rx.moveAnimated)
            .disposed(by: disposeBag)

        childViewControllers.bind(to: collectionView.rx.items(cellIdentifier: BaseCollectionViewCell.self.reuseIdentifier)) { item, child, cell in
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            child.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(child.view)
        }.disposed(by: disposeBag)
    }

    private func collectionViewDidEndScroll() {
        let index = Int(round(collectionView.contentOffset.x / collectionView.bounds.width))
        for button in titleView.titleButtons {
            button.isSelected = false
        }
        titleView.titleButtons[index].isSelected = true
    }
}
