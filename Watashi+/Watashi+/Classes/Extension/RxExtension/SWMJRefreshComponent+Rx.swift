//
//  SWMJRefreshComponent+Rx.swift
//  Watashi+
//
//  Created by NULL on 2020/2/28.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base: MJRefreshComponent {
    
    /// 正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer -> Disposable in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    /// 停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
    
}
