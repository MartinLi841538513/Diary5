//
//  DiaryModefyViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//
/*
    status:
    0:新增模式
    1:日记明细模式
    2:修改模式
*/
import UIKit

class DiaryModefyViewController: UIViewController,UIActionSheetDelegate,UIMenuBarDelegate{
    
    @IBOutlet var dateButton : UIButton = nil
    @IBOutlet var content : UITextView = nil
    @IBOutlet var saveAndModefyButton : UIBarButtonItem = nil
    var menuBar:UIMenuBar = UIMenuBar()
    var fontColor:UIColor = UIColor()
    var status:Int = 0
    
    var diary:Diary = Diary()

    var datePicker:UIDatePicker = UIDatePicker()
    var alertview:UIView! = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fontColor = self.dateButton.currentTitleColor
        
        //0:日记新增模式  1:日记明细模式
        if self.status == 0{
            self.addModeSet()
        }else if self.status == 1{
            self.detailModeSet(self.diary)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //新增状态模式参数设置
    func addModeSet(){
        self.status = 0
        self.basicModefyModeSet()
        //设置默认日期为今天
        var currentDate:String = dateString(NSDate())
        self.dateButton.setTitle(currentDate, forState: UIControlState.Normal)
    }
    //日记明细模式参数设置
    func detailModeSet(diary:Diary){
        self.status = 1
        self.saveAndModefyButton.title = "更多"
        self.title = "日记详情"
        self.content.text = self.diary.content
        self.dateButton.setTitle(self.diary.date,forState:UIControlState.Normal)
        self.content.editable = false
        self.dateButton.enabled = false
        self.dateButton.setTitleColor(self.fontColor, forState: UIControlState.Normal)
    }
    //修改状态模式参数设置
    func updateModeSet(){
        self.status = 2
        self.basicModefyModeSet()
    }
    func basicModefyModeSet(){
        self.saveAndModefyButton.title = "保存"
        self.title = "编辑日记"
        self.content.editable = true
        self.dateButton.enabled = true
    }

    /*
        0,2:点击保存
        1:点击更多
    */
    @IBAction func save(sender : AnyObject) {
        if self.status == 0{
            let diaryService:DiaryService = DiaryService()
            var diary:Diary = self.currentDiary()
            diaryService.addDiary(diary)
            self.diary = diaryService.theLatestDiary()//这样就能或得到diary的id，那么就可以根据id修改这片新增的日记
            self.detailModeSet(self.diary)
        }else if self.status == 1{
            var menuItem1:UIMenuBarItem = UIMenuBarItem(title:"编辑",target:self,image:UIImage(named:"modify.png"),action:Selector("modefyDiary:"))
            var menuItem2:UIMenuBarItem = UIMenuBarItem(title:"删除",target:self,image:UIImage(named:"modify.png"),action:Selector("deleteDiary:"))
            var menuItem3:UIMenuBarItem = UIMenuBarItem(title:"分享",target:self,image:UIImage(named:"modify.png"),action:Selector("shareDiary:"))
            var items:NSMutableArray = [menuItem1,menuItem2,menuItem3]
            self.menuBar = UIMenuBar(frame:CGRectMake(10, 0, self.view.bounds.size.width, 240.0) ,items:items)
            self.menuBar.delegate = self
            self.menuBar.items = items
            self.menuBar.show()
        }else if self.status == 2{
            let diaryService:DiaryService = DiaryService()
            var diary:Diary = self.currentDiary()
            diaryService.updateDiary(diary)
            self.detailModeSet(diary)
        }
    }
    
    //获取当前日记对象
    func currentDiary() ->Diary{
        var diary:Diary = Diary()
        diary = self.diary
        diary.date = dateButton.currentTitle
        diary.content = self.content.text
        return diary
    }
    
    /*
        编辑（修改）日记
    */
    func modefyDiary(sender:AnyObject){
        self.updateModeSet()
        self.menuBar.dismiss()
    }
    
    /*
        删除日记
    */
    func deleteDiary(sender:AnyObject){
        let diaryService:DiaryService = DiaryService()
        diaryService.deleteDiary(self.currentDiary())
        self.menuBar.dismiss()
        self.navigationController.popViewControllerAnimated(true)
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
