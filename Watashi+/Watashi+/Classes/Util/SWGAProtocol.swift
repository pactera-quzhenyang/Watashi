//
//  SWGAProtocol.swift
//  Watashi+
//
//  Created by NULL on 2020/3/6.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import Foundation
import Firebase

protocol SWGAProtocol {
    
}

extension SWGAProtocol {
    
    func logEvent(list: [String], titleText: String? = nil) {
        let title = titleText ?? ""
        for item in list {
            let eventBody = [GAKey.custom_event_category: title,
                             GAKey.custom_event_action: item]
            SWFirebaseManager.GA.event(eventBody).track()
        }
    }

    func logEvent(action: String, label: String, titleText: String? = nil) {
        let title = titleText ?? ""
        let eventBody = [GAKey.custom_event_category: title,
                         GAKey.custom_event_action: action,
                         GAKey.custom_event_label: label]
        SWFirebaseManager.GA.event(eventBody).track()
    }
}
