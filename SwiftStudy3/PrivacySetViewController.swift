//
//  PrivacySetViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-16.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class PrivacySetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SwitchCellDelegate,SetTapPasswordViewDelegate {

    @IBOutlet var tableview: UITableView
    var datas:NSMutableArray = NSMutableArray()
    init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "隐私"
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        var title1:String = "开启手势密码"
        self.datas.addObject(title1)
        self.tableview.frame = CGRectMake(0,20,DeviceFrame.width,100)

        if UserDefault().isTapPasswordAllowed() == true{
            var title2:String = "重置手势密码"
            self.datas.addObject(title2)
            self.tableview.frame = CGRectMake(0,20,DeviceFrame.width,140)
        }
        
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int{
        return 1
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return self.datas.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{

        let section = indexPath.section
        let row = indexPath.row
        var cell:UITableViewCell!
        switch section{
        case 0:
            switch row{
            case 0:
                let data = self.datas.objectAtIndex(row) as String
                let indentifier:String = "SwitchCell"
                var nib:UINib = UINib(nibName:"SwitchCell", bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: indentifier)
                var cell:SwitchCell = tableView.dequeueReusableCellWithIdentifier(indentifier) as SwitchCell
                cell.delegate = self
                cell.title.text = data
                if UserDefault().isTapPasswordAllowed() == true{
                    cell.switchButton.on = true
                }else{
                    cell.switchButton.on = false
                }
                return cell
            case 1:
                let data = self.datas.objectAtIndex(row) as String
                let indentifier:String = "SwitchCell"
                var nib:UINib = UINib(nibName:"SwitchCell", bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: indentifier)
                var cell:SwitchCell = tableView.dequeueReusableCellWithIdentifier(indentifier) as SwitchCell
                cell.title.text = data
                cell.switchButton.hidden = true
                cell.accessoryType = .DisclosureIndicator
                return cell

            default:println("")
            }
        default:println("")
        }
        return cell
    }

    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        return 40
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        let row = indexPath.row

        switch row{
        case 1:self.setTapPassword()
        default:println("")
        }
    }
    
    /*
        #SwitchCellDelegate
    */
    func switchButtonAction(sender: AnyObject){
        var isButtonOn:Bool = (sender as UISwitch).on
        self.tableview.beginUpdates()
        if isButtonOn==true{
            var isFirstSetTapPassword:Bool = UserDefault().isFirstSetTapPassword()
            if isFirstSetTapPassword{
                self.setTapPassword()
                (sender as UISwitch).on = false
            }else{
                self.addRow()
                UserDefault().setIsTapPasswordAllowed(true)
            }
        }else{
            self.deleteRow()
            UserDefault().setIsTapPasswordAllowed(false)
        }
        self.tableview.endUpdates()
    }
    
    /*
        #SetTapPasswordViewDelegate
    */
    func setTapPasswordSuccessAction(){
        var userDefault:UserDefault = UserDefault()
        if userDefault.isFirstSetTapPassword(){
            self.addRow()
        }
        userDefault.setIsTapPasswordAllowed(true)
        userDefault.setIsFirstSetTapPassword(false)
        var indexPath:NSIndexPath = NSIndexPath(forRow:0,inSection:0)
        (self.tableview.cellForRowAtIndexPath(indexPath) as SwitchCell).switchButton.on = true
    }
    
    //设置手势密码
    func setTapPassword(){
        var storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        var setTapPasswordViewController:SetTapPasswordViewController = storyboard.instantiateViewControllerWithIdentifier("SetTapPasswordViewController") as SetTapPasswordViewController
        setTapPasswordViewController.status = 1
        setTapPasswordViewController.delegate = self
        setTapPasswordViewController.forgetTip.hidden = true
        self.navigationController.pushViewController(setTapPasswordViewController,animated:true)

    }
    
    //为tableview添加一行
    func addRow(){
        var title2:String = "重置手势密码"
        self.datas.addObject(title2)
        var indexPaths:NSMutableArray = NSMutableArray()
        var indexPath:NSIndexPath = NSIndexPath(forRow:1,inSection:0)
        indexPaths.addObject(indexPath)
        self.tableview.insertRowsAtIndexPaths(indexPaths,withRowAnimation:.Top)
        self.tableview.frame = CGRectMake(0,20,DeviceFrame.width,140)
    }
    
    //删除一行
    func deleteRow(){
        self.datas.removeLastObject()
        var indexPaths:NSMutableArray = NSMutableArray()
        var indexPath:NSIndexPath = NSIndexPath(forRow:1,inSection:0)
        indexPaths.addObject(indexPath)
        self.tableview.deleteRowsAtIndexPaths(indexPaths,withRowAnimation:.Middle)
        self.tableview.frame = CGRectMake(0,20,DeviceFrame.width,100)
    }


}
