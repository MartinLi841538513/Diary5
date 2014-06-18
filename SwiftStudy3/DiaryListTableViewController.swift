//
//  DiaryListTableViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class DiaryListTableViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 5
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        //cell标志符，使cell能够重用（如果不需要重用，是不是可以有更简单的配置方法？）
        let indentifier:String = "DiaryCell"
        //注册自定义cell到tableview中，并设置cell标识符为indentifier（nibName对应UItableviewcell xib的名字）
        var nib:UINib = UINib(nibName:"DiaryCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: indentifier)
        //从tableview中获取标识符为papercell的cell
        var cell:DiaryCell = tableView.dequeueReusableCellWithIdentifier(indentifier) as DiaryCell
        //设置单元格属性
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        var storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil) //Main对应storyboard的名字
        var diaryDetail:DiaryModefyViewController = DiaryModefyViewController() //初始化稍后即将显示的那个viewController
        diaryDetail = storyboard.instantiateViewControllerWithIdentifier("DiaryModefyViewController") as DiaryModefyViewController  //关联viewController对应storyboard的xib。其中Identifier对应Main.storyboard中的xib的storyboardIdentify
        self.navigationController.pushViewController(diaryDetail,
            animated: true)   //这是导航的push切换方式
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
