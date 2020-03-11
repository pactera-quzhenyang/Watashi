//
//  BaseViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/18.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import Reusable
import Firebase
class SWBaseViewController: UIViewController, SWGAProtocol {
    
    var titleText: String = ""

    var baseNavigationController: SWBaseNavigationController? {
        return self.navigationController as? SWBaseNavigationController
    }

    let backButtonWidth = 44

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        Analytics.logEvent("mainPageLoaded", parameters: nil)
        
        print("\(self.classForCoder) viewDidLoad")

        initNavigationStyle()
    }

    //MARK Common Navigationbar Style
    func initNavigationStyle() {
        if ((self.navigationController?.viewControllers.count) ?? 0 > 1) {
            let backButton = UIButton.init()
            backButton.frame = CGRect(x: 0, y: 0, width: backButtonWidth, height: backButtonWidth)
            backButton.setImage(UIImage(named: "back"), for: UIControl.State.normal)
            let backItem = UIBarButtonItem.init(customView: backButton)
            self.navigationItem.leftBarButtonItems = [backItem]
        }
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

extension SWBaseViewController {
    
//    func logEvent(list: [String], titleText: String? = nil) {
//        let title = titleText ?? self.titleText
//        for item in list {
//            let eventBody = [GAKey.custom_event_category: title,
//                             GAKey.custom_event_action: item]
//            SWFirebaseManager.GA.event(eventBody).track()
//        }
//    }
//
//    func logEvent(action: String, label: String, titleText: String? = nil) {
//        let title = titleText ?? self.titleText
//        let eventBody = [GAKey.custom_event_category: title,
//                         GAKey.custom_event_action: action,
//                         GAKey.custom_event_label: label]
//        SWFirebaseManager.GA.event(eventBody).track()
//    }
}
