//
//  Li_ImageViewer.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-10.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

protocol Li_ImageViewerDelegate:NSObjectProtocol{
    func imageSuccessReturn()
}

class Li_ImageViewer: UIView {
    
    var imageView:UIImageView! = UIImageView()
    var delegate:Li_ImageViewerDelegate!
    var pastFrame:CGRect!
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.pastFrame = frame
        self.backgroundColor = UIColor.blackColor()
        
        self.backgroundColor = UIColor.whiteColor()
        self.imageView.frame = CGRectMake(0,(self.frame.height-self.frame.width)/2,self.frame.width,self.frame.width)
        
        var gr1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        var gr2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
        var gr3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismiss"))
        gr1.numberOfTapsRequired = 1
        gr1.requireGestureRecognizerToFail(gr2)//这里保证双击的时候不会出发单击时间
        gr2.numberOfTapsRequired = 2
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(gr1)
        self.imageView.addGestureRecognizer(gr2)
        self.userInteractionEnabled = true
        self.addGestureRecognizer(gr3)
        var pin:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("handlePinchGesture:"))
        self.imageView.addGestureRecognizer(pin)
        
        var pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target:self,action:Selector("move:"))
        self.imageView.addGestureRecognizer(pan)
        
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
        self.delegate.imageSuccessReturn()
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.frame = self.pastFrame
            self.imageView.frame = CGRectMake(0,(self.frame.height-self.frame.width)/2,self.frame.width,self.frame.width)
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
    
    //移动
    func move(sender:UIPanGestureRecognizer){
        var translatedPoint:CGPoint = sender.translationInView(self.imageView)
        println("\(translatedPoint.x)  \(translatedPoint.y)")
        sender.view.center = CGPointMake(sender.view.center.x+translatedPoint.x,sender.view.center.y+translatedPoint.y)
        sender.setTranslation(CGPointMake(0,0),inView:self.imageView)
    }

}
