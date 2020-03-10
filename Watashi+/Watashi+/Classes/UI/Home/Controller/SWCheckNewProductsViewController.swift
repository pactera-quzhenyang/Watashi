//
//  FirstViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/19.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

class SWCheckNewProductsViewController: SWBaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = UIStoryboard(name: "Home", bundle: nil)

    @IBOutlet weak var tableView: UITableView!

    var dataSource:RxTableViewSectionedReloadDataSource<SectionModel<String,SWCheckNewProductsModel>>?
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(cellType: SWCheckNewProductsCell.self)
        bind()
    }

    func bind() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,SWCheckNewProductsModel>>(configureCell: { (dataSouece, tv, indexPath, element) -> SWCheckNewProductsCell in
            let cell = tv.dequeueReusableCell(for: indexPath, cellType: SWCheckNewProductsCell.self)
            cell.setModel(model: element)
            return cell
        })
        let items = Observable.just([
        SectionModel(model: "お気に入りブランドの新商品", items: [
            SWCheckNewProductsModel(imageArray: ["1","2","3","4","5","6"])
            ]),
        SectionModel(model: "新着限定品", items: [
            SWCheckNewProductsModel(imageArray: ["7","8","9","10"])
            ]),
        SectionModel(model: "おすすめカテゴルーの新商品", items: [
            SWCheckNewProductsModel(imageArray: ["11"])
            ]),
        SectionModel(model: "お気に入りブランドの新商品", items: [
            SWCheckNewProductsModel(imageArray: ["12","13"])
            ]),
        SectionModel(model: "新着限定品", items: [
            SWCheckNewProductsModel(imageArray: ["14","15","16"])
            ]),
        SectionModel(model: "おすすめカテゴルーの新商品", items: [
            SWCheckNewProductsModel(imageArray: ["17","18","19","20","5","6","1","2","3","4","5","6"])
            ])
        ])
        items.bind(to: tableView.rx.items(dataSource: dataSource!)).disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SWCheckNewProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SWABTestingManager.shoppingCartsHeight()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SWCheckNewProductsHeaderView.loadFromNib()
        headerView.setTitle(title: (dataSource?[section].model)!)
        return headerView
    }

    //返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)
        -> CGFloat {
        return 50
    }
}
