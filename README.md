# SQL
存取字典或数组类型数据 Demo

**SQLite** 工具类提供将**"不包含自定义类型"的数组或字典JSON化**, 便于存取. 

(需要依赖于 **FMDB** 框架. Github: https://github.com/ccgus/fmdb)

> 属性
```swift
shared: 单例
isPrint :是否打印调试信息
```

> 有 Bool 返回值可以判断是否成功
> 打开数据库并创建表（传入存储路径和表名）
```swift
func openDB(pathName: String? = nil, tableName: String) -> Bool
```
> 插入数据（数组或字典中不能有自定义类型或模型）
```swift
func insert(objc: Any) -> Bool
```
> 查询数据
```swift
func query() -> [Any]?
```
> 删除数据(全部删除)
```swift
func delete() -> Bool
```
> 更新数据（同样数组或字典中不能有自定义类型或模型）
```swift
func update(newValue: Any) -> Bool
```
