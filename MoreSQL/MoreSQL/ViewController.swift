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
        dict["name"] = "姓名ZZ"
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
        _ = SQLite.shared.insert(objc: results)
    }
    
    // 读取数据
    @IBAction func readData(_ sender: UIButton) {
        let array = SQLite.shared.query()
        
        // 遍历取出的数组中的 数组字典中的 字典, 并取出字典中的姓名
        if let array = array {
            for objc in array {
                let arr = objc as! [Any]
                let dict = arr.first as! [String: Any]
                print(dict["name"]!)
            }
        }
    }
    
    // 更新数据
    @IBAction func updateData(_ sender: UIButton) {
        _ = SQLite.shared.update(newValue: results)
    }
    
    // 删除数据 (删除全部)
    @IBAction func deleteData(_ sender: UIButton) {
        _ = SQLite.shared.delete()
    }
    
}
