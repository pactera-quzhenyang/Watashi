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
    var searchHistoryView = SWSearchHistoryView()
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String,SWSearchHistoryModel>>?
    let disposeBag = DisposeBag()
    var selectIndex: Int?
    var dataList = Variable([String]())
    var sels = [Int]()

    var tableList = BehaviorSubject(value: [SectionModel<String, SWSearchHistoryModel>]())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listenDataSourceChange()
        bindViewModel()
    }

    func listenDataSourceChange() {
        _ = NotificationCenter.default.rx
            .notification(NSNotification.Name(NotifyName.searchListChange))
            .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe({ notify in
                if let userInfo = notify.element?.userInfo as? [String: Bool] {
                    let isShowAll = userInfo[SearchListChangeType.reloadCellHeight] ?? false
                    if isShowAll {
                        self.searchHistortViewModel.list = self.searchHistortViewModel.getAllHistoryData()
                        let newData = SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: self.searchHistortViewModel.list)])
                        self.tableList.onNext([newData])
                    } else {
                        self.searchHistortViewModel.list = self.searchHistortViewModel.getDefaultData(toIndex: self.searchHistortViewModel.toIndex)
                        let newData = SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: self.searchHistortViewModel.list)])
                        self.tableList.onNext([newData])
                    }
                    return
                }
                let object = notify.element?.object
                if object != nil {
                    let index = object  as? Int
                    self.searchHistortViewModel.list.remove(at: index ?? 0)
                    self.searchHistortViewModel.list = self.searchHistortViewModel.addItemAtLast()
                } else {
                    self.searchHistortViewModel.list.removeAll()
                }
                let newData = SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: self.searchHistortViewModel.list)])
                self.tableList.onNext([newData])
        })
    }

    func bindViewModel() {
        searchTableView.register(cellType: SWSearchHistoryTableViewCell.self)
        searchTableView.tableFooterView = UIView()

        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,SWSearchHistoryModel>>(configureCell: { (dataSouece, tv, indexPath, element) -> SWSearchHistoryTableViewCell in
            let cell = tv.dequeueReusableCell(for: indexPath, cellType: SWSearchHistoryTableViewCell.self)
            cell.setModel(model: element)
            return cell
        })
        dataSource!.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].model
        }

        searchHistoryView.setupUI(list: searchHistortViewModel.list)
        searchHistortViewModel.list = searchHistortViewModel.getDefaultData(toIndex: searchHistoryView.stopAtIndex)
        
        tableList = BehaviorSubject(value: [
            SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: searchHistortViewModel.list)]),
        ])
        tableList.bind(to: searchTableView.rx.items(dataSource: dataSource!)).disposed(by: disposeBag)
        searchTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    func collectionType() {
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
            cell.deleteButton.rx.tap.subscribe(onNext: {
                let ll = self.collectionView.cellForItem(at: IndexPath(item: self.sels.first!, section: 0)) as! SWSearchHistoryCollectionViewCell
                ll.deleteButton.isHidden = true
                ll.lineView.isHidden = true
                ll.tagLabel.snp.updateConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
                }
                self.dataList.value.remove(at: self.sels.first!)
                self.collectionView.reloadData()
            }).disposed(by: cell.disposBag)
            cell.longPress.rx.event.subscribe { (gesture) in
                if gesture.element?.state == UIGestureRecognizer.State.began {
                    if self.sels.count > 0 {
                        let ll = self.collectionView.cellForItem(at: IndexPath(item: self.sels.first!, section: 0)) as! SWSearchHistoryCollectionViewCell
                        ll.deleteButton.isHidden = true
                        ll.lineView.isHidden = true
                        ll.tagLabel.snp.updateConstraints { (make) in
                            make.edges.equalTo(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
                        }
                        self.sels.removeAll()
                    }
                    self.sels.append((gesture.element?.view!.tag)! - 1000)
                }
            }.disposed(by: cell.disposBag)
            return cell
        }.disposed(by: disposeBag)
    }
}

extension SWSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchHistortViewModel.list.count == 0 {
            return 0
        }
        searchHistoryView.setupUI(list: searchHistortViewModel.list)
        return searchHistoryView.frame.height + 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SWSearchHeaderView.loadFromNib()
        headerView.titleLabel.text = SearchPage.searchHistory
        headerView.trashButton.setImage(UIImage(named: "trash"), for: .normal)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchHistortViewModel.list.count == 0 {
            return 0
        }
        return 70
    }
}

extension SWSearchViewController: SWGridFlowLayoutDelegate {
    func gridFlowLayout(layout: SWGridFlowLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let title = dataList.value[indexPath.item]
        let att: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        var textWidth = (title.boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 30), options: .usesLineFragmentOrigin, attributes:att, context: nil)).size.width + 1
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
