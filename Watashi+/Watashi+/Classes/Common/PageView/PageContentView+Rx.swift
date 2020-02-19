


//
//  PageContentView+Rx.swift
//  zst
//
//  Created by 曲振阳 on 2020/2/17.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: PageContentView {

    public var delegate: DelegateProxy<PageContentView, PageContentViewDelegate> {
        return RxPageContentViewDelegateProxy.proxy(for: base)
    }
    public var contentViewdidEndScrollAt: ControlEvent<()> {
        let source = delegate.methodInvoked(#selector(PageContentViewDelegate.contentView(_:didEndScrollAt:))).map { _ in }
        return ControlEvent(events: source)
    }

    public var currentIndex: ControlProperty<Int> {
        let proxy = RxPageContentViewDelegateProxy.proxy(for: base)

        let bindingObserver = Binder(self.base) { pageContentView, currentIndex in
            pageContentView.currentIndex = currentIndex
        }

        return ControlProperty(values: proxy.selectIndexBehaviorSubject, valueSink: bindingObserver)
    }

    public var didSelectIndex: ControlEvent<Void> {
        let source = RxPageContentViewDelegateProxy.proxy(for: base).selectIndexPublishSubject
        return ControlEvent(events: source)
    }
}
