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
        dict["name"] = "姓名"
        dict["age"] = 23
        
        results.append(dict)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func insertData(_ sender: UIButton) {
        let js = convertToJson(objc: results)
        
        if let js = js {
            SQLite.shared.insert(js: js)
        }
        
    }
    
    @IBAction func readData(_ sender: UIButton) {
        let array = SQLite.shared.query()
        
        if let array = array {
            for js in array {
                let json = js as! String
                let objc = jsonConvertToAny(json: json)
                print(objc)
            }
        }
        
    }
    
}

extension ViewController {
    /// 转换为 JSON
    func convertToJson(objc: Any) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: objc, options: .prettyPrinted)
        if let data = data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    /// JSON 转 Any
    func jsonConvertToAny(json: String) -> Any? {
        let data = json.data(using: .utf8)
        if let data = data {
            let anyObjc = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let anyObjc = anyObjc {
                return anyObjc
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}








