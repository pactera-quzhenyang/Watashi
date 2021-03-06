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
import RxSwift
import RxCocoa

class SWBaseViewController: UIViewController, SWGAProtocol {
    
    var titleText: String = ""

    var baseNavigationController: SWBaseNavigationController? {
        return self.navigationController as? SWBaseNavigationController
    }

    let backButtonWidth = 44

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        Analytics.logEvent("mainPageLoaded", parameters: nil)
        
        print("\(self.classForCoder) viewDidLoad")
    }
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
