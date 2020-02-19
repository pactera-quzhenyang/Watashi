//
//  PageTitleView+Rx.swift
//  zst
//
//  Created by 曲振阳 on 2020/2/14.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: PageTitleView {

    public var delegate: DelegateProxy<PageTitleView, PageTitleViewDelegate> {
        return RxPageViewDelegateProxy.proxy(for: base)
    }
    
    public var titleViewDidSelectAt: ControlEvent<()> {
        let source = delegate.methodInvoked(#selector(PageTitleViewDelegate.titleView(_:didSelectAt:))).map { _ in }
        return ControlEvent(events: source)
    }

    public var currentIndex: ControlProperty<Int> {
        let proxy = RxPageViewDelegateProxy.proxy(for: base)

        let bindingObserver = Binder(self.base) { pageTitleView, currentIndex in
            pageTitleView.currentIndex = currentIndex
        }

        return ControlProperty(values: proxy.selectIndexBehaviorSubject, valueSink: bindingObserver)
    }

    public var didSelectIndex: ControlEvent<Void> {
        let source = RxPageViewDelegateProxy.proxy(for: base).selectIndexPublishSubject
        return ControlEvent(events: source)
    }
}
