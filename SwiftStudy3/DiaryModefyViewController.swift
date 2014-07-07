//
//  DiaryModefyViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//
/*

    0:编辑模式
    1:日记明细模式
*/
import UIKit

class DiaryModefyViewController: UIViewController,UIActionSheetDelegate,UIMenuBarDelegate{
    
    @IBOutlet var dateButton : UIButton = nil
    @IBOutlet var content : UITextView = nil
    @IBOutlet var saveAndModefyButton : UIBarButtonItem = nil
    var menuBar:UIMenuBar = UIMenuBar()
    var status:Int = 0 //0是编辑状态，1是详情状态
    
    var diary:Diary = Diary()

    var datePicker:UIDatePicker = UIDatePicker()
    var alertview:UIView! = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //0:日记编辑模式  1:日记明细模式
        if self.status == 0{
            //设置默认日期为今天
            var currentDate:String = dateString(NSDate())
            dateButton.setTitle(currentDate, forState: UIControlState.Normal)
            self.modefyModeSet()
        }else if self.status == 1{
            self.title = self.diary.id
            self.content.text = self.diary.content
            self.dateButton.setTitle(self.diary.date,forState:UIControlState.Normal)
            self.detailModeSet()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //编辑状态模式参数设置
    func modefyModeSet(){
        self.status = 0
        self.saveAndModefyButton.title = "保存"
        self.title = "编辑日记"
        self.content.editable = true
    }
    
    //日记明细模式参数设置
    func detailModeSet(){
        self.status = 1
        self.saveAndModefyButton.title = "更多"
        self.title = "日记详情"
        self.content.editable = false
    }
    
    @IBAction func save(sender : AnyObject) {
        /*
            0:点击保存
            1:点击更多
        */
        if self.status == 0{
            let diaryService:DiaryService = DiaryService()
            var diary:Diary = Diary()
            diary.date = dateButton.currentTitle
            diary.content = self.content.text
            diaryService.addDiary(diary)
            self.detailModeSet()
        }else if self.status == 1{
            var menuItem1:UIMenuBarItem = UIMenuBarItem(title:"编辑",target:self,image:UIImage(named:"modify.png"),action:Selector("modefyDiary:"))
            var menuItem2:UIMenuBarItem = UIMenuBarItem(title:"删除",target:self,image:UIImage(named:"modify.png"),action:Selector("deleteDiary:"))
            var menuItem3:UIMenuBarItem = UIMenuBarItem(title:"分享",target:self,image:UIImage(named:"modify.png"),action:Selector("shareDiary:"))
            var items:NSMutableArray = [menuItem1,menuItem2,menuItem3]
            self.menuBar = UIMenuBar(frame:CGRectMake(10, 0, self.view.bounds.size.width, 240.0) ,items:items)
            self.menuBar.delegate = self
            self.menuBar.items = items
            self.menuBar.show()
        }
    }
    
    /*
        编辑日记
    */
    func modefyDiary(sender:AnyObject){
        self.menuBar.dismiss()
    }
    
    /*
        删除日记
    */
    func deleteDiary(sender:AnyObject){
        self.menuBar.dismiss()
    }
    
    /*
        分享日记
    */
    func shareDiary(sender:AnyObject){
        self.menuBar.dismiss()
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
        var li_common:Li_common = Li_common()
        var selectedButton:UIButton = li_common.Li_createButton("确定",x:10,y:deviceHeight-80,width:deviceWidth-10*2,height:35,target:self, action: Selector("selectedAction"))
        var cancelButton:UIButton = li_common.Li_createButton("取消",x:10,y:deviceHeight-40,width:deviceWidth-10*2,height:35,target:self, action: Selector("cancelAction"))
        
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
