//
//  RxPageTitleViewDelegateProxy.swift
//  zst
//
//  Created by 曲振阳 on 2020/2/14.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension PageTitleView: HasDelegate {
    public typealias Delegate = PageTitleViewDelegate
}

open class RxPageViewDelegateProxy
    : DelegateProxy<PageTitleView, PageTitleViewDelegate>
    , DelegateProxyType
, PageTitleViewDelegate {
    /// Typed parent object.
    public weak private(set) var pageTitleView: PageTitleView?

    /// - parameter scrollView: Parent object for delegate proxy.
    public init(pageTitleView: ParentObject) {
        self.pageTitleView = pageTitleView
        super.init(parentObject: pageTitleView, delegateProxy: RxPageViewDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxPageViewDelegateProxy(pageTitleView: $0) }
    }

    fileprivate var _selectIndexBehaviorSubject: BehaviorSubject<Int>?
    fileprivate var _selectIndexPublishSubject: PublishSubject<()>?

    /// Optimized version used for observing content offset changes.
    internal var selectIndexBehaviorSubject: BehaviorSubject<Int> {
        if let subject = _selectIndexBehaviorSubject {
            return subject
        }

        let subject = BehaviorSubject<Int>(value: self.pageTitleView?.currentIndex ?? 0)
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

    public func titleView(_ titleView: PageTitleView, didSelectAt index: Int) {
        if let subject = _selectIndexBehaviorSubject {
            subject.on(.next(titleView.currentIndex))
        }
        if let subject = _selectIndexPublishSubject {
            subject.on(.next(()))
        }
        self._forwardToDelegate?.titleView(titleView, didSelectAt: index)
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
