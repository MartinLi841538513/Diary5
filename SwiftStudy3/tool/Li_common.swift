//
//  Li_common.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-18.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import Foundation
import UIKit

class LI_common{
    /*
    快速创建一种常用的button，state：normal，  backgroundcolor：white，  type：system    ControlEvents:TouchUpInside
    */
    func createButton(title:String!,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,target: AnyObject!, action: Selector) ->UIButton{
        var buttonRect:CGRect = CGRect(x:x, y:y, width:width, height:height)
        var button:UIButton = UIButton.buttonWithType(.System) as UIButton
        button.setTitle(title, forState: UIControlState.Normal)
        button.frame = buttonRect
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
}



	