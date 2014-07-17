//
//  Diary.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import Foundation

class Diary:NSObject{
    var id:Int?
    var date:String = ""
    var weather:String = "晴"
    var mood:String = "[微笑]"
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var photos:String = "DongWay76"
    var voicePath:String = ""
    var content:String = ""
    var address:String = ""
    var detailAddress:String = ""
    var userId:Int?
    
    init(){
    
    }
}


