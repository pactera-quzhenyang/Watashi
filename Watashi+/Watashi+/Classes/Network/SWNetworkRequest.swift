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



let APIProvider = MoyaProvider<SWAPIS>(plugins: [SWNetworkPlugin()])

enum SWAPIS {
    case login(String)
    case other
}

extension SWAPIS: TargetType {
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
    
    var isShowHUD: Bool {
        return true
    }
}

