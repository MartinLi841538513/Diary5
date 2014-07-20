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
    func addDiary(diary:Diary)->(Bool,Diary){
        return self.diaryDao.addDiary(diary)
    }
    //修改一篇日记
    func updateDiary(diary:Diary)->(Bool,Diary){
        return self.diaryDao.updateDiary(diary)
    }

    //得到所有的日记
    func allDiariesWithUserId(userId:Int) ->(Bool , NSMutableArray){
        return self.diaryDao.allDiariesWithUserId(userId)
    }
    //在日记列表中删除一篇日记
    func deleteDiary(diary:Diary)->Bool{
        var result:Bool = self.diaryDao.deleteDiary(diary)
        if result == false{
            LIProgressHUD.showErrorWithStatus("删除失败")
        }
        return result
    }
    //在详情页面中删除一篇日记
    func deleteDiary(diary:Diary,inViewController viewController:DiaryModefyViewController)->Bool{
        var result:Bool = self.diaryDao.deleteDiary(diary)
        if result == true{
            LIProgressHUD.showSuccessWithStatus("删除成功")
            viewController.navigationController.popViewControllerAnimated(true)
        }else{
            LIProgressHUD.showErrorWithStatus("删除失败")
        }
        return result
    }

    /*
        第一次运行app会执行的程序
        1，创建数据库diary.sqlite，以及数据库表diary
    */
    func loadWhenFirstRun(){
        if self.isFirstRun() == true{
            
            let userDao:UserDao = UserDao()
            userDao.createTable()
            userDao.addUserWithNickname("1",andEmail:"1",andPassword:"1")
            self.createTable()
        }
    }
    
    //判断是否第一次运行app
    func isFirstRun() ->Bool{
        var userDefaults:UserDefault = UserDefault()
        var isFirstRunApp:Bool! = userDefaults.isFirstRunApp()
        if isFirstRunApp == nil || isFirstRunApp == true{
            userDefaults.setIsFirstRunApp(false)
            println("第一次运行该app")
            return true
        }else{
            userDefaults.setIsFirstRunApp(false)
            println("不是第一次运行该app")
            return false
        }
    }
    
    /*
        把表情翻译成文字
    */
    func translateExpressWithImageName(imageName:String)->String{
        var faceImgsPath:String = NSBundle.mainBundle().pathForResource("expression",ofType:"plist")
        var data:NSMutableDictionary = NSMutableDictionary(contentsOfFile:faceImgsPath)
        var keys:NSArray = data.allKeysForObject("\(imageName)@2x.png")
        var key:String = keys.objectAtIndex(0) as String
        return key
    }
    
    /*
        把文字翻译成表情
    */
    func translateExpressWithWords(words:String)->String{
        var faceImgsPath:String = NSBundle.mainBundle().pathForResource("expression",ofType:"plist")
        var data:NSMutableDictionary = NSMutableDictionary(contentsOfFile:faceImgsPath)
        var value:NSString = data.objectForKey(words) as NSString
        if value == ""||value.length<7{
            value = "Expression_1@2x.png"
        }
        value = value.substringWithRange(NSRange(location:0,length:value.length-7))
        return value as String
    }
    
    /*
        把天气图片翻译成文字
    */
    func translateWeatherWithImageName(imageName:String)->String{
        var faceImgsPath:String = NSBundle.mainBundle().pathForResource("weatherPList",ofType:"plist")
        var data:NSMutableDictionary = NSMutableDictionary(contentsOfFile:faceImgsPath)
        var value:String = data.objectForKey(imageName) as String
        return value
    }
    
    /*
        把文字翻译成天气图片
    */
    func translateWeatherWithWords(words:String)->String{
        var faceImgsPath:String = NSBundle.mainBundle().pathForResource("weatherPList",ofType:"plist")
        var data:NSMutableDictionary = NSMutableDictionary(contentsOfFile:faceImgsPath)
        var keys:NSArray = data.allKeysForObject(words)
        var key:String = keys.objectAtIndex(0) as String
        return key
    }
    
    //得到日历日期，以及对应的星期
    func tupleFromDate(date:NSDate) ->(String,String,String,String){
        let comps = self.getCompsFromDate(date)
        let year:String = "\(comps.year)"
        let month:String = "\(comps.month)"
        let day:String = "\(comps.day)"
        let weekday:String = "\(Li_common().Li_weekdayTranslate(comps.weekday))"
        println(year)
        println(month)
        println(day)
        println(weekday)

        return (year,month,day,weekday)
    }
    
    //返回2014-06-19 星期三 String格式的日期
    func dateStringFromDate(date:NSDate) ->String{
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString:String = dateFormatter.stringFromDate(date)
        
        let comps = self.getCompsFromDate(date)
        let weekday:Int = comps.weekday
        let weekdayString:String = Li_common().Li_weekdayTranslate(weekday)

        dateString = "\(dateString) \(weekdayString)"
        
        return dateString
    }
    
    //将2014-06-19 星期三 String格式的日期 转化成（年月，日，星期）格式
    func tupleFromDateString(dateString:String!)->(String,String,String,String){
        var date:NSString = dateString as NSString
        var year:String = date.substringWithRange(NSRange(location:0,length:4))
        var month:String = date.substringWithRange(NSRange(location:5,length:2))
        var day:String = date.substringWithRange(NSRange(location:8,length:2))
        var weekday:String = date.substringWithRange(NSRange(location:11,length:3))
        return (year,month,day,weekday)
    }
    
    func getCompsFromDate(date:NSDate)->NSDateComponents{
        var calendar:NSCalendar = NSCalendar.currentCalendar()
        var comps:NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday,fromDate:date)
        let year = comps.year
        let weekday = comps.weekday
        return comps
    }
}










