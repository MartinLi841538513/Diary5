//
//  SetTableViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-14.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit


class SetTableViewController: UITableViewController {
    var dataArray1 = String[]()
    var images1 = String[]()

    init(style: UITableViewStyle){
        super.init(style:style)
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray1 = ["隐私"]
        self.images1 = ["privacy.png"]
        self.tableView.scrollEnabled = false
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0{
            return self.dataArray1.count
        }else{
            return 1
        }
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var section = indexPath.section
        var row = indexPath.row
        var cellForReturn:UITableViewCell!
        if section == 0{
            let identifier:String = "SetTableViewCell"
            let nib:UINib = UINib(nibName:"SetTableViewCell",bundle:nil)
            tableView.registerNib(nib,forCellReuseIdentifier:identifier)
            let cell:SetTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as SetTableViewCell
            var data = self.dataArray1[row] as String
            var imageName = self.images1[row] as String
            cell.title.text = data
            cell.imageIcon.image = UIImage(named:imageName)
            cell.accessoryType = .DisclosureIndicator
            cellForReturn = cell
            
        }else{
            let identifier:String = "Set2TableViewCell"
            let nib:UINib = UINib(nibName:"Set2TableViewCell",bundle:nil)
            tableView.registerNib(nib,forCellReuseIdentifier:identifier)
            let cell:Set2TableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as Set2TableViewCell
            cell.title.text = "退出账号"
            cellForReturn = cell
        }
        
        return cellForReturn
    }

    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        var section = indexPath.section
        var row = indexPath.row
        if section == 0{
            return 44
        }else{
            return 40
        }
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0{
            return 20
        }else{
            return DeviceFrame.height-44*2-self.navigationController.navigationBar.frame.height-20-self.tabBarController.tabBar.frame.height
        }
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        let section:Int = indexPath.section
        let row:Int = indexPath.row
        if section == 0{
            switch row {
            case 0:
                var storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                var privacySetViewController:PrivacySetViewController = storyboard.instantiateViewControllerWithIdentifier("PrivacySetViewController") as PrivacySetViewController
                privacySetViewController.hidesBottomBarWhenPushed = true
                self.navigationController.pushViewController(privacySetViewController,animated:true)
            default:
                println("")
            }
            
        }else if section == 1{
            self.showLoginViewOnViewController(self)
        }
    }

    
    /*
        显示登录界面
    */
    func showLoginViewOnViewController(viewController:UIViewController){
        var storyboard:UIStoryboard = UIStoryboard(name:"User",bundle:nil)
        var navController:UINavigationController = storyboard.instantiateViewControllerWithIdentifier("SignUpNav") as UINavigationController
        self.tabBarController.presentModalViewController(navController, animated: true)
        UserDefault().setIsLoginStatus(false)
    }
    


}
