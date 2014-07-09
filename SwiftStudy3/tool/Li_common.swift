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

class Li_common{
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
    
    //返回2014-06-19 String格式的日期
    func Li_dateString(date:NSDate) ->String{
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
        bottomView.backgroundColor = UIColor.greenColor()
        bottomView.alpha = 0.9
        
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
    
}

















	