//
//  DiaryService.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-19.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import Foundation

class DiaryService{
    let diaryDao:DiaryDao = DiaryDao()

    //创建数据库表
    func createTable(){
        self.diaryDao.createTable()
    }
    
    //新增一篇日记
    func addDiary(diary:Diary){
        self.diaryDao.addDiary(diary)
    }
    
    //得到所有的日记
    func allDiaries() ->NSArray{
        let diaryList:NSArray = self.diaryDao.allDiaries() as NSArray
        return diaryList
    }

    /*
        第一次运行app会执行的程序
        1，创建数据库diary.sqlite，以及数据库表diary
    */
    func loadWhenFirstRun(){
        if self.isFirstRun() == true{
            self.createTable()
        }
    }
    
    //判断是否第一次运行app
    func isFirstRun() ->Bool{
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var isFirstRunApp:AnyObject! = defaults.objectForKey("isFirstRunApp")
        if isFirstRunApp == nil || isFirstRunApp as Bool==false{
            defaults.setObject(true, forKey:"isFirstRunApp")
            defaults.synchronize()
            println("第一次运行该app")
            return true
        }else{
            defaults.setObject(false, forKey:"isFirstRunApp")
            defaults.synchronize()
            println("不是第一次运行该app")
            return false
        }
    }
    
}










