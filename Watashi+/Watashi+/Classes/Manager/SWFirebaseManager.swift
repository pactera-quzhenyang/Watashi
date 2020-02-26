//
//  SWFirebaseManager.swift
//  Watashi+
//
//  Created by NULL on 2020/2/26.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import FirebaseCore

class SWFirebaseManager {
    class func configure() {
        #if DEV
        let resourceName = "GoogleService-dev-Info"
        #elseif STG
        let resourceName = "GoogleService-stg-Info"
        #elseif PRODUCTION
        let resourceName = "GoogleService-pro-Info"
        #endif

        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist") else { return }
        print("Firebase configuration file path:\(filePath)")
        guard let firebaseOption = FirebaseOptions(contentsOfFile: filePath) else { return }
        
        FirebaseApp.configure(options: firebaseOption)
    }
}

extension SWFirebaseManager {
    enum GA {
        case screen([String: String])
        case event([String: String])
        case user([String: String])

        var name: String {
            switch self {
            case .screen:
                return "custom_screen_view"
            case .event:
                return "custom_event"
            case .user:
                return "custom_user"
            }
        }

        var itemBody: [String: String] {
            switch self {
            case .screen(let body):
                return !body.isEmpty ? body : ["Unknown": ""]
            case .event(let body):
                return !body.isEmpty ? body : ["Unknown": ""]
            case .user(let body):
                return !body.isEmpty ? body : ["Unknown": ""]
            }
        }

        func track() {
            guard let apps = FirebaseApp.allApps else { return }
            guard apps.count > 0 else { return }
            switch self {
            case .screen, .event:
                 Analytics.logEvent(self.name, parameters: self.itemBody)
                 DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                   print("🌛🌛🌛Analytics.logEvent(\(self.name), parameters: \(self.itemBody))🌛🌛🌛")
                 }
            case .user:
                for item in self.itemBody {
                    Analytics.setUserProperty(item.value, forName: item.key)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                       print("🌛🌛🌛Analytics.setUserProperty(\(item.value), forName: \(item.key))🌛🌛🌛")
                    }
                }
            }
        }
    }

    private func testFunc() {
        // 例  iOS_手動スクリーン
        let screenBody = [GAKey.custom_screen_name: "MFWebViewController_notice",
                          GAKey.ep_notification_title: "｛お知らせタイトル｝"]
        SWFirebaseManager.GA.screen(screenBody).track()
        // 例  iOS_手動イベント
        let eventBody = [GAKey.custom_event_category: "利用分岐",
                         GAKey.custom_event_action: "ボタン押下_はじめる"]
        SWFirebaseManager.GA.event(eventBody).track()
        // 例  iOS_ユーザープロパティ2
        let userBody = [GAKey.up_login_status: "未ログイン"]
        SWFirebaseManager.GA.user(userBody).track()

    }
}

struct GAKey {
    static let custom_screen_name = "custom_screen_name"
    static let custom_event_category = "custom_event_category"
    static let custom_event_action = "custom_event_action"
    static let custom_event_label = "custom_event_label"

    static let ep_notification_title = "ep_notification_title"
    static let ep_displayed_balance = "ep_displayed_balance"
    static let ep_displayed_details_number = "ep_displayed_details_number"

    /// user
    static let up_login_status = "up_login_status"
    static let ep_hashed_email = "ep_hashed_email"
    static let up_ac_set_status = "up_ac_set_status"
    static let up_net_ac_flg = "up_net_ac_flg"
    static let up_ac_number = "up_ac_number"
    static let up_balance_disp_status = "up_balance_disp_status"
    static let up_primary_ac_balance = "up_primary_ac_balance"
    static let up_push_set_status = "up_push_set_status"
    static let up_app_userID = "up_app_userID"
    static let up_stage_point = "up_stage_point"
    static let up__trust_ac_status = "up__trust_ac_status"
    static let up_primary_ac_details_number = "up_primary_ac_details_number"
    static let up_primary_ac_dtls_num = "up_primary_ac_dtls_num"
    static let up_easy_login_set_status = "up_easy_login_set_status"
}
