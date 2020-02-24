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

class FirstViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = UIStoryboard(name: "Home", bundle: nil)

    @IBOutlet weak var tableView: UITableView!

    var dataSource:RxTableViewSectionedReloadDataSource<SectionModel<String,SectionDataModel>>?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(cellType: FirstTableViewCell.self)
        bind()
    }

    func bind() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,SectionDataModel>>(configureCell: { (dataSouece, tv, indexPath, element) -> FirstTableViewCell in
            let cell = tv.dequeueReusableCell(for: indexPath, cellType: FirstTableViewCell.self)
            cell.setModel(model: element)
            return cell
        })
        let items = Observable.just([
        SectionModel(model: "お気に入りブランドの新商品", items: [
            SectionDataModel(imageArray: ["icon_chat_normal","icon_chat_select","icon_group_chat_normal","icon_group_chat_select","icon_member_normal","icon_member_select"])
            ]),
        SectionModel(model: "新着限定品", items: [
            SectionDataModel(imageArray: ["icon_member_normal","icon_member_select","icon_chat_normal","icon_chat_select"])
            ]),
        SectionModel(model: "おすすめカテゴルーの新商品", items: [
            SectionDataModel(imageArray: ["icon_group_chat_select","icon_member_normal","icon_chat_normal","icon_chat_select","icon_group_chat_normal",])
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

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = FirstHeaderView.loadFromNib()
        headerView.setTitle(title: (dataSource?[section].model)!)
        return headerView
    }

    //返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)
        -> CGFloat {
        return 50
    }
}
