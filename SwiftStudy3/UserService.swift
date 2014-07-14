//
//  UserService.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-12.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class UserService: NSObject {
    
    let userDao:UserDao = UserDao()
    
    //创建数据库表
    func createTable(){
        self.userDao.createTable()
    }
    
    /*
        用户注册
    */
    func signUpWithNickname(nickname:String,andEmail email:String,andPassword password:String,andViewController viewController:UIViewController)->(Bool,User){
        var user:User = User()
        user.nickname = nickname
        user.email = email
        user.password = password
        var result:(Bool,User) = self.userDao.addUser(user)
        
        if result.0 == true{
            user = result.1
            var userdefault:UserDefault = UserDefault()
            userdefault.setIsLoginStatus(true)
            userdefault.setUserInfos(user)
            NSNotificationCenter.defaultCenter().postNotificationName("Login_Notification",object:self,userInfo:nil)
            viewController.navigationController.dismissModalViewControllerAnimated(true)
            LIProgressHUD.showSuccessWithStatus("用户\(email)注册成功")
        }else{
            LIProgressHUD.showErrorWithStatus("注册失败")
        }
        
        return result
    }
    
    /*
        用户登录
    */
    func signInWithEmail(email:String,andPassword password:String,andViewController viewController:UIViewController)->(Bool,User){
        var bool:Bool = false
        var user:User = User()
        
        if email as AnyObject==nil||email==""{
            LIProgressHUD.showErrorWithStatus("用户名不能为空")
        }else if password as AnyObject==nil || password==""{
            LIProgressHUD.showErrorWithStatus("密码错误")
        }else{
            func successLoginDataHandle(){
                var userdefault:UserDefault = UserDefault()
                userdefault.setIsLoginStatus(true)
                userdefault.setUserInfos(user)
                NSNotificationCenter.defaultCenter().postNotificationName("Login_Notification",object:self,userInfo:nil)
                viewController.navigationController.dismissModalViewControllerAnimated(true)
                LIProgressHUD.showSuccessWithStatus("用户\(email)登录成功")
            }

            func loginEvent(){
                var result:(Bool,User) = self.userDao.findUserWithEmail(email,andPassword:password)
                if result.0 == false{
                    LIProgressHUD.showErrorWithStatus("登录失败")
                }else{
                    user = result.1
                    bool = true
                    successLoginDataHandle()
                }
            }
            loginEvent()
        }
        return (true,user)
    }
    
    /*
        判断邮箱是否已经注册
    */
    func databaseContainsEmail(email:String)->Bool{
        return self.userDao.databaseContainsEmail(email)
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
        var userDefaults:UserDefault = UserDefault()
        var isFirstRunApp:Bool! = userDefaults.isFirstRunApp()
        if isFirstRunApp == nil || isFirstRunApp == false{
            userDefaults.setIsFirstRunApp(true)
            println("第一次运行该app")
            return true
        }else{
            userDefaults.setIsFirstRunApp(false)
            println("不是第一次运行该app")
            return false
        }
    }

}
