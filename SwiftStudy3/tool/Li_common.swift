//
//  Li_common.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-18.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import Foundation
import UIKit

let DeviceFrame:CGRect = UIScreen.mainScreen().applicationFrame
let StatusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
let PopUpFromBottomBackgroundColor:UIColor = UIColor.greenColor()

class Li_common:NSObject,UIGestureRecognizerDelegate{
    
    var fullScreenBlackView:UIView = UIView()
    /*
    快速创建一种常用的button，state：normal，  backgroundcolor：white，  type：system    ControlEvents:TouchUpInside
    */
    func Li_createButton(title:String!,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,target: AnyObject!, action: Selector) ->UIButton{
        var buttonRect:CGRect = CGRect(x:x, y:y, width:width, height:height)
        var button:UIButton = UIButton.buttonWithType(.System) as UIButton
        button.setTitle(title, forState: UIControlState.Normal)
        button.frame = buttonRect
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    
    func Li_weekdayTranslate(weekday:Int)->String{
        var weekdayString:String!
        switch weekday{
        case 1:
            weekdayString = "星期日"
        case 2:
            weekdayString = "星期一"
        case 3:
            weekdayString = "星期二"
        case 4:
            weekdayString = "星期三"
        case 5:
            weekdayString = "星期四"
        case 6:
            weekdayString = "星期五"
        case 7:
            weekdayString = "星期六"
        default:println("")
        }
        return weekdayString
    }
    
    
    func Li_detailTimeString()->String{
        var date:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        var dateString:String = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    /*
        从下往上弹出信息提示
    */
    func Li_popUpfrombottomWithText(text:String,parentView view:UIView){
        var frame:CGRect = DeviceFrame
        frame.origin.y = DeviceFrame.height+StatusBarFrame.height
        frame.size.height = 30
        var bottomView:UIView = UIView(frame:frame)
        bottomView.alpha = 0.8
        bottomView.backgroundColor = UIColor.greenColor()
        var label:UILabel = UILabel()
        label.frame = CGRectMake(10, 2, DeviceFrame.width-20, 25)
        label.text = text
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.systemFontOfSize(12.0)
        
        bottomView.addSubview(label)
        view.addSubview(bottomView)
        self.Li_bottomViewAnimatedPopupAndDown(bottomView)
    }
    
    /*
        从下往上弹出view
    */
    func Li_viewPopUpFromBottomView(bottomView:UIView,popupOnView view:UIView){

        fullScreenBlackView.frame = CGRectMake(0,StatusBarFrame.height+DeviceFrame.height,DeviceFrame.width,DeviceFrame.height)
        fullScreenBlackView.backgroundColor = UIColor(white:0.2, alpha:0.6)
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapAnimateDownWith:"))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        var frame:CGRect = DeviceFrame
        frame.origin.y = fullScreenBlackView.frame.height-bottomView.frame.height
        frame.size.width = bottomView.frame.width
        frame.size.height = bottomView.frame.height
        bottomView.backgroundColor = PopUpFromBottomBackgroundColor
        bottomView.frame = frame
        fullScreenBlackView.userInteractionEnabled = true
        fullScreenBlackView.addGestureRecognizer(tap)
        fullScreenBlackView.addSubview(bottomView)
        view.addSubview(fullScreenBlackView)

        self.Li_bottomViewAnimatedPopup(fullScreenBlackView)
    }
    
    
    /*
        bottomView是位于屏幕最底下刚好看不见的地方，在需要的时候弹出来，再收回去（一般用作提示）
    */
    func Li_bottomViewAnimatedPopupAndDown(bottomView:UIView){
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            var frame:CGRect = bottomView.frame
            frame.origin.y = frame.origin.y - frame.size.height
            bottomView.frame = frame
            }, completion: {(value:Bool) in
                UIView.animateWithDuration(0.5, delay: 2.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    var frame:CGRect = bottomView.frame
                    frame.origin.y = frame.origin.y + frame.size.height
                    bottomView.frame = frame
                    }, completion: {(value:Bool) in
                        
                    })
            })
    }
    
    /*
        bottomView弹出来
    */
    func Li_bottomViewAnimatedPopup(bottomView:UIView){
        UIView.animateWithDuration(0.3, animations: {
            var frame:CGRect = bottomView.frame
            frame.origin.y = frame.origin.y - frame.size.height
            bottomView.frame = frame
        })
    }
    
    /*
        bottomView收回去
    */
    func Li_bottomViewAnimatedDown(bottomView:UIView){
        UIView.animateWithDuration(0.3, animations: {
            var frame:CGRect = bottomView.frame
            frame.origin.y = frame.origin.y + frame.size.height
            bottomView.frame = frame
        })
    }
    
    /*
        将image存入沙盒
    */
    func Li_storageImgToDomain(image:UIImage)->String{
        let storeFilePath:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory:String = storeFilePath.objectAtIndex(0) as String
        var path:String = doucumentsDirectiory.stringByAppendingPathComponent(self.Li_detailTimeString())
        var result:Bool = UIImagePNGRepresentation(image).writeToFile(path, atomically:true)
        if result == false {
            println("Li_storageImgToDomain照片存入沙盒出错")
        }
        println(path)
        return path
    }
    
    /*
        #UIGestureRecognizerDelegate
        我在这里设置响应事件的优先级，因为UITap响应事件的优先级会高，则他的subview的事件会被阻止
    */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch!)->Bool{
        var view:UIView = gestureRecognizer.view
        if touch.view == view{
            return true
        }else{
            return false
        }
        
    }
    
    func tapAnimateDownWith(sender:UITapGestureRecognizer!){
        var fullScreenBlackView:UIView = (sender as UIGestureRecognizer).view
        self.Li_bottomViewAnimatedDown(fullScreenBlackView)
    }
    
    
    /*邮箱验证*/
    func isValidateEmail(email:String)->Bool{
//        let emailRegex:String = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
//        var emailtest:NSPredicate = NSPredicate(format:"name = \(emailRegex)",nil)
//        return emailtest.evaluateWithObject(email)
        return true
    }
    
}

















	