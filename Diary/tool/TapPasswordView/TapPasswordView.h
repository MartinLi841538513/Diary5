//
//  DiaryModefyViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapPasswordViewDelegate <NSObject>

@optional
-(void)touchendActionWithPassword:(NSString *)password;

@end

@interface TapPasswordView : UIView{

    NSMutableArray *mutalearray;
     NSMutableArray *mutag;
    CGPoint curentpoint;
    UITextField *resulttext;
    
}

@property (nonatomic,assign) id<TapPasswordViewDelegate> delegate;
@end
