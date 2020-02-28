//
//  AccountViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/24.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import MJRefresh
class SWAccountViewController: SWBaseViewController {

    
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    let dis = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.mj_header = MJRefreshNormalHeader()
        tableView.mj_footer = MJRefreshBackNormalFooter()
//        let viewModel = SWAccountViewModel(headerRefresh: tableView.mj_header!.rx.refreshing.asDriver())
//
//        viewModel.tableData.drive(tableView.rx.items(cellIdentifier: "cell")) { (row, element, cell) in
//            cell.textLabel?.text = "\(row + 1)、\(element)"
//        }.disposed(by: dis)
//
//        viewModel.endHeaderRefreshing.drive(tableView.mj_header!.rx.endRefreshing).disposed(by: dis)
        
        //初始化ViewModel
        let viewModel = SWAccountViewModel(
            input: (
                headerRefresh: tableView.mj_header!.rx.refreshing.asDriver(),
                footerRefresh: tableView.mj_footer!.rx.refreshing.asDriver()),
            dependency: (
                disposeBag: dis,
                networkService: NetworkService()))
         
        //单元格数据的绑定
        viewModel.tableData.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "cell")) { (row, element, cell) in
               
                cell.textLabel?.text = "\(row + 1)、\(element)"
                
            }
            .disposed(by: dis)
         
        //下拉刷新状态结束的绑定
        viewModel.endHeaderRefreshing
            .drive(tableView.mj_header!.rx.endRefreshing)
            .disposed(by: dis)
         
        //上拉刷新状态结束的绑定
        viewModel.endFooterRefreshing
            .drive(tableView.mj_footer!.rx.endRefreshing)
            .disposed(by: dis)
        
    }
    
    
}


