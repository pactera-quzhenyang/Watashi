//
//  SWBaseNavigationController.swift
//  Watashi+-dev
//
//  Created by 曲振阳 on 2020/3/11.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

public enum BarStyle: Int {
    case  search = 0
}

class SWBaseNavigationController: UINavigationController {

    var barStyle: BarStyle!

    lazy var searchFiled: SWSearchView = {
        let searchFiled = SWSearchView.loadFromNib()
        return searchFiled
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch barStyle {
        case .search:
            navigationBar.addSubview(searchFiled)
        default:
            break
        }
        
    }

    func hideNaviLine() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
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
