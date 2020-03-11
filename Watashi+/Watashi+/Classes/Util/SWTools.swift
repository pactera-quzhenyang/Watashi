//
//  Tools.swift
//  BTAB
//
//  Created by 曲振陽 on 2019/12/2.
//  Copyright © 2019 曲振陽. All rights reserved.
//

import UIKit

class SWTools: NSObject {
    /**
     *   ログを印刷する
     * - parameter message: output
     * - parameter methodName: メソッド名
     * - parameter lineNumber: コードの行数
     */
    class func printLog<N>(_ message: N, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
        #if DEBUG || STAGING
            let paths = fileName.components(separatedBy: "/")
            NSLog("[Watashi App] \(paths.last! as NSString) function:\(methodName) line:\(lineNumber) log: \(message) ")
        #endif
    }
}
