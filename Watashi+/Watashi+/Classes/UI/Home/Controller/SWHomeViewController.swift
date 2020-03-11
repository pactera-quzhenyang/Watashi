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

class SWHomeViewController: SWBaseViewController {

    @IBOutlet weak var searchField: SWHomeSearchField!

    @IBOutlet weak var titleView: PageTitleView!
    @IBOutlet weak var contentView: PageContentView!
    var selectIndex: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setPageViewCon()
        firstLoginView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setPageViewCon() {
        searchField.delegate = self

        let style = PageStyle()
        style.titleViewBackgroundColor = UIColor.white
        style.titleFont = UIFont.systemFont(ofSize: 15)
        style.titleColor = .gray
        style.titleSelectedColor = .mainColor
        style.bottomLineColor = .mainColor
        style.isShowBottomLine = true

        let titles = [PageTitles.checkNewProducts,PageTitles.trend,PageTitles.seasonRecommend]
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

        let fController = SWCheckNewProductsViewController.instantiate()
        let sController = SWTrendViewController.instantiate()
        let tController = SWSeasonRecommendViewController.instantiate()
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

    func firstLoginView() {
        let delegate = UIApplication.shared.delegate as! SWAppDelegate
        delegate.window?.addSubview(SWFirstLoginViewController.instantiate().view)
    }

    func s() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 100, y: 500))
        path.addLine(to: CGPoint(x: 100, y: 400))

        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.strokeColor = UIColor.black.cgColor
        shape.path = path.cgPath
        view.layer.addSublayer(shape)

        let ani = CABasicAnimation(keyPath: "strokeEnd")
        ani.duration = 0.2
        ani.fromValue = 0
        ani.toValue = 1
        ani.timingFunction = .init(name: .easeIn)
        ani.isRemovedOnCompletion = false
        ani.fillMode = .forwards
//        ani.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)

        let ani1 = CABasicAnimation(keyPath: "strokeStart")
        ani1.duration = 0.4
        ani1.fromValue = 0
        ani1.toValue = 1
        ani1.isRemovedOnCompletion = false
        ani1.fillMode = .forwards
//        ani1.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        ani.timingFunction = .init(name: .easeIn)
        ani1.beginTime = 0.2
        let group = CAAnimationGroup()
        group.animations = [ani,ani1]
        group.duration = 0.6
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        shape.add(group, forKey: nil)
    }
}

extension SWHomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        baseNavigationController?.pushViewController(SWSearchViewController.instantiate(), animated: false)
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
