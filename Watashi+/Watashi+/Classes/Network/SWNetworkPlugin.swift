//
//  SWNetworkPlugin.swift
//  Watashi+
//
//  Created by NULL on 2020/3/2.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import Foundation
import Moya
import Result

class SWNetworkPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        
        let api = target as! SWAPIS
        if api.isShowHUD {
            
        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
       print("didReceive")
       switch result {
       case .success(let response):
           let json = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
           print(json as Any)
       case .failure(let error):
           print(error.errorDescription as Any)
       }
    }
}
