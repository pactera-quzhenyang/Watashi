//
//  FirstViewModel.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/21.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstViewModel: BaseViewModelType {
    struct Input {
       let name: Observable<String>
       let validate: Observable<Void>
     }

     struct Output {
       let greeting: Driver<String>
     }

     func transform(input: Input) -> Output {
       let greeting = input.validate
         .withLatestFrom(input.name)
         .map { name in
           return "Hello \(name)!"
         }
         .startWith("")
         .asDriver(onErrorJustReturn: ":-(")

       return Output(greeting: greeting)
     }
}
