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
import Reusable

class SWFirstLoginViewController: SWBaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = UIStoryboard(name: "Home", bundle: nil)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    let disposeBag = DisposeBag()
    let viewModel = SWFirstLoginViewModel()

    var tableList = BehaviorSubject(value: [SectionModel<String, SWFirstLoginViewModel>]())

    var selectList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        bindViewModel()
    }

    func setupUI() {
        navigationItem.title = NavigationTitle.firstLogin

        let layout = SWFirstLoginFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.register(cellType: SWFirstLoginCollectionViewCell.self)
    }

    func bindViewModel() {

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,SWFirstLoginViewModel>>(configureCell: { (dataSouece, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(for: indexPath, cellType: SWFirstLoginCollectionViewCell.self)
            cell.titleLabel.text = element.titleString
            return cell
        })

        tableList = BehaviorSubject(value: [
            SectionModel(model: "", items: [SWFirstLoginViewModel(title: "ナチュラル"),SWFirstLoginViewModel(title: "マキアージュ"),SWFirstLoginViewModel(title: "モードスタイル"),SWFirstLoginViewModel(title: "ベタつき"),SWFirstLoginViewModel(title: "マキアージュ"),SWFirstLoginViewModel(title: "にびき"),SWFirstLoginViewModel(title: "乾燥肌"),SWFirstLoginViewModel(title: "プログラム"),SWFirstLoginViewModel(title: "インテグレート")]),
        ])
        tableList.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            let cell: SWFirstLoginCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! SWFirstLoginCollectionViewCell
            cell.contentView.backgroundColor = .mainLightGray
            if !self.selectList.contains(cell.titleLabel.text!) {
                self.selectList.append(cell.titleLabel.text!)
            } else {
                self.selectList.removeAll(where: {$0 == cell.titleLabel.text!})
                cell.contentView.backgroundColor = .white
            }
        }).disposed(by: disposeBag)

        resetButton.rx.tap.subscribe(onNext: { () in
            self.selectList.removeAll()
            for cell in self.collectionView.visibleCells {
                cell.contentView.backgroundColor = .white
            }
            }).disposed(by: disposeBag)
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
        let model = try? tableList.value()[indexPath.section]
        let viewModel = model?.items[indexPath.item]
        let width = viewModel?.titleString.size(UIFont.systemFont(ofSize: 14), size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        return CGSize(width: width! + 31, height: width! + 31)
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
