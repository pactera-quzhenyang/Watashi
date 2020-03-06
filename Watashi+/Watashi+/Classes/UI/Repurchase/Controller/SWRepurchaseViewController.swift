//
//  RepurchaseViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/24.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
class SWRepurchaseViewController: SWBaseViewController {
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    let loopBackView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
    let loop = CULoopBannerView()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let items = Observable.just(["1", "2", "1", "2", "1", "2", "1", "2", "1", "2", "1", "2", "1", "2"])
        items.bind(to: tableView.rx.items(cellIdentifier: "cell")) { (row, element, cell) in
                      
           cell.textLabel?.text = "\(row + 1)、\(element)"
           
       }
       .disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.itemSelect()
        }).disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        loop.images = ["1", "2", "3", "4", "5", "6"]
        loop.bindCollection()
        
        
        tableView.tableHeaderView = loopBackView
        tableView.insertSubview(loopBackView, at: 0)
        loopBackView.addSubview(loop)
        loop.frame = loopBackView.frame
//        self.view.addSubview(loop)
//        loop.snp.makeConstraints { (make) in
////            make.top.equalTo(100)
//            make.top.equalTo(0)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(300)
//        }
        
    }
    
    func itemSelect() {
        let narrowedModalView = CUSemiModalView(size:  CGSize(width: screenWidth, height: 400), baseViewController: navigationController!)
        narrowedModalView.contentView.backgroundColor = UIColor.white

        let label = UILabel.init(frame: CGRect(x: 100, y: 100, width: 100, height: 20))
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "暂无内容"
        narrowedModalView.contentView.addSubview(label)

        narrowedModalView.open()
    }
}

extension SWRepurchaseViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
//
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        itemSelect()
    }
}

extension SWRepurchaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame = loopBackView.frame
        frame.size.height = scrollView.contentOffset.y + 300 + 64
        loopBackView.frame = frame
        loop.center = loopBackView.center
//        loopBackView.removeFromSuperview()
        tableView.insertSubview(loopBackView, at: 0)
    }
}
