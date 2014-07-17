//
//  DiaryListTableViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class DiaryListTableViewController: UITableViewController,UITableViewDataSource{

    var diaries:NSMutableArray = NSMutableArray()
    var userDefault:UserDefault = UserDefault()
    var diaryService:DiaryService = DiaryService()
    var isLogin:Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefault().isTapPasswordAllowed()==true&&object_getClassName(self.tabBarController.presentingViewController) != "UINavigationController"{
            var storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            var setTapPasswordViewController:SetTapPasswordViewController = storyboard.instantiateViewControllerWithIdentifier("SetTapPasswordViewController") as SetTapPasswordViewController
            setTapPasswordViewController.status = 0
            self.tabBarController.presentModalViewController(setTapPasswordViewController,animated:true)
        }
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.loadDiaries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.diaries.count
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        
        //cell标志符，使cell能够重用（如果不需要重用，是不是可以有更简单的配置方法？）
        let indentifier:String = "DiaryCell"
        //注册自定义cell到tableview中，并设置cell标识符为indentifier（nibName对应UItableviewcell xib的名字）
        var nib:UINib = UINib(nibName:"DiaryCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: indentifier)
        //从tableview中获取标识符为papercell的cell
        var cell:DiaryCell = tableView.dequeueReusableCellWithIdentifier(indentifier) as DiaryCell
        
        //设置单元格属性
        let row:Int = indexPath.row
        let diary:Diary = self.diaries.objectAtIndex(row) as Diary
        cell.weather.image = UIImage(named:self.diaryService.translateWeatherWithWords(diary.weather))
        cell.mood.image = UIImage(named:self.diaryService.translateExpressWithWords(diary.mood))
        if diary.latitude == 0{
            cell.locate.image = UIImage(named:"locate")
        }
        
        cell.time.text = diary.date
        cell.diaryContent.text = diary.content
        let image:UIImage = UIImage(contentsOfFile:diary.photos)
        if image != nil{
            cell.photoImg.image = image
        }else{
            cell.photoImg.image = UIImage(named:diary.photos)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        let row:Int = indexPath.row
        let diary:Diary = diaries.objectAtIndex(row) as Diary
        
        var storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil) //Main对应storyboard的名字
        var diaryDetail:DiaryModefyViewController = DiaryModefyViewController() //初始化稍后即将显示的那个viewController
        diaryDetail = storyboard.instantiateViewControllerWithIdentifier("DiaryModefyViewController") as DiaryModefyViewController  //关联viewController对应storyboard的xib。其中Identifier对应Main.storyboard中的xib的storyboardIdentify
        diaryDetail.diary = diary
        diaryDetail.status = 1
        self.navigationController.pushViewController(diaryDetail,
            animated: true)   //这是导航的push切换方式
    }
    
    @IBAction func addDiary(sender: AnyObject) {
        
        var storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil) //Main对应storyboard的名字
        var diaryDetail:DiaryModefyViewController = DiaryModefyViewController() //初始化稍后即将显示的那个viewController
        diaryDetail = storyboard.instantiateViewControllerWithIdentifier("DiaryModefyViewController") as DiaryModefyViewController  //关联viewController对应storyboard的xib。其中Identifier对应Main.storyboard中的xib的storyboardIdentify
        diaryDetail.status = 0
        self.navigationController.pushViewController(diaryDetail,
            animated: true)   //这是导航的push切换方式

    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let row:Int = indexPath.row
            let diary:Diary = self.diaries.objectAtIndex(row) as Diary
            self.diaries.removeObjectAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            let diaryService:DiaryService = DiaryService()
            diaryService.deleteDiary(diary)
        }
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        return 97.0
    }
    

    func loadData(notification:NSNotification){
        self.loadDiaries()
    }
    
    //加载所有日记
    func loadDiaries(){
        let diaryDao:DiaryService = DiaryService()
        println(self.userDefault.userId())
        var result:(Bool,NSMutableArray) = diaryDao.allDiariesWithUserId(self.userDefault.userId())
        if result.0 == true {
            self.diaries = result.1
            self.tableView.reloadData()
        }else{
            println("获取用户所有日记失败")
        }
    }
    
}
