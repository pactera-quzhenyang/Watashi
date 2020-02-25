//
//  SearchViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/18.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWSearchViewController: SWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let narrowedModalView = SemiModalView(size:  CGSize(width: UIScreen.main.bounds.width, height: 300), baseViewController: navigationController!)
        narrowedModalView.contentView.backgroundColor = UIColor.white

        let label = UILabel.init(frame: CGRect(x: 100, y: 100, width: 100, height: 20))
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "暂无内容"
        narrowedModalView.contentView.addSubview(label)

        narrowedModalView.open()
    }

}
