//
//  SQLite.swift
//  MoreSQL
//
//  Created by zhi zhou on 2017/1/17.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit
import FMDB

class SQLite: NSObject {
    // MARK:- 属性
    static let shared = SQLite()
    
    var dbPath: String? {
        var dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        dbPath += "/data.sqlite"
        
        return dbPath
    }
    
    var db: FMDatabase?
    
    // MARK:- 方法
    /// 开启数据库
    func beginSQL() -> Bool {
        db = FMDatabase(path: dbPath!)
        if (db?.open())! {
            print("数据库开启成功")
            createTable()
            return true
        } else {
            print("数据库开启失败")
            return false
        }
    }
    
    /// 创建表
    func createTable() {
        let sql = "CREATE TABLE IF NOT EXISTS t_models (id INTEGER PRIMARY KEY AUTOINCREMENT,js BLOB);"
        
        if (db?.executeUpdate(sql, withArgumentsIn: nil))! {
            print("创建表成功")
        } else {
            print("创建表失败")
        }
    }
    
    /// 插入
    func insert(js: String) {
        let sql = "INSERT INTO t_models (js) VALUES (?);"
        
        if (db?.executeUpdate(sql, withArgumentsIn: [js]))! {
            print("插入数据成功")
        } else {
            print("插入数据失败")
        }
    }
    
    /// 查询
    func query() -> [Any]? {
        let sql = "SELECT * FROM t_models"
        let resultsSet = db?.executeQuery(sql, withArgumentsIn: nil)
        
        guard resultsSet != nil else {
            return nil
        }
        
        var arr = [Any]()
        while resultsSet!.next() {
            let result = resultsSet?.object(forColumnName: "js")
            if let result = result {
                arr.append(result)
            }
        }
        
        return arr
    }
    
}
