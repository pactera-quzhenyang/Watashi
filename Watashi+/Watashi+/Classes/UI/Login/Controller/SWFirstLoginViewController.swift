//
//  SWFirstLoginViewController.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/9.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SWFirstLoginViewController: SWBaseViewController {

    let disposeBag = DisposeBag()
    let viewModel = SWFirstLoginViewModel()

    private (set) public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.backgroundColor = .white
        if #available(iOS 10, *) {
            collectionView.isPrefetchingEnabled = false
        }
        collectionView.collectionViewLayout = layout
        collectionView.register(cellType: SWFirstLoginCollectionViewCell.self)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(collectionView)
        bindViewModel()
    }

    func bindViewModel() {

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,SWSearchHistoryModel>>(configureCell: { (dataSouece, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(for: indexPath, cellType: SWFirstLoginCollectionViewCell.self)
            cell.backgroundColor = .purple
            cell.layer.cornerRadius = cell.frame.width / 2
            return cell
        })

        let tableList = BehaviorSubject(value: [
            SectionModel(model: SearchPage.searchHistory, items: [SWSearchHistoryModel(tagList: viewModel.dataList),SWSearchHistoryModel(tagList: viewModel.dataList),SWSearchHistoryModel(tagList: viewModel.dataList),SWSearchHistoryModel(tagList: viewModel.dataList),SWSearchHistoryModel(tagList: viewModel.dataList),SWSearchHistoryModel(tagList: viewModel.dataList),SWSearchHistoryModel(tagList: viewModel.dataList),SWSearchHistoryModel(tagList: viewModel.dataList),SWSearchHistoryModel(tagList: viewModel.dataList)]),
        ])
        tableList.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    func getItemRadius(max: UInt32, min: UInt32) -> UInt32 {
        return arc4random_uniform(max - min) + min
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

extension SWFirstLoginViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(getItemRadius(max: 180, min: 50))
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
}
