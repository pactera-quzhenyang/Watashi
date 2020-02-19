//
//  RxPageContentViewDelegateProxy.swift
//  zst
//
//  Created by 曲振阳 on 2020/2/14.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension PageContentView: HasDelegate {
    public typealias Delegate = PageContentViewDelegate
}

open class RxPageContentViewDelegateProxy
    : DelegateProxy<PageContentView, PageContentViewDelegate>
    , DelegateProxyType
, PageContentViewDelegate {

    /// Typed parent object.
    public weak private(set) var pageContentView: PageContentView?

    /// - parameter scrollView: Parent object for delegate proxy.
    public init(pageContentView: ParentObject) {
        self.pageContentView = pageContentView
        super.init(parentObject: pageContentView, delegateProxy: RxPageContentViewDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxPageContentViewDelegateProxy(pageContentView: $0) }
    }

    fileprivate var _selectIndexBehaviorSubject: BehaviorSubject<Int>?
    fileprivate var _selectIndexPublishSubject: PublishSubject<()>?

    /// Optimized version used for observing content offset changes.
    internal var selectIndexBehaviorSubject: BehaviorSubject<Int> {
        if let subject = _selectIndexBehaviorSubject {
            return subject
        }

        let subject = BehaviorSubject<Int>(value: self.pageContentView?.currentIndex ?? 0)
        _selectIndexBehaviorSubject = subject

        return subject
    }

    /// Optimized version used for observing content offset changes.
    internal var selectIndexPublishSubject: PublishSubject<()> {
        if let subject = _selectIndexPublishSubject {
            return subject
        }

        let subject = PublishSubject<()>()
        _selectIndexPublishSubject = subject

        return subject
    }

    public func contentView(_ contentView: PageContentView, didEndScrollAt index: Int) {
        if let subject = _selectIndexBehaviorSubject {
            subject.on(.next(contentView.currentIndex))
        }
        if let subject = _selectIndexPublishSubject {
            subject.on(.next(()))
        }
        self._forwardToDelegate?.contentView(contentView, didEndScrollAt: index)
    }

    deinit {
        if let subject = _selectIndexBehaviorSubject {
            subject.on(.completed)
        }

        if let subject = _selectIndexPublishSubject {
            subject.on(.completed)
        }
    }
}

