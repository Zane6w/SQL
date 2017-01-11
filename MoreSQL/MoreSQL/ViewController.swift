//
//  ViewController.swift
//  MoreSQL
//
//  Created by zhi zhou on 2017/1/10.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var results = [[String: Any]]()
    var dict = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dict["first"] = "第一个 111"
        dict["second"] = "第二个 222"
        
        results.append(dict)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func insertData(_ sender: UIButton) {
        SQLManager.shared.insert(results: results)
    }
    
    @IBAction func readData(_ sender: UIButton) {
        let array = SQLManager.shared.loadData()
        for dict in array! {
            print(dict)
        }
        
    }
    

   //[["second": "第二个 222", "first": "第一个 111"]]
    //[ ["results": "[[\"second\": \"第二个 222\", \"first\": \"第一个 111\"]]"] ]
    
}

