//
//  PageTitleView.swift
//  DNSPageView
//
//  Created by qzy on 2020/2/13.
//  Copyright © 2020 qzy. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

open class PageTitleView: UIView {
    
    public weak var delegate: PageTitleViewDelegate?
    
    public var currentIndex: Int
    
    private (set) public lazy var titleButtons: [UIButton] = [UIButton]()
    
    public var style: PageStyle
    
    public var titles: [String]

    let disposeBag = DisposeBag()

    public var pageContentView: PageContentView!
    
    
    private lazy var normalRGB: ColorRGB = self.style.titleColor.getRGB()
    private lazy var selectRGB: ColorRGB = self.style.titleSelectedColor.getRGB()
    private lazy var deltaRGB: ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    public lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.layer.cornerRadius = self.style.bottomLineRadius
        return bottomLine
    }()
    
    private (set) public lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverViewBackgroundColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
    }()
    
    public init(frame: CGRect, style: PageStyle, titles: [String], currentIndex: Int) {
        self.style = style
        self.titles = titles
        self.currentIndex = currentIndex
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.style = PageStyle()
        self.titles = [String]()
        self.currentIndex = 0
        super.init(coder: aDecoder)
        
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = self.bounds
        
        setupLabelsLayout()
        setupBottomLineLayout()
    }
}


// MARK: - 设置UI界面
extension PageTitleView {
    public func setupUI() {
        addSubview(scrollView)
        
        scrollView.backgroundColor = style.titleViewBackgroundColor
        
        setuptitleButtons()
        setupBottomLine()
    }
    
    private func setuptitleButtons() {
        for (i, title) in titles.enumerated() {
            let button = UIButton()
            
            button.tag = i
            button.setTitle(title, for: .normal)
            button.setTitleColor(style.titleColor, for: .normal)
            button.setTitleColor(style.titleSelectedColor, for: .selected)
            button.titleLabel?.font = style.titleFont
            if i == currentIndex {
                button.isSelected = true
            }
            scrollView.addSubview(button)
    
            titleButtons.append(button)
        }
        bindTitleButton()
    }

    func bindTitleButton() {
        let selectedButton = Observable.from(
            self.titleButtons.map { button in button.rx.tap.map { button } }
            ).merge()
        self.titleButtons.reduce(Disposables.create()) { disposable, button in
                let subscription = selectedButton.map { $0 == button }
                .bind(to: (button.rx.isSelected))
                return Disposables.create(disposable, subscription)
            }.disposed(by: disposeBag)

        self.titleButtons.reduce(Disposables.create()) { disposable, button in
            let subsciption = selectedButton.filter({ $0.isSelected})
                .bind(to: (bottomLine.rx.moveAnimated))
            return Disposables.create(disposable, subsciption)
        }.disposed(by: disposeBag)

        self.titleButtons.reduce(Disposables.create()) { disposable, button in
            let subsciption = selectedButton.filter({ $0.isSelected })
                .map({ $0.tag })
                .bind(to: (rx.currentIndex))
            return Disposables.create(disposable, subsciption)
        }.disposed(by: disposeBag)

        self.titleButtons.reduce(Disposables.create()) { disposable, button in
            let subsciption = selectedButton.filter({ $0.isSelected })
                .map({ $0.tag })
                .bind(to: (pageContentView.rx.currentIndex))
            return Disposables.create(disposable, subsciption)
        }.disposed(by: disposeBag)

        self.titleButtons.reduce(Disposables.create()) { disposable, button in
            let subsciption = selectedButton.filter({ $0.isSelected })
                .map({ $0.tag })
                .subscribe(onNext:{[weak self] (index) in
                    self?.pageContentView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
                })
            return Disposables.create(disposable, subsciption)
        }.disposed(by: disposeBag)
    }
    
    private func setupBottomLine() {
        guard style.isShowBottomLine else { return }
        
        scrollView.addSubview(bottomLine)
    }
}


// MARK: - Layout
extension PageTitleView {
    private func setupLabelsLayout() {
        
        var x: CGFloat = 0
        let y: CGFloat = 0
        var width: CGFloat = 0
        let height = frame.height
        
        let count = titleButtons.count
        for (i, titleLabel) in titleButtons.enumerated() {
            if style.isTitleViewScrollEnabled {
                width = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : style.titleFont], context: nil).width
                x = i == 0 ? style.titleMargin * 0.5 : (titleButtons[i - 1].frame.maxX + style.titleMargin)
            } else {
                width = frame.width / CGFloat(count)
                x = width * CGFloat(i)
            }
            titleLabel.transform = CGAffineTransform.identity
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        if style.isTitleScaleEnabled {
            titleButtons[currentIndex].transform = CGAffineTransform(scaleX: style.titleMaximumScaleFactor, y: style.titleMaximumScaleFactor)
        }
        
        if style.isTitleViewScrollEnabled {
            guard let titleLabel = titleButtons.last else { return }
            scrollView.contentSize.width = titleLabel.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setupBottomLineLayout() {
        guard currentIndex < titleButtons.count else { return }
        let label = titleButtons[currentIndex]
        
        bottomLine.frame.size.width = style.bottomLineWidth > 0 ? style.bottomLineWidth : label.frame.width
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.center.x = label.center.x
        bottomLine.frame.origin.y = frame.height - bottomLine.frame.height
    }
}
