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

class SWSearchViewController: SWBaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = UIStoryboard(name: "Search", bundle: nil)

    @IBOutlet weak var searchTableView: UITableView!

    var searchHistortViewModel = SWSearchHistoryViewModel()
    var searchHistoryView = SWSearchHistoryView()
    var searchFoundViewModel = SWSearchFoundViewModel()
    var searchFoundView = SWSearchFoundView()
    var searchDataViewModel = SWSearchDataViewModel()
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String,SWSearchHistoryModel>>?
    var tableList = BehaviorSubject(value: [SectionModel<String, SWSearchHistoryModel>]())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNaviBarStyle()
        listenDataSourceChange()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseNavigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func setNaviBarStyle() {
        baseNavigationController?.barStyle = .searchView
    }

    func listenDataSourceChange() {
        _ = NotificationCenter.default.rx
            .notification(NSNotification.Name(NotificationName.searchListChange))
            .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe({ notify in
                if let userInfo = notify.element?.userInfo as? [String: Any] {
                    for (_, element) in userInfo.enumerated() {
                        switch element.key {
                        case SearchListChangeType.removeObjectAtIndex:
                            let index = element.value as? Int
                            self.searchHistortViewModel.list.remove(at: index ?? 0)
                            if !SWSearchHistoryManager.shared.isShowAll {
                                self.searchHistortViewModel.list = self.searchHistortViewModel.addItemAtLast()
                                self.getDefaultHistoryData()
                            }
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
                }
        })
    }

    func bindViewModel() {
        searchTableView.register(cellType: SWSearchHistoryTableViewCell.self)
        searchTableView.register(cellType: SWSearchResultTableViewCell.self)
        searchTableView.tableFooterView = UIView()

        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,SWSearchHistoryModel>>(configureCell: {[weak self] (dataSouece, tv, indexPath, element) in
            guard let weakSelf = self else { return UITableViewCell() }
            if weakSelf.searchDataViewModel.dataList.count > 0 {
                let cell = tv.dequeueReusableCell(for: indexPath, cellType: SWSearchResultTableViewCell.self)
                cell.textLabel?.text = element.tagList?.first
                return cell
            }
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

        getDefaultHistoryData()
        
        tableList = BehaviorSubject(value: [
            SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: searchHistortViewModel.list)]),
            SectionModel(model: SearchPage.searchFound, items: [SWSearchHistoryModel(tagList: searchFoundViewModel.list)]),
        ])
        tableList.bind(to: searchTableView.rx.items(dataSource: dataSource!)).disposed(by: disposeBag)
        searchTableView.rx.setDelegate(self).disposed(by: disposeBag)

        let tap = UITapGestureRecognizer()
        searchTableView.addGestureRecognizer(tap)

        tap.rx.event.subscribe(onNext: {[weak self] (grs) in
            self?.searchTableView.reloadData()
            }).disposed(by: disposeBag)

//        searchFiled.searchField.rx.text.orEmpty
//            .throttle(0.2, scheduler: MainScheduler.instance)
//            .map({_ in [String]()})
//            .bind(to: searchDataViewModel.rx.dataList)
//            .disposed(by: disposeBag)
//        searchFiled.searchField.rx.text.changed.subscribe(onNext: {[weak self] (text) in
//            guard let weakSelf = self else { return }
//            if text?.count == 0 {
//                let newData = [
//                    SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: weakSelf.searchHistortViewModel.list)]),
//                    SectionModel(model: SearchPage.searchFound, items: [SWSearchHistoryModel(tagList: weakSelf.searchFoundViewModel.list)])
//                    ]
//                weakSelf.tableList.onNext(newData)
//                return
//            }
//            weakSelf.searchDataViewModel.getData()
//            let newData = [
//                SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: weakSelf.searchDataViewModel.dataList),SWSearchHistoryModel(tagList: weakSelf.searchDataViewModel.dataList),SWSearchHistoryModel(tagList: weakSelf.searchDataViewModel.dataList),SWSearchHistoryModel(tagList: weakSelf.searchDataViewModel.dataList),SWSearchHistoryModel(tagList: weakSelf.searchDataViewModel.dataList),SWSearchHistoryModel(tagList: weakSelf.searchDataViewModel.dataList)]),
//                ]
//            weakSelf.tableList.onNext(newData)
//            }).disposed(by: disposeBag)
//        searchFiled.cancelButton.rx.tap.subscribe(onNext: {[weak self] (text) in
//            guard let weakSelf = self else { return }
//            weakSelf.tabBarController?.selectedIndex = 0
//            }).disposed(by: disposeBag)
    }

    func getDefaultHistoryData() {
        //为了默认显示两行，删除多出来部分的数据
        searchHistoryView.setupUI(list: searchHistortViewModel.list)
        searchHistortViewModel.list = searchHistortViewModel.getDefaultData(toIndex: searchHistoryView.stopAtIndex)
    }
}

extension SWSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchDataViewModel.dataList.count > 0 {
            return 50
        }
        if indexPath.section == 0 {
            if searchHistortViewModel.list.count == 0 {
                return 0.01
            }
            return UITableView.automaticDimension
        }
        if searchFoundViewModel.list.count == 0 {
            return 80
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchDataViewModel.dataList.count > 0 {
            return nil
        }
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
        if section == 0 && searchHistortViewModel.list.count == 0 || searchDataViewModel.dataList.count > 0 {
            return 0.01
        }
        return 70
    }
}
