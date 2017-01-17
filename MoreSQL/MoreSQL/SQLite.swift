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
    func openDB() -> Bool {
        db = FMDatabase(path: dbPath!)
        if (db?.open())! {
            // 数据库开启成功
            _ = createTable()
            return true
        } else {
            // 数据库开启失败
            return false
        }
    }
    
    /// 创建表
    func createTable() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS t_models (id INTEGER PRIMARY KEY AUTOINCREMENT,js BLOB);"
        
        if (db?.executeUpdate(sql, withArgumentsIn: nil))! {
            printDBug("创建表成功")
            return true
        } else {
            printDBug("创建表失败")
            return false
        }
    }
    
    /// 插入
    func insert(js: String) -> Bool {
        let sql = "INSERT INTO t_models (js) VALUES (?);"
        
        if (db?.executeUpdate(sql, withArgumentsIn: [js]))! {
            printDBug("插入数据成功")
            return true
        } else {
            printDBug("插入数据失败")
            return false
        }
    }
    
    /// 查询
    func query() -> [Any]? {
        let sql = "SELECT * FROM t_models;"
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
    
    /// 删除
    func delete() -> Bool {
        // 删除所有 或 where ..... 来进行判断筛选删除
        let sql = "DELETE FROM t_models;"
        
        if (db?.executeUpdate(sql, withArgumentsIn: nil))! {
            printDBug("删除成功")
            return true
        } else {
            printDBug("删除失败")
            return false
        }
    }
    
    /// 修改
    func alter(newValue: Any) -> Bool {
        let sql = "UPDATE t_models set js = \(newValue);"
        
        if (db?.executeUpdate(sql, withArgumentsIn: nil))! {
            printDBug("修改成功")
            return true
        } else {
            printDBug("修改失败")
            return false
        }
    }
    
}

// MARK:- JSON、ANY 转换
extension SQLite {
    /// "Any"转换为"JSON"类型
    func convertToJson(objc: Any) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: objc, options: .prettyPrinted)
        if let data = data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    /// "JSON"转换为"Any"类型
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

// MARK:- 自定义 print 打印 (公共方法)
/// 高级打印方法
func printDBug<T>(_ info: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    let file = (fileName as NSString).pathComponents.last!
    #if DEBUG
        print("\(file) -> \(methodName) [line \(lineNumber)]: \(info)")
    #endif
}
