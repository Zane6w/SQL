//
//  ViewController.swift
//  MoreSQL
//
//  Created by zhi zhou on 2017/1/10.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK:- 属性
    var results = [[String: Any]]()
    var dict = [String: Any]()
    
    // MARK:- 函数方法
    override func viewDidLoad() {
        super.viewDidLoad()
        dict["name"] = "姓名"
        dict["age"] = 24
        
        results.append(dict)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK:- 数据操作
extension ViewController {
    // 插入数据
    @IBAction func insertData(_ sender: UIButton) {
        let js = convertToJson(objc: results)
        
        if let js = js {
            _ = SQLite.shared.insert(js: js)
        }
    }
    
    // 读取数据
    @IBAction func readData(_ sender: UIButton) {
        let array = SQLite.shared.query()
        
        if let array = array {
            for js in array {
                let json = js as! String
                let objc = jsonConvertToAny(json: json)
                
                if let objc = objc {
                    printDBug(objc)
                }
            }
        }
    }
    
    // 更新数据
    @IBAction func updateData(_ sender: UIButton) {
        let js = convertToJson(objc: results)
        _ = SQLite.shared.update(newValue: js!)
    }
    
    // 删除数据 (删除全部)
    @IBAction func deleteData(_ sender: UIButton) {
        _ = SQLite.shared.delete()
    }
    
}

// MARK:- 数据转换
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








