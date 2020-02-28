//
//  SWRCValueManager.swift
//  Watashi+
//
//  Created by NULL on 2020/2/26.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import Foundation
import Firebase

enum ValueKey: String {
    case navBarBackground
}


class SWRCValueManager {
    static let shared = SWRCValueManager()
    var loadingDoneCallback: (() -> ())?
    var fetchComplete: Bool = false
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    func loadDefaultValues() {
        let appDefaults: [String: Any?] = [ValueKey.navBarBackground.rawValue: "#535E66"]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func fetchCloudValues() {
        let fetchDuration: TimeInterval = 0
        activateDebugMode()
        // 从远程配置中提取参数值
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { [weak self] (status, error) in
            guard let strongSelf = self else { return }
            if status == .success {
                print("Config fetched!")
                // 让提取的参数值可供应用使用
                strongSelf.fetchComplete = true
                RemoteConfig.remoteConfig().activate(completionHandler: { (error) in
                  // ...
                    print("Error: \(error?.localizedDescription ?? "No error available.")")
                })
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            
        }
    }
    
    func activateDebugMode() {
        RemoteConfig.remoteConfig().configSettings = RemoteConfigSettings()
    }
    
    func color(forKey key: ValueKey) -> UIColor {
      let hexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "#FFFFFFFF"
      return UIColor(hex: hexString)!
    }
    
    func bool(forKey key: ValueKey) -> Bool {
      return RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    func string(forKey key: ValueKey) -> String {
      return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    func double(forKey key: ValueKey) -> Double {
      if let numberValue = RemoteConfig.remoteConfig()[key.rawValue].numberValue {
        return numberValue.doubleValue
      } else {
        return 0.0
      }
    }
}
