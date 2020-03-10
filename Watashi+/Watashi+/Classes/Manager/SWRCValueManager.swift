//
//  SWRCValueManager.swift
//  Watashi+
//
//  Created by NULL on 2020/2/26.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import Foundation
import Firebase


class SWRCValueManager {
    static let shared = SWRCValueManager()
    var loadingDoneCallback: (() -> ())?
    var fetchComplete: Bool = false
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    func loadDefaultValues() {
        
        let appDefaults: [String: Any?] = [
            shoppingCart: SWRemoteConfigValue.shoppingCartA.rawValue
            
        ]
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
//                if let done = strongSelf.loadingDoneCallback {
//                    done()
//                }
                RemoteConfig.remoteConfig().activate(completionHandler: { (error) in
                  // ...
                    if let done = strongSelf.loadingDoneCallback {
                        done()
                    }
                    print("Error: \(error?.localizedDescription ?? "")")
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
    
    func color(forKey key: String) -> UIColor {
      let hexString = RemoteConfig.remoteConfig()[key].stringValue ?? "#FFFFFFFF"
      return UIColor(hex: hexString)!
    }
    
    func bool(forKey key: String) -> Bool {
      return RemoteConfig.remoteConfig()[key].boolValue
    }
    
    func string(forKey key: String) -> String {
      return RemoteConfig.remoteConfig()[key].stringValue ?? ""
    }
    
    func double(forKey key: String) -> Double {
      if let numberValue = RemoteConfig.remoteConfig()[key].numberValue {
        return numberValue.doubleValue
      } else {
        return 0.0
      }
    }
}
