//
//  SetTapPasswordViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-16.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

protocol SetTapPasswordViewDelegate:NSObjectProtocol{
    func setTapPasswordSuccessAction()
}

class SetTapPasswordViewController: UIViewController,TapPasswordViewDelegate{

    var delegate:SetTapPasswordViewDelegate!
    @IBOutlet var tapPasswordView: TapPasswordView!
    var tipLabel:UILabel!
    var forgetTip:UILabel = UILabel()
    var status:Int = 0 // 0登录时破解手势密码，1设置手势密码
    var tapCount:Int = 0//设置密码的次数
    var tempPassword:String!

    init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "设置手势密码"
        self.tapPasswordView.delegate = self
        self.tipLabel = UILabel(frame:CGRectMake(0,70,DeviceFrame.width,20))
        switch self.status{
        case 0:
            self.tipLabel.text = "请输入手势密码"
        default:
            self.tipLabel.text = "绘制解锁图案"
        }
        self.tipLabel.textAlignment = .Center
        self.tapPasswordView.addSubview(self.tipLabel)
        
        self.forgetTip.frame = CGRectMake(0,480,DeviceFrame.width,20)
        self.forgetTip.textAlignment = .Center
        self.forgetTip.text = "忘记手势密码"
        self.forgetTip.textColor = UIColor.blueColor()
        self.forgetTip.font = UIFont.systemFontOfSize(12)
        self.forgetTip.userInteractionEnabled = true
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:Selector("forgetTapPasswordAction:"))
        self.forgetTip.addGestureRecognizer(tap)
        self.tapPasswordView.addSubview(self.forgetTip)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
        #TapPasswordViewDelegate
    */
    func touchendActionWithPassword(password:NSString){
        var passwordFromView:String = password as String
        self.tapCount = self.tapCount+1
        switch self.status{
        case 0:
            self.loginTapPassword(password)
        case 1:
            self.setTapPassword(passwordFromView)
        default:println("")
        }

    }

    /*
        登录手势密码
    */
    func loginTapPassword(password:String){
        if password == UserDefault().tapPassword(){
            self.dismissModalViewControllerAnimated(true)
        }else{
            self.tipLabel.text = "密码错误"
            self.tipLabel.textColor = UIColor.redColor()
        }
    }
    
    /*
        设置手势密码
    */
    func setTapPassword(password:String){
        if self.tapCount==1{
            self.tempPassword = password
            self.tipLabel.text = "请再次绘制解锁图案"
        }else if self.tapCount == 2{
            if self.tempPassword == password{
                LIProgressHUD.showSuccessWithStatus("设置成功")
                UserDefault().setTapPassword(password)
                self.navigationController.popViewControllerAnimated(true)
                self.delegate.setTapPasswordSuccessAction()
            }else{
                LIProgressHUD.showErrorWithStatus("设置失败")
                self.tipLabel.text = "绘制解锁图案"
            }
            self.tapCount = 0
        }
    }

    /*
        忘记手势密码
    */
    func forgetTapPasswordAction(sender:AnyObject!){
        var storyboard:UIStoryboard = UIStoryboard(name:"User",bundle:nil)
        var navController:UINavigationController = storyboard.instantiateViewControllerWithIdentifier("SignUpNav") as UINavigationController
        self
            .presentModalViewController(navController, animated: true)
        UserDefault().setIsLoginStatus(false)
    }
    
}






