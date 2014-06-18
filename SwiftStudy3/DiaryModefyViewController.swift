//
//  DiaryModefyViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class DiaryModefyViewController: UIViewController,UIActionSheetDelegate{
    @IBOutlet var dateButton : UIButton = nil

    var datePicker:UIDatePicker = UIDatePicker()
    var alertview:UIView! = UIView()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.、
        //设置默认日期为今天
        var currentDate:String = dateString(NSDate())
        dateButton.setTitle(currentDate, forState: UIControlState.Normal)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func date(sender : AnyObject) {
        var screen:UIScreen = UIScreen.mainScreen()
        var devicebounds:CGRect = screen.bounds
        var deviceWidth:CGFloat = devicebounds.width
        var deviceHeight:CGFloat = devicebounds.height
        var viewColor:UIColor = UIColor(white:0, alpha: 0.6)

        //设置日期弹出窗口
        alertview = UIView(frame:devicebounds)
        alertview.backgroundColor = viewColor
        alertview.userInteractionEnabled = true
        
        //设置datepicker
        datePicker.datePickerMode = .Date
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.frame = CGRect(x:10,y:deviceHeight-297,width:deviceWidth-10*2,height:216)
        
        //设置 确定 和 取消 按钮
        var li_common:LI_common = LI_common()
        var selectedButton:UIButton = li_common.createButton("确定",x:10,y:deviceHeight-80,width:deviceWidth-10*2,height:35,target:self, action: Selector("selectedAction"))
        var cancelButton:UIButton = li_common.createButton("取消",x:10,y:deviceHeight-40,width:deviceWidth-10*2,height:35,target:self, action: Selector("cancelAction"))
        
        alertview.addSubview(datePicker)
        alertview.addSubview(selectedButton)
        alertview.addSubview(cancelButton)
        
        self.view.addSubview(alertview)
    }
    
    //选择日期
    func selectedAction(){
        var dateString:String = self.dateString(datePicker.date)
        dateButton.setTitle(dateString, forState: UIControlState.Normal)
        removeAlertview()
        println(dateString)
    }
    
    func cancelAction(){
        removeAlertview()
        println("取消")
    }
    
    func removeAlertview(){
        alertview.removeFromSuperview()
    }
    
    //返回2014-06-19格式的日期
    func dateString(date:NSDate) ->String{
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString:String = dateFormatter.stringFromDate(date)
        return dateString
    }
   
}
