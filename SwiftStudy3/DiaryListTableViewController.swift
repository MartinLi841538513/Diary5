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

    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.time.text = diary.date
        cell.diaryContent.text = diary.content
        cell.photoImg.image = UIImage(contentsOfFile:diary.photos)
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
        return 117.0
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    //加载所有日记
    func loadDiaries(){
        let diaryDao:DiaryService = DiaryService()
        self.diaries = diaryDao.allDiaries()
        self.tableView.reloadData()
    }
}
