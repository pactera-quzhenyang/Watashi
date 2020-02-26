//
//  AccountViewController.swift
//  Watashi+
//
//  Created by 曲振阳 on 2020/2/24.
//  Copyright © 2020 曲振阳. All rights reserved.
//

import UIKit

class SWAccountViewController: UIViewController {

    let a = UITableViewDelegateDataSource_A()
    let b = UITableViewDelegateDataSource_B()
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.view.addSubview(tableView)
        let dataSource = SWABTestProtocolDispatcher.dispatcherProtocol(UITableViewDataSource.self, withIndexImplemertor: 1, toImplemertors: [a, b])
        tableView.dataSource = dataSource as? UITableViewDelegateDataSource_A
        tableView.dataSource = dataSource as? UITableViewDelegateDataSource_B
//        tableView.delegate = SWABTestProtocolDispatcher.dispatcherProtocol(UITableViewDelegate.self, withIndexImplemertor: 1, toImplemertors: [a, b]) as? UITableViewDelegate
       
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

class UITableViewDelegateDataSource_A: NSObject, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "a----\(indexPath.row)"
        return cell!
    }

}


class UITableViewDelegateDataSource_B: NSObject, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "b----\(indexPath.row)"
        return cell!
    }

}
