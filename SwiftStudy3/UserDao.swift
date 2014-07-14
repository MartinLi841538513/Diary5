//
//  DiaryDao.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-19.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import Foundation

class UserDao:NSObject{
    var db:COpaquePointer = nil
    
    let tableName:String = "user"
    
    //创建数据库表
    func createTable(){
        if self.openSqlite() == true{
            var sql:String = "CREATE TABLE \(self.tableName) ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'nickname' TEXT NOT NULL, 'password' TEXT NOT NULL, 'email' TEXT NOT NULL)"
            self.execute(sql)
        }
    }
    
    //新增用户
    func addUser(user:User)->(Bool,User){
        return self.addUserWithNickname(user.nickname,andEmail:user.email,andPassword:user.password)
    }
    
    //新增用户
    func addUserWithNickname(nickname:String,andEmail email:String,andPassword password:String)->(Bool,User){
        var newUser:User = User()
        var bool:Bool = false
        if self.openSqlite() == true{
            var sql:String = "insert into \(self.tableName)(nickname,password,email) values('\(nickname)','\(password)','\(email)')"
            if self.execute(sql) {
                return self.finUserWithEmail(email)
            }
        }
        return (bool,newUser)
    }
    
    
    //修改用户信息
    func updateUser(user:User){
        if self.openSqlite() == true{
            var sql:String = "update \(self.tableName) set nickname = '\(user.nickname)' , password = '\(user.password)' , email = '\(user.email)' where id = \(user.id)"
            println(sql)
            self.execute(sql)
        }
    }
    
    //根据邮箱找到用户信息
    func finUserWithEmail(email:String)->(Bool,User){
        var user:User = User()
        var bool:Bool=false
        if self.openSqlite() == true{
            var sql:NSString = "select *from \(self.tableName) where email = \(email) limit 1"
            var stmt:COpaquePointer = nil
            if sqlite3_prepare_v2(self.db,sql.UTF8String,-1,&stmt,nil) == SQLITE_OK{
                if sqlite3_step(stmt) == SQLITE_ROW{
                    user = self.transformTouser(stmt)
                }else{
                    println("查询成功，但数据库无此信息")
                }
                bool = true
            }else{
                println("查询准备失败")
            }
            sqlite3_finalize(stmt)
            sqlite3_close(self.db)
        }
        return (bool,user)
    }
    
    //根据账号密码得到用户信息
    func findUserWithEmail(email:String,andPassword password:String)->(Bool,User){
        var user:User = User()
        var bool:Bool=false
        if self.openSqlite() == true{
            var sql:NSString = "select *from \(self.tableName) where email = \(email) and password = \(password) limit 1"
            var stmt:COpaquePointer = nil
            if sqlite3_prepare_v2(self.db,sql.UTF8String,-1,&stmt,nil) == SQLITE_OK{
                if sqlite3_step(stmt) == SQLITE_ROW{
                    user = self.transformTouser(stmt)
                    bool = true
                }else{
                    println("查询成功，但数据库无此信息")
                }
            }else{
                println("查询准备失败")
            }
            sqlite3_finalize(stmt)
            sqlite3_close(self.db)
        }
        return (bool,user)
    }
    
    /*
        database是否存在该邮箱
    */
    func databaseContainsEmail(email:String)->Bool{
        var bool:Bool=false
        if self.openSqlite() == true{
            var sql:NSString = "select *from \(self.tableName) where email = \(email)"
            var stmt:COpaquePointer = nil
            println(sql)
            if sqlite3_prepare_v2(self.db,sql.UTF8String,-1,&stmt,nil) == SQLITE_OK{
                if sqlite3_step(stmt) == SQLITE_ROW && sqlite3_column_count(stmt)>0{
                    bool = true
                }else{
                    println("查询成功，但数据库无此信息")
                }
            }else{
                println("查询准备失败")
                bool = false
            }
            sqlite3_finalize(stmt)
            sqlite3_close(self.db)
        }
        return bool
    }

    
    /*
    数据库得到数据转化成日记对象
    */
    func transformTouser(statement:COpaquePointer)->User{
        var user:User = User()
        var column_count = sqlite3_column_count(statement)
        while column_count>0 {
            let value = String.fromCString(CString(sqlite3_column_text(statement,column_count-1)))
            
            switch column_count {
            case 1:
                user.id = value.toInt()
            case 2:
                user.nickname = value
            case 3:
                user.password = value
            case 4:
                user.email = value
                
            default:
                println("")
            }
            column_count = column_count-1
        }
        return user
    }
    
    /*
    打开数据库
    */
    func openSqlite() ->Bool{
        let storeFilePath:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory:String = storeFilePath.objectAtIndex(0) as String
        var path:String = doucumentsDirectiory.stringByAppendingPathComponent(DBNAME)
        var file:NSFileManager = NSFileManager.defaultManager()
        println(path)
        if (file.fileExistsAtPath(path)){
            println("\(DBNAME)找到")
        }else{
            println("\(DBNAME)没有找到,则创建一个新的\(DBNAME)")
        }
        if sqlite3_open((path as NSString).UTF8String , &db) != SQLITE_OK{
            println("\(DBNAME)打开失败");
            return false
        }else{
            println("\(DBNAME)打开成功");
            return true
        }
    }
    
    func execute(sql:String)->Bool{
        var result:CInt = 0
        var cSql:CString = sql.bridgeToObjectiveC().UTF8String
        var stmt:COpaquePointer = nil
        result = sqlite3_prepare_v2(self.db,cSql,-1,&stmt,nil)
        if result != SQLITE_OK{
            println("准备执行sql失败")
            sqlite3_finalize(stmt)
            sqlite3_close(self.db)
            return false
        }else{
            result = sqlite3_step(stmt)
            if result != SQLITE_OK && result != SQLITE_DONE{
                println("执行\(sql)失败")
                sqlite3_finalize(stmt)
                sqlite3_close(self.db)
                return false
            }else{
                println("执行\(sql)成功")
                sqlite3_finalize(stmt)
                sqlite3_close(self.db)
                return true
            }
        }
    }
    
}