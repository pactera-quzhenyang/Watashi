//
//  HomeViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/18.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

    let disposeBag = DisposeBag()
    


    @IBOutlet weak var searchField: HomeSearchField!

    @IBOutlet weak var titleView: PageTitleView!
    @IBOutlet weak var contentView: PageContentView!
    var selectIndex: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setPageViewCon()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setPageViewCon() {

        let style = PageStyle()
        style.titleViewBackgroundColor = UIColor.white
        style.titleFont = UIFont.systemFont(ofSize: 15)
        style.titleColor = .gray
        style.titleSelectedColor = .black
        style.bottomLineColor = .black
        style.isShowBottomLine = true

        let titles = [pageTitles.checkNewProducts,pageTitles.trend,pageTitles.seasonRecommend]
        var txtWidth: CGFloat = 0.0
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40)
        let attList = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        for text in titles {
            let textWidth = text.boundingRect(with: size, options: options, attributes: attList, context: nil).width
            if textWidth > txtWidth {
                txtWidth = textWidth
            }
        }
        style.bottomLineWidth = txtWidth

        let fController = FirstViewController.instantiate()
        let sController = SecondViewController.instantiate()
        let tController = ThirdViewController.instantiate()
        let controllers = [fController, sController, tController]


        let childViewControllers: [UIViewController] = controllers.map { child -> UIViewController in
            addChild(child)
            return child
        }

        contentView.childViewControllers = Observable<[UIViewController]>.just(childViewControllers)

        titleView.titles = titles
        titleView.style = style
        titleView.currentIndex = selectIndex

        contentView.currentIndex = selectIndex
        contentView.style = style

        contentView.titleView = titleView
        contentView.setupUI()

        titleView.pageContentView = contentView
        titleView.setupUI()

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
