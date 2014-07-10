//
//  Li_ImageViewer.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-10.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class Li_ImageViewer: UIView {
    
    var imageView:UIImageView!
    var lastScale:CGFloat!

    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        lastScale = 1.0
        
        self.backgroundColor = UIColor.blackColor()
        
        self.imageView = UIImageView()
        self.backgroundColor = UIColor.whiteColor()
        self.imageView.frame = CGRectMake(0,(DeviceFrame.height-DeviceFrame.width)/2,DeviceFrame.width,DeviceFrame.width)
        
        var gr1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        var gr2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        gr1.numberOfTapsRequired = 1
        gr1.requireGestureRecognizerToFail(gr2)//这里保证双击的时候不会出发单击时间
        gr2.numberOfTapsRequired = 2
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(gr1)
        self.imageView.addGestureRecognizer(gr2)
        
        var pin:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("handlePinchGesture:"))
        self.imageView.addGestureRecognizer(pin)
        
        
        self.addSubview(self.imageView)
    }
    
    /*
        单击self消失
        双击self.imageView放大和缩小
    */
    func handleTapGesture(sender:UITapGestureRecognizer){
        let touchCount:Int = sender.numberOfTapsRequired
        switch touchCount {
        case 1:
            dismiss()
        case 2:
            self.handleDoubleClick(sender)
        default:println("")
        }
    }
    
    /*
        手势：捏
    */
    func handlePinchGesture(sender:UIGestureRecognizer){
        var factor:CGFloat = (sender as UIPinchGestureRecognizer).scale
        sender.view.transform = CGAffineTransformMakeScale(factor
            , factor)
    }
    
    
    //self消失
    func dismiss(){
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.backgroundColor = UIColor(white:1, alpha: 0)
            self.imageView.alpha = 0
        }, completion: {(value:Bool) in
            self.removeFromSuperview()
        })
    }
    //双击放大和缩小
    func handleDoubleClick(sender:UIGestureRecognizer){
        //.ScaleAspectFit是原比例
        if sender.view.contentMode == .ScaleAspectFit {
            sender.view.contentMode = .Center
        }else{
            sender.view.contentMode = .ScaleAspectFit
        }
    }

}
