//
//  SQLite.swift
//  MoreSQL
//
//  Created by zhi zhou on 2017/1/17.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit
import FMDB

/**
 * 将传入的不包含"非自定义类型"的数组或字典, JSON化, 并存储于 "SQL数据库" 中, 方便存取.
 */

class SQLite: NSObject {
    // MARK:- 属性
    static let shared = SQLite()
    
    /// 是否开启打印
    var isPrint = true
    
    /// 表名称
    fileprivate var tableName: String?
    
    /// 路径
    fileprivate var dbPath: String?
    
    /// 数据库
    fileprivate var db: FMDatabase?
    
    // MARK:- 方法
    // MARK: >>> 开启数据库
    /// 开启数据库
    /// - parameter pathName: 数据库存放路径
    /// - parameter tableName: 表名
    func openDB(pathName: String? = nil, tableName: String) -> Bool {
        if let pathName = pathName {
            return open(pathName, tableName)
        } else {
            return open("data", tableName)
        }
    }
    
    // 封装开启方法
    fileprivate func open(_ pathName: String, _ tableName: String) -> Bool {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path = path + "/" + pathName + ".sqlite"
        dbPath = path
        
        db = FMDatabase(path: path)
        if (db?.open())! {
            self.tableName = tableName
            _ = createTable()
            remind("数据库开启成功")
            return true
        } else {
            remind("数据库开启失败")
            return false
        }
    }
    
    // MARK: >>> 创建表
    /// 创建表
    func createTable() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS \(tableName!) (id INTEGER PRIMARY KEY AUTOINCREMENT,js BLOB);"
        
        if (db?.executeUpdate(sql, withArgumentsIn: nil))! {
            remind("创建表成功")
            return true
        } else {
            remind("创建表失败")
            return false
        }
    }
    
    // MARK: >>> 插入数据
    /// 插入数据
    /// - parameter objc: 传入非自定义类型
    func insert(objc: Any) -> Bool {
        let sql = "INSERT INTO \(tableName!) (js) VALUES (?);"
        let js = toJson(objc: objc)
        
        if (db?.executeUpdate(sql, withArgumentsIn: [js!]))! {
            remind("插入数据成功")
            return true
        } else {
            remind("插入数据失败")
            return false
        }
    }
    
    // MARK: >>> 查询数据
    /// 查询数据
    func query() -> [Any]? {
        let sql = "SELECT * FROM \(tableName!);"
        let set = db?.executeQuery(sql, withArgumentsIn: nil)
        
        guard set != nil else {
            return nil
        }
        
        var tempArray = [Any]()
        while set!.next() {
            let result = set?.object(forColumnName: "js")
            if let result = result {
                let objc = jsonToAny(json: result as! String)
                if let objc = objc {
                    tempArray.append(objc)
                }
            }
        }
        
        return tempArray
    }
    
    // MARK: >>> 删除数据 (全部)
    /// 删除 (全部) 数据
    func delete() -> Bool {
        // 删除所有 或 where ..... 来进行判断筛选删除
        let sql = "DELETE FROM \(tableName!);"
        
        if (db?.executeUpdate(sql, withArgumentsIn: nil))! {
            remind("删除成功")
            return true
        } else {
            remind("删除失败")
            return false
        }
    }
    
    // MARK: >>> 更新数据
    /// 更新数据
    /// - parameter newValue: 传入非自定义类型
    func update(newValue: Any) -> Bool {
        let js = toJson(objc: newValue)
        
        let sql = "UPDATE \(tableName!) SET js = '\(js!)';"
        
        if (db?.executeUpdate(sql, withArgumentsIn: nil))! {
            remind("修改成功")
            return true
        } else {
            remind("修改失败")
            return false
        }
    }
    
}

// MARK:- JSON、ANY 转换
extension SQLite {
    /// **Any** 转换为 **JSON** 类型
    /// - parameter objc: 传入非自定义类型
    func toJson(objc: Any) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: objc, options: .prettyPrinted)
        if let data = data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    /// **JSON** 转换为 **Any** 类型
    /// - parameter json: String 类型数据
    func jsonToAny(json: String) -> Any? {
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

// MARK:- 自定义 print 打印
extension SQLite {
    /// 根据 **isPrint** 的值来决定是否打印
    /// - parameter message: 打印信息
    fileprivate func remind(_ message: String) {
        if isPrint {
            printDBug(message, isDetail: false)
        }
    }
    
    /// 仅在 Debug 模式下打印
    /// - parameter info: 打印信息
    /// - parameter fileName: 打印所在的swift文件
    /// - parameter methodName: 打印所在文件的类名
    /// - parameter lineNumber: 打印事件发生在哪一行
    /// - parameter isDetail: 是否打印详细信息 (默认: true)
    func printDBug<T>(_ info: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line, isDetail: Bool = true) {
        let file = (fileName as NSString).pathComponents.last!
        #if DEBUG
            if isDetail {
                print("\(file) -> \(methodName) [line \(lineNumber)]: \(info)")
            } else {
                print(info)
            }
        #endif
    }
    
}
