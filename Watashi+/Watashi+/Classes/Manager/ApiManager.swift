//
//  ApiManager.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/18.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import Moya_ObjectMapper
import Moya
class ApiManager: NSObject {
    
}

class TestAPI {
//    class func loadChannels() -> Driver<Douban> {
//        return APIProvider.rx.request(.other)
//            .mapObject(Douban.self)
//            .asDriver(onErrorDriveWith: Driver.empty())
//    }
    
    class func loadChannels() -> Observable<Douban> {
        return APIProvider.rx.request(.other)
            .mapObject(Douban.self)
            .asObservable()
            .showAPIErrorToast()
    }
    
}

struct Douban: Mappable {
    var channels: [Channel]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        channels <- map["channels"]
    }
}

struct Channel: Mappable {
    var name: String?
    var nameEn:String?
    var channelId: String?
    var seqId: Int?
    var abbrEn: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seq_id"]
        abbrEn <- map["abbr_en"]
    }
}

extension Driver {
//    func requestErr() -> Driver<Element> {
//        self.do(onNext: <#T##((Element) -> Void)?##((Element) -> Void)?##(Element) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onSubscribe: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onSubscribed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDispose: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//    }
}

extension Observable {
    func showAPIErrorToast() -> Observable<Element> {
        return self.do(onNext: nil, onError: { (error) in
            print(error)
            })
    }
}
