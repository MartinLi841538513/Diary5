//
//  MapViewController.h
//  SwiftStudy3
//
//  Created by dongway on 14-7-9.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMapKit/MAMapKit.h"

@interface MapViewController : UIViewController<MAMapViewDelegate>

@property(nonatomic) MAMapView *mapView;
@property(nonatomic) double latitude;
@property(nonatomic) double longitude;

@end
