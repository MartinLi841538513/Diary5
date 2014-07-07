//
//  DiaryDao.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-19.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import Foundation
let DBNAME = "diary.sqlite"

class DiaryDao{
    var db:COpaquePointer = nil

    let tableName:String = "diary"
    
    //创建数据库表
    func createTable(){
        if self.openSqlite() == true{
            var sql:String = "CREATE TABLE \(self.tableName) ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'date' TEXT NOT NULL, 'weather' TEXT NOT NULL, 'mood' TEXT NOT NULL, 'latitude' TEXT NOT NULL, 'longitude' TEXT NOT NULL, 'photos' TEXT NOT NULL, 'voicePath' TEXT NOT NULL, 'content' TEXT NOT NULL)"
            self.execute(sql)
        }
    }
    
    //新增一篇日记
    func addDiary(diary:Diary){
        if self.openSqlite() == true{
            var sql:String = "insert into diary(date,weather,mood,latitude,longitude,photos,voicePath,content) values('\(diary.date)','\(diary.weather)','\(diary.mood)','\(diary.latitude)','\(diary.longitude)','\(diary.photos)','\(diary.voicePath)','\(diary.content)')"
            self.execute(sql)
        }
    }
    
    //修改一篇日记
    func updateDiary(diary:Diary){
        if self.openSqlite() == true{
            var sql:String = "update diary set date = '\(diary.date)' , weather = '\(diary.weather)' , mood = '\(diary.mood)' , latitude = '\(diary.latitude)' , longitude = '\(diary.longitude)' , photos = '\(diary.photos)' , voicePath = '\(diary.voicePath)' , content = '\(diary.content)' where id = \(diary.id)"
            println(sql)
            self.execute(sql)
        }
    }
    //删除一篇日记
    func deleteDiary(diary:Diary){
        if self.openSqlite() == true{
            var sql:String = "delete from \(self.tableName) where id = \(diary.id)"
            self.execute(sql)
        }
    }

    //得到刚刚创建的日记（也就是最新的日记，也就是最后一篇日记）
    func theLatestDiary()->Diary{
        var diary:Diary = Diary()
        
        if self.openSqlite() == true{
            let sql:NSString = "select *from diary order by id desc limit 1"
            var statement:COpaquePointer = nil
            if sqlite3_prepare_v2(self.db,sql.UTF8String,-1,&statement,nil) == SQLITE_OK{
                while sqlite3_step(statement) == SQLITE_ROW{
                    diary = transformToDiary(statement)
                }
            }else{
                println("查询准备失败")
            }
        }
        
        return diary
    }
    
    //得到所有的日记
    func allDiaries() ->NSMutableArray{
        var diaryList:NSMutableArray = NSMutableArray()
        
        if self.openSqlite() == true{
            let sql:NSString = "select * from "+self.tableName
            var statement:COpaquePointer = nil
            if sqlite3_prepare_v2(self.db,sql.UTF8String,-1,&statement,nil) == SQLITE_OK{
                while sqlite3_step(statement) == SQLITE_ROW{
                    var diary = self.transformToDiary(statement)
                    diaryList.addObject(diary)
                }
            }else{
                println("查询准备失败")
            }
        }
        
        return diaryList
    }
    
    /*
        数据库得到数据转化成日记对象
    */
    func transformToDiary(statement:COpaquePointer)->Diary{
        var diary:Diary = Diary()
        var column_count = sqlite3_column_count(statement)
        while column_count>0 {
            let value = String.fromCString(CString(sqlite3_column_text(statement,column_count-1)))
            
            switch column_count {
            case 1:
                diary.id = value.toInt()
            case 2:
                diary.date = value
            case 3:
                diary.weather = value
            case 4:
                diary.mood = value
            case 5:
                diary.latitude = value
            case 6:
                diary.longitude = value
            case 7:
                diary.photos = value
            case 8:
                diary.voicePath = value
            case 9:
                diary.content = value
            default:
                println("")
            }
            column_count = column_count-1
        }
        return diary
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
            return false
        }else{
            println("准备执行sql成功")
            result = sqlite3_step(stmt)
            if result != SQLITE_OK && result != SQLITE_DONE{
                println("执行sql失败")
                return false
            }else{
                println("执行sql成功")
                return true
            }
        }
    }

}