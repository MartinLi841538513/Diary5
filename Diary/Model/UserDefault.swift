//
//  UserDefault.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-12.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class UserDefault: NSObject {
    
    var defaults:NSUserDefaults!
    
    init() {
        super.init()
        self.defaults = NSUserDefaults.standardUserDefaults()
    }
    
    func setIsFirstRunApp(isFirst:Bool){
        self.defaults.setObject(isFirst,forKey:"isFirstRunApp")
        self.defaults.synchronize()
    }
    func isFirstRunApp()->Bool{
        var isFirstRunApp:AnyObject! = self.defaults.objectForKey("isFirstRunApp")
        if isFirstRunApp == nil{
            return true
        }
        return isFirstRunApp as Bool
    }
    
    func setIsFirstSetTapPassword(isFirstSetTapPassword:Bool){
        self.defaults.setObject(isFirstSetTapPassword,forKey:"isFirstSetTapPassword")
        self.defaults.synchronize()
    }
    func isFirstSetTapPassword()->Bool{
        var isFirstSetTapPassword:AnyObject! = self.defaults.objectForKey("isFirstSetTapPassword")
        if isFirstSetTapPassword == nil{
            return true
        }
        return isFirstSetTapPassword as Bool
    }
    
    func setIsLoginStatus(isLoginStatus:Bool){
        self.defaults.setObject(isLoginStatus,forKey:"isLoginStatus")
        self.defaults.synchronize()
    }
    func isLoginStatus()->Bool{
        var isLoginStatus:AnyObject! = self.defaults.objectForKey("isLoginStatus")
        if isLoginStatus == nil||isLoginStatus as Bool == false{
            return false
        }
        return isLoginStatus as Bool
    }
    
    func setIsTapPasswordAllowed(isTapPasswordAllowed:Bool){
        self.defaults.setObject(isTapPasswordAllowed,forKey:"isTapPasswordAllowed")
        self.defaults.synchronize()
    }
    func isTapPasswordAllowed()->Bool{
        var isTapPasswordAllowed:AnyObject! = self.defaults.objectForKey("isTapPasswordAllowed")
        if isTapPasswordAllowed == nil{
            return false
        }
        return isTapPasswordAllowed as Bool
    }
    
    func setUserId(userId:Int){
        self.defaults.setObject(String(userId) as NSString,forKey:"userId")
        self.defaults.synchronize()
    }
    func userId()->Int{
        return (self.defaults.objectForKey("userId") as String).toInt()!
    }
    
    func setNickname(nickname:String){
        self.defaults.setObject(nickname,forKey:"nickname")
        self.defaults.synchronize()
    }
    func nickname()->String{
        return self.defaults.objectForKey("nickname") as String
    }
    
    func setPassword(password:String){
        self.defaults.setObject(password,forKey:"nickname")
        self.defaults.synchronize()
    }
    func password()->String{
        return self.defaults.objectForKey("password") as String
    }
    
    func setTapPassword(tapPassword:String){
        self.defaults.setObject(tapPassword,forKey:"tapPassword")
        self.defaults.synchronize()
    }
    func tapPassword()->String{
        return self.defaults.objectForKey("tapPassword") as String
    }
    
    func setEmail(email:String){
        self.defaults.setObject(email,forKey:"email")
        self.defaults.synchronize()
    }
    func email()->String{
        return self.defaults.objectForKey("email") as String
    }
    
    func setUserInfos(user:User){
        self.defaults.setObject(String(user.id) as NSString,forKey:"userId")
        self.defaults.setObject(user.nickname,forKey:"nickname")
        self.defaults.setObject(user.password,forKey:"nickname")
        self.defaults.setObject(user.email,forKey:"email")
        self.defaults.synchronize()
    }
   
}
