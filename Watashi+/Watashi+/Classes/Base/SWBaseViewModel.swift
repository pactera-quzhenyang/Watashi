//
//  BaseViewModel.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/21.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

protocol SWBaseViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
