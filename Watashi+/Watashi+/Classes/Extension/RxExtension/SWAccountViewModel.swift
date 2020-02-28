//
//  SWAccountViewModel.swift
//  Watashi+
//
//  Created by NULL on 2020/2/28.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import RxSwift
import RxCocoa

class SWAccountViewModel {

    
    let tableData = BehaviorRelay<[String]>(value: [])

    /// 停止头部刷新状态
    let endHeaderRefreshing: Driver<Bool>

    /// 停止尾部刷新状态
    let endFooterRefreshing: Driver<Bool>

    ///ViewModel初始化（根据输入实现对应的输出）
    init(input: (
            headerRefresh: Driver<Void>,
            footerRefresh: Driver<Void>),
         dependency: (
            disposeBag: DisposeBag,
            networkService: NetworkService)) {

        
        // 下拉结果序列
        let headerRefreshData = input.headerRefresh
            .startWith(()) //初始化时会先自动加载一次数据
            .flatMapLatest{ return dependency.networkService.getRandomResult() }

        // 上拉结果序列
        let footerRefreshData = input.footerRefresh
            .flatMapLatest{ return dependency.networkService.getRandomResult() }

        // 生成停止头部刷新状态序列
        endHeaderRefreshing = headerRefreshData.map{ _ in true }

        // 生成停止尾部刷新状态序列
        endFooterRefreshing = footerRefreshData.map{ _ in true }

        // 下拉刷新时，直接将查询到的结果替换原数据
        headerRefreshData.drive(onNext: { items in
            self.tableData.accept(items + self.tableData.value)
        }).disposed(by: dependency.disposeBag)

        // 上拉加载时，将查询到的结果拼接到原数据底部
        footerRefreshData.drive(onNext: { items in
            self.tableData.accept(self.tableData.value + items )
        }).disposed(by: dependency.disposeBag)
    }
    
//    // 表格数据序列
//    let tableData = BehaviorRelay<[String]>(value: [])
//
//    // 停止头部刷新状态
//    let endHeaderRefreshing: Observable<Bool>
//
//    // 停止尾部刷新状态
//    let endFooterRefreshing: Observable<Bool>
//
//    // ViewModel初始化（根据输入实现对应的输出）
//    init(input: (
//            headerRefresh: Observable<Void>,
//            footerRefresh: Observable<Void> ),
//         dependency: (
//            disposeBag:DisposeBag,
//            networkService: NetworkService )) {
//        print(Thread.current)
//        //下拉结果序列
//        let headerRefreshData = input.headerRefresh
//            .startWith(()) //初始化时会先自动加载一次数据
//            .flatMapLatest{ _ in
//                dependency.networkService.getRandomResult()
//                    .takeUntil(input.footerRefresh)
//        }.share(replay: 1).observeOn(MainScheduler.instance) //让HTTP请求是被共享的
//
//
//        //上拉结果序列
//        let footerRefreshData = input.footerRefresh
//            .flatMapLatest{ _ in
//                dependency.networkService.getRandomResult()
//                    .takeUntil(input.headerRefresh)
//            }.share(replay: 1).observeOn(MainScheduler.instance) //让HTTP请求是被共享的
//
//        //生成停止头部刷新状态序列
//        self.endHeaderRefreshing = Observable.merge(
//            headerRefreshData.map{ _ in true },
//            input.footerRefresh.map{ _ in true }
//        ).observeOn(MainScheduler.instance)
//
//        //生成停止尾部刷新状态序列
//        self.endFooterRefreshing = Observable.merge(
//            footerRefreshData.map{ _ in true },
//            input.headerRefresh.map{ _ in true }
//         ).observeOn(MainScheduler.instance)
//
//        //下拉刷新时，直接将查询到的结果替换原数据
//        headerRefreshData.subscribe(onNext: { items in
//            self.tableData.accept(items)
//        }).disposed(by: dependency.disposeBag)
//
//        //上拉加载时，将查询到的结果拼接到原数据底部
//        footerRefreshData.subscribe(onNext: { items in
//            self.tableData.accept(self.tableData.value + items )
//        }).disposed(by: dependency.disposeBag)
//        print(Thread.current)
//    }
    
    deinit {
        print(#file, #function)
    }
}

class NetworkService {
     
    //获取随机数据
    func getRandomResult() -> Driver<[String]> {
        print("正在请求数据......")
        let items = (0 ..< 1).map {_ in
            "随机数据\(Int(arc4random()))"
        }
        let observable = Observable.just(items)
        return observable
            .delay(1, scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: Driver.empty())
     }
    
//    func getRandomResult() -> Observable<[String]> {
//        print("正在请求数据......")
//        let items = (0 ..< 15).map {_ in
//            "随机数据\(Int(arc4random()))"
//        }
//        let observable = Observable.just(items)
//        return observable
//            .delay(2, scheduler: MainScheduler.instance)
//    }
}
