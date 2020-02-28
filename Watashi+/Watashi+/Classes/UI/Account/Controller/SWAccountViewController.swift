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
class SWAccountViewController: SWBaseViewController {

    let a = UITableViewDelegateDataSource_A()
    let b = UITableViewDelegateDataSource_B()
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    let dis = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let dataSource = SWABTestProtocolDispatcher(protocol: UITableViewDataSource.self, withIndexImplemertor: 0, toImplemertors: [a, b])
//        tableView.dataSource = dataSource as? UITableViewDelegateDataSource_A
//        tableView.dataSource = dataSource as? UITableViewDelegateDataSource_B
//        tableView.dataSource = dataSources() as? UITableViewDataSource
//        tableView.delegate = SWABTestProtocolDispatcher.dispatcherProtocol(UITableViewDelegate.self, withIndexImplemertor: 1, toImplemertors: [a, b]) as? UITableViewDelegate
//        let desc = protocol_getMethodDescription(UITableViewDataSource.self, <#T##aSel: Selector##Selector#>, true, true)
//        tableView.delegate = delegatess() as? UITableViewDelegate
//        let data = dataSources() as? UITableViewDataSource
//
//        items.bind(to: tableView.rx.items(dataSource: dataSource!)).disposed(by: dis)
//
//        tableView.rx.setDelegate(self).disposed(by: dis)
        
    }
    

    func dataSources() -> Any {
       return a
    }
    
    func delegatess() -> Any {
        return a
    }
    
}



class UITableViewDelegateDataSource_A: NSObject, UITableViewDataSource, UITableViewDelegate {
    let dis = DisposeBag()
//    func bind() -> Observable<SectionModel<String, SWCheckNewProductsModel>> {
//        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SWCheckNewProductsModel>>(configureCell: { (dataSouece, tv, indexPath, element) -> UITableViewCell in
//            let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = "a----\(indexPath.row)"
//            return cell
//        })
//        let items = Observable.just([
//        SectionModel(model: "お気に入りブランドの新商品", items: [
//            SWCheckNewProductsModel(imageArray: ["1","2","3","4","5","6"])
//            ]),
//        SectionModel(model: "新着限定品", items: [
//            SWCheckNewProductsModel(imageArray: ["7","8","9","10"])
//            ]),
//        SectionModel(model: "おすすめカテゴルーの新商品", items: [
//            SWCheckNewProductsModel(imageArray: ["11"])
//            ]),
//        SectionModel(model: "お気に入りブランドの新商品", items: [
//            SWCheckNewProductsModel(imageArray: ["12","13"])
//            ]),
//        SectionModel(model: "新着限定品", items: [
//            SWCheckNewProductsModel(imageArray: ["14","15","16"])
//            ]),
//        SectionModel(model: "おすすめカテゴルーの新商品", items: [
//            SWCheckNewProductsModel(imageArray: ["17","18","19","20","5","6","1","2","3","4","5","6"])
//            ])
//        ])
//        
////        items.bind(to: tableView.rx.items(dataSource: dataSource!)).disposed(by: dis)
////
////        tableView.rx.setDelegate(self).disposed(by: dis)
//        return items
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "a----\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("aaaaaa")
    }

}


class UITableViewDelegateDataSource_B: NSObject, UITableViewDataSource, UITableViewDelegate {
    let dis = DisposeBag()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "b----\(indexPath.row)"
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("bbbbb")
    }
}
