//
//  SQLManager.swift
//  MoreSQL
//
//  Created by zhi zhou on 2017/1/10.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

class SQLManager: NSObject {
    static let shared = SQLManager()
    
    var db: OpaquePointer?
        
    /// 创建并打开数据库
    func openDB() -> Bool {
        var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        filePath! += "/data.sqlite"
        
        let cFilePath = (filePath?.cString(using: .utf8))!
        
        if sqlite3_open(cFilePath, &db) != SQLITE_OK {
            print("数据库开启失败")
            return false
        }
        
        return createTable()
    }
    
    /// 制表
    func createTable() -> Bool {
        let createTableSQL = "CREATE TABLE IF NOT EXISTS 't_models' ( 'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'results' BLOB);"
        return execSQL(sql: createTableSQL)
    }
    
    /// 执行
    func execSQL(sql: String) -> Bool {
        let cSql = (sql.cString(using: .utf8))!
        
        return sqlite3_exec(db, cSql, nil, nil, nil) ==  SQLITE_OK
    }
    
    func querySQL(querySQL: String) -> [[String: Any]]? {
        // 定义游标对象
        var stmt: OpaquePointer?
        
        // 将出查询语句转换为C语言字符串
        let cQuery = (querySQL.cString(using: .utf8))!
        
        // 查询准备工作
        if sqlite3_prepare_v2(db, cQuery, -1, &stmt, nil) != SQLITE_OK {
            print("没有准备好")
            return nil
        }
        
        // 准备好了
        var tempArr = [[String: Any]]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            // 获取列的个数
            let count = sqlite3_column_count(stmt)

            // 遍历
            var dict = [String: Any]()
            for i in 0..<count {
                let cKey = sqlite3_column_name(stmt, i)
                let key = String(cString: cKey!, encoding: .utf8)
                
                let cValue = sqlite3_column_blob(stmt, i)
                let countData = sqlite3_column_bytes(stmt, i)
                let data = Data(bytes: cValue!, count: Int(countData))
                
                dict[key!] = data
            }
            // 字典放入数组中
            tempArr.append(dict)
        }
        return tempArr
    }

    /// 插入数据
    func insert(results: [[String: Any]]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: results)
        // 插入 SQL
        let insertSQL = "INSERT INTO t_models (results) VALUES ('\(data)');"

        if self.execSQL(sql: insertSQL) {
            print("数据插入成功")
        } else {
            print("数据插入失败")
        }
    }
    
    /// 读取数据
    func loadData() -> [Any]? {
        let querySQL = "SELECT results FROM t_models;"
        
        let dictArr = self.querySQL(querySQL: querySQL)
        
        // 判断数组如果有值, 则遍历, 并且转成模型对象, 放入另外一个数组中
        if let temoDictArr = dictArr {
            var tempArr = [Any]()
            
            for dict in temoDictArr {
                let data = dict["results"] as! Data
                let res = NSKeyedUnarchiver.unarchiveObject(with: data)
                tempArr.append(res)
            }
            return tempArr
        }
        return nil
    }
    
}
