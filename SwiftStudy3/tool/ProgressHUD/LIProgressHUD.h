//
//  LIProgressHUD.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/LIProgressHUD
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

extern NSString * const LIProgressHUDDidReceiveTouchEventNotification;
extern NSString * const LIProgressHUDWillDisappearNotification;
extern NSString * const LIProgressHUDDidDisappearNotification;

extern NSString * const LIProgressHUDStatusUserInfoKey;

enum {
    LIProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    LIProgressHUDMaskTypeClear, // don't allow
    LIProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    LIProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger LIProgressHUDMaskType;

@interface LIProgressHUD : UIView

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
@property (readwrite, nonatomic, retain) UIColor *hudBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, retain) UIColor *hudForegroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, retain) UIColor *hudStatusShadowColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, retain) UIFont *hudFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, retain) UIImage *hudSuccessImage NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, retain) UIImage *hudErrorImage NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
#endif

+ (void)show;
+ (void)showWithMaskType:(LIProgressHUDMaskType)maskType;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(LIProgressHUDMaskType)maskType;

+ (void)showProgress:(CGFloat)progress;
+ (void)showProgress:(CGFloat)progress status:(NSString*)status;
+ (void)showProgress:(CGFloat)progress status:(NSString*)status maskType:(LIProgressHUDMaskType)maskType;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

// stops the activity indicator, shows a glyph + status, and dismisses HUD 1s later
+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showImage:(UIImage*)image status:(NSString*)status; // use 28x28 white pngs

+ (void)popActivity;
+ (void)dismiss;

+ (BOOL)isVisible;

+(void)addActivityView:(UIActivityIndicatorView *)activityView toViewController:(UIViewController *)viewController;
+(void)addActivityView:(UIActivityIndicatorView *)activityView toView:(UIScrollView *)view;

+(void)removeActivityView:(UIActivityIndicatorView *)activityView;

@end
