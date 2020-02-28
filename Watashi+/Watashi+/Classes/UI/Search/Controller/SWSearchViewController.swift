//
//  SearchViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/18.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

class SWSearchViewController: SWBaseViewController {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var searchHistortViewModel = SWSearchHistoryViewModel()
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String,SWSearchHistoryModel>>?
    let disposeBag = DisposeBag()
    var selectIndex: Int?
    var dataList = Variable([String]())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
    }

    func bindViewModel() {
        searchTableView.register(cellType: SWSearchHistoryTableViewCell.self)
        collectionView.register(cellType: SWSearchHistoryCollectionViewCell.self)

        let flow = SWGridFlowLayout()
        flow.delegate = self
        flow.flowLayoutStyle = .verticalEqualHeight
        collectionView.collectionViewLayout = flow

        dataList = Variable(searchHistortViewModel.list)
        dataList.asObservable().bind(to: collectionView.rx.items){(collection,index,element) -> SWSearchHistoryCollectionViewCell in
            let cell = collection.dequeueReusableCell(for: IndexPath(item: index, section: 0), cellType: SWSearchHistoryCollectionViewCell.self)
            cell.tagLabel.text = element
            cell.tag = index + 1000
//            cell.deleteButton.rx.tap
//                .map({_ in cell.selectIndex})
//                .bind(to: self.searchHistortViewModel.rx.deleteItemAtIndexPath)
//                .disposed(by: cell.disposBag)
            cell.deleteButton.rx.tap.asDriver().drive(onNext: {
//                self.dataList.onNext(self.searchHistortViewModel.list)
                self.dataList.value.remove(at: cell.selectIndex)
                self.collectionView.reloadData()
            }).disposed(by: cell.disposBag)

            return cell
        }.disposed(by: disposeBag)

        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,SWSearchHistoryModel>>(configureCell: { (dataSouece, tv, indexPath, element) -> SWSearchHistoryTableViewCell in
            let cell = tv.dequeueReusableCell(for: indexPath, cellType: SWSearchHistoryTableViewCell.self)
            cell.setModel(model: element)
            return cell
        })
        let items1 = Observable.just([
        SectionModel(model: "搜索历史", items: [
            SWSearchHistoryModel(tagList: ["1231231231231231231231231231231231231231231231212213123123123123123123123123123123123123123123123123123","iphone","面膜","电脑桌","电竞椅","iphone8 plus","iphonexsmax","氨基酸洗面奶","空气清新剂"])
            ]),
        ])
        items1.bind(to: searchTableView.rx.items(dataSource: dataSource!)).disposed(by: disposeBag)
    }
}

extension SWSearchViewController: SWGridFlowLayoutDelegate {
    func gridFlowLayout(layout: SWGridFlowLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let title = dataList.value[indexPath.item]
        let att: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        var textWidth = (title.boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 30), options: .usesLineFragmentOrigin, attributes:att, context: nil)).size.width + 2
        textWidth = textWidth >= screenWidth - 60 ? screenWidth - 60 : textWidth
        return CGSize(width: textWidth + 30, height: 30)
    }

    func columnMarginInGridFlowLayout(_ layout: SWGridFlowLayout) -> CGFloat {
        return 10
    }

    func rowMarginInGridFlowLayout(_ layout: SWGridFlowLayout) -> CGFloat {
        return 10
    }

    func edgeInsetsInGridFlowLayout(_ layout: SWGridFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
