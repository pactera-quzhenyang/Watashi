//
//  API.swift
//  zst
//
//  Created by 曲振阳 on 2020/2/12.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import SwiftyJSON


let plugin = APIPlugin()
let APIProvider = MoyaProvider<APIS>(plugins: [plugin])

enum APIS {
    case login(String)
    case other
}

extension APIS: TargetType {
    var baseURL: URL {
        #if DEBUG
//        return URL(string: "https://www.baidu.com/")!
        return URL(string: "https://www.douban.com")!
        #endif
    }

    var path: String {
        switch self {
        case .login:
            return "sw/api/auth/V1/SWFR120070.seam"
        case .other:
            return "/j/app/radio/channels"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        switch self {
        case .login(let hntbc_kaiin_id):
            return .requestParameters(parameters: ["hntbc_kaiin_id": hntbc_kaiin_id], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return [
            "Accept": "application/json",
            "Accept-Encoding": "gzip",
            "Content-Type": "application/json"
        ]
    }

}



public final class APIPlugin: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        print("willSend")
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
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

