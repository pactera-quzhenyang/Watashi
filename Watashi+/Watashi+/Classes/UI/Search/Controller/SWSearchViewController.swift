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
import SnapKit

class SWSearchViewController: SWBaseViewController {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var searchHistortViewModel = SWSearchHistoryViewModel()
    var searchHistoryView = SWSearchHistoryView()
    var searchFoundViewModel = SWSearchFoundViewModel()
    var searchFoundView = SWSearchFoundView()
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
                if let userInfo = notify.element?.userInfo as? [String: Any] {
                    for (_, element) in userInfo.enumerated() {
                        switch element.key {
                        case SearchListChangeType.removeObjectAtIndex:
                            let index = element.value as? Int
                            self.searchHistortViewModel.list.remove(at: index ?? 0)
                            self.searchHistortViewModel.list = self.searchHistortViewModel.addItemAtLast()
                        case SearchListChangeType.removeAllObject:
                            self.searchHistortViewModel.list.removeAll()
                        case SearchListChangeType.reloadCellHeight:
                            let isShowAll = element.value as? Bool ?? false
                            if isShowAll {
                                self.searchHistortViewModel.list = self.searchHistortViewModel.getAllHistoryData()
                            } else {
                                self.searchHistortViewModel.list = self.searchHistortViewModel.getDefaultData(toIndex: self.searchHistortViewModel.toIndex)
                            }
                        case SearchListChangeType.hideSearchDiscover:
                            let isShowData = element.value as? Bool ?? false
                            if isShowData {
                                self.searchFoundViewModel.list = self.searchFoundViewModel.removeAllData()
                            } else {
                                self.searchFoundViewModel.list = self.searchFoundViewModel.showAllData()
                            }
                        default:
                            break
                        }
                    }
                    var newData = [
                        SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: self.searchHistortViewModel.list)]),
                        SectionModel(model: SearchPage.searchFound, items: [SWSearchHistoryModel(tagList: self.searchFoundViewModel.list)])
                        ]
                    if self.searchHistoryView.list.count == 0 {
                        newData.removeFirst()
                    }
                    self.tableList.onNext(newData)
//                    let isShowAll = userInfo[SearchListChangeType.reloadCellHeight] ?? false
//                    if isShowAll {
//                        self.searchHistortViewModel.list = self.searchHistortViewModel.getAllHistoryData()
//                        let newData = [
//                            SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: self.searchHistortViewModel.list)]),
//                            SectionModel(model: SearchPage.searchFound, items: [SWSearchHistoryModel(tagList: self.searchFoundViewModel.list)])
//                        ]
//                        self.tableList.onNext(newData)
//                    } else {
//                        self.searchHistortViewModel.list = self.searchHistortViewModel.getDefaultData(toIndex: self.searchHistortViewModel.toIndex)
//                        let newData = [
//                            SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: self.searchHistortViewModel.list)]),
//                            SectionModel(model: SearchPage.searchFound, items: [SWSearchHistoryModel(tagList: self.searchFoundViewModel.list)])
//                            ]
//                        self.tableList.onNext(newData)
//                    }
//                    return
//                }
//                let object = notify.element?.object
//                if object != nil {
//                    let index = object  as? Int
//                    self.searchHistortViewModel.list.remove(at: index ?? 0)
//                    self.searchHistortViewModel.list = self.searchHistortViewModel.addItemAtLast()
//                } else {
//                    self.searchHistortViewModel.list.removeAll()
//                }
//                let newData = [
//                    SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: self.searchHistortViewModel.list)]),
//                    SectionModel(model: SearchPage.searchFound, items: [SWSearchHistoryModel(tagList: self.searchFoundViewModel.list)])
//                    ]
//                self.tableList.onNext(newData)
        }
        })
    }

    func bindViewModel() {
        searchTableView.register(cellType: SWSearchHistoryTableViewCell.self)
        searchTableView.tableFooterView = UIView()

        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,SWSearchHistoryModel>>(configureCell: { (dataSouece, tv, indexPath, element) -> SWSearchHistoryTableViewCell in
            if indexPath.section == 0 {
                let cell = tv.dequeueReusableCell(for: indexPath, cellType: SWSearchHistoryTableViewCell.self)
                cell.setModel(model: element)
                return cell
            }
            let cell = tv.dequeueReusableCell(for: indexPath, cellType: SWSearchHistoryTableViewCell.self)
            cell.setSearchFound(model: element)
            return cell
        })
        dataSource!.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].model
        }

        //为了默认显示两行，删除多出来部分的数据
        searchHistoryView.setupUI(list: searchHistortViewModel.list)
        searchHistortViewModel.list = searchHistortViewModel.getDefaultData(toIndex: searchHistoryView.stopAtIndex)
        
        tableList = BehaviorSubject(value: [
            SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: searchHistortViewModel.list)]),
            SectionModel(model: SearchPage.searchFound, items: [SWSearchHistoryModel(tagList: searchFoundViewModel.list)]),
        ])
        tableList.bind(to: searchTableView.rx.items(dataSource: dataSource!)).disposed(by: disposeBag)
        searchTableView.rx.setDelegate(self).disposed(by: disposeBag)

        let tap = UITapGestureRecognizer()
        searchTableView.addGestureRecognizer(tap)

        tap.rx.event.subscribe(onNext: { (grs) in
            self.searchTableView.reloadData()
            }).disposed(by: disposeBag)
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
        if indexPath.section == 0 {
            if searchHistortViewModel.list.count == 0 {
                return 0.01
            }
            searchHistoryView.setupUI(list: searchHistortViewModel.list)
            return searchHistoryView.frame.height
        }
        if searchFoundViewModel.list.count == 0 {
            return 80
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = SWSearchHeaderView.loadFromNib()
            headerView.discoverButton.isHidden = true
            headerView.titleLabel.text = SearchPage.searchHistory
            return headerView
        }
        let headerView = SWSearchHeaderView.loadFromNib()
        headerView.trashButton.isHidden = true
        headerView.titleLabel.text = SearchPage.searchFound
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && searchHistortViewModel.list.count == 0 {
            return 0.01
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
