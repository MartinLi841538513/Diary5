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

    //新增一篇日记
    func addDiary(diary:Diary){
        self.diaryDao.addDiary(diary)
    }
    
    //得到所有的日记
    func allDiaries() ->NSArray{
        let diaryList:NSArray = self.diaryDao.allDiaries() as NSArray
        return diaryList
    }
    
    //将所有日记的格式从dictionary转为Diary
    func dictsToObjects(dicts:NSArray) ->NSArray{
        var allDiaries = Diary[]()
        let length:Int = dicts.count
        for i in 0..length{
            var dict:NSDictionary = dicts.objectAtIndex(i) as NSDictionary
            var diary:Diary = dictToObject(dict)
            allDiaries.append(diary)
        }
        return allDiaries
    }
    
    //diary对象dictionary形式转化成Diary
    func dictToObject(dict:NSDictionary) ->Diary{
        var diary:Diary = Diary()
        diary.date = dict.objectForKey("date") as? String
        diary.weather = dict.objectForKey("weather") as? String
        diary.mood = dict.objectForKey("mood") as? String
        diary.latitude = dict.objectForKey("latitude") as? String
        diary.longitude = dict.objectForKey("longitude") as? String
        diary.photos = dict.objectForKey("imgPath") as? String
        diary.voicePath = dict.objectForKey("voicePath") as? String
        diary.content = dict.objectForKey("content") as? String
        
        return diary
    }

    //diary对象Diary形式转化成dictionary
    func objectToDict(object:Diary) ->NSDictionary{
        var dict:NSMutableDictionary = NSMutableDictionary()
        var diary = self.nilToAnyObject(object)
        dict.setObject(diary.date,forKey:"date")
        dict.setObject(diary.weather,forKey:"weather")
        dict.setObject(diary.mood,forKey:"mood")
        dict.setObject(diary.latitude,forKey:"latitude")
        dict.setObject(diary.longitude,forKey:"longitude")
        dict.setObject(diary.photos,forKey:"photoes")
        dict.setObject(diary.voicePath,forKey:"voicePath")
        dict.setObject(diary.content,forKey:"content")
        return dict
    }
    
    func nilToAnyObject(diary:Diary) ->Diary{
//        if diary.date==nil{
//            diary.date = ""
//        }
//        if diary.weather==nil{
//            diary.weather=""
//        }
//        if diary.mood==nil{
//            diary.mood = ""
//        }
//        if diary.latitude==nil{
//            diary.latitude = ""
//        }
//        if diary.longitude==nil{
//            diary.longitude = ""
//        }
//        if diary.photoes == nil{
//            diary.photoes = ""
//        }
//        if diary.voicePath==nil{
//            diary.voicePath = ""
//        }
//        if diary.content == nil{
//            diary.content = ""
//        }
        return diary
    }
}










