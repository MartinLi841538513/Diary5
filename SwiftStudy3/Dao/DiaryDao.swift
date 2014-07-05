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
    let filePath:String = NSBundle.mainBundle().pathForResource("DiaryList", ofType:"plist")
    var db:COpaquePointer = nil

    let tableName:String = "diary"
    //新增一篇日记
    func addDiary(diary:Diary){
        if self.openSqlite() == true{
            var sql:String = "insert into '%@' (date,weather,mood,latitude,longitude,photos,voicePath,content) values ('%@','%@','%@','%@','%@','%@','%@','%@'),"+self.tableName+","+diary.date+","+diary.weather+","+diary.mood+","+diary.latitude+","+diary.longitude+","+diary.photos+","+diary.voicePath+","+diary.content
            self.execSql(sql)
        }
    }
    
    func deleteDiary(diary:Diary){
        if self.openSqlite() == true{
            var sql:String = "insert into '%@' (date,weather,mood,l8415atitude,longitude,photos,voicePath,content) values ('%@','%@','%@','%@','%@','%@','%@','%@'),"+self.tableName+","+diary.date+","+diary.weather+","+diary.mood+","+diary.latitude+","+diary.longitude+","+diary.photos+","+diary.voicePath+","+diary.content
            self.execSql(sql)
        }
    }

    
    //得到所有的日记
    func allDiaries() ->NSMutableArray{
        var diaryList:NSMutableArray = NSMutableArray()
        if self.openSqlite() == true{
            let sql:NSString = "select * from "+self.tableName
            var statement:COpaquePointer = nil
            if sqlite3_prepare_v2(self.db,sql.UTF8String,-1,&statement,nil) == SQLITE_OK{
                while sqlite3_step(statement) == SQLITE_ROW{
                    var diary:Diary = Diary()
                    var column_count = sqlite3_column_count(statement)
                    while column_count>0 {
                        var text:UnsafePointer<CUnsignedChar> = sqlite3_column_text(statement,column_count-1)
                        var value = String.fromCString(CString(text))
                        
                        if column_count==1{
                            diary.id = value
                        }else if column_count == 2{
                            diary.date = value
                        }else if column_count == 3{
                            diary.weather = value
                        }else if column_count == 4{
                            diary.mood = value
                        }else if column_count == 5{
                            diary.latitude = value
                        }else if column_count == 6{
                            diary.longitude = value
                        }else if column_count == 7{
                            diary.photos = value
                        }else if column_count == 8{
                            diary.voicePath = value
                        }else if column_count == 9{
                            diary.content = value
                        }

                        column_count = column_count-1
                    }
                    println(diary.weather)
                    diaryList.addObject(diary)
                }
            }else{
                println("查询准备失败")
            }

        }
        
        return diaryList
    }
    
    /*
        打开数据库
    */
    func openSqlite() ->Bool{
        let storeFilePath:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory:String = storeFilePath.objectAtIndex(0) as String
        var path:String = doucumentsDirectiory.stringByAppendingPathComponent(DBNAME)
        var file:NSFileManager = NSFileManager.defaultManager()
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
    
    func execSql(sql:String){
        var err:COpaquePointer = nil
        if sqlite3_exec(self.db,(sql as NSString).UTF8String,NULL,NULL,&err){
            sqlite3_close(self.db)
            println("sql语句执行失败")
        }
        
    }

}