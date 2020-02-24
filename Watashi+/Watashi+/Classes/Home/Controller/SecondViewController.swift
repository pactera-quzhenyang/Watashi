//
//  SecondViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/19.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class SecondViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = UIStoryboard(name: "Home", bundle: nil)

    private let viewModel = FirstViewModel()
    let bag = DisposeBag()

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
    }

    private func bindViewModel() {
        textField.rx.text.bind(to: button.rx.title()).disposed(by: bag)
        let inputs = FirstViewModel.Input(name: textField.rx.text.orEmpty.asObservable(),
                                           validate: button.rx.tap.asObservable())
        let outputs = viewModel.transform(input: inputs)
        outputs.greeting
        .drive(button.rx.title())
        .disposed(by: bag)


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
