//
//  MapViewController.m
//  SwiftStudy3
//
//  Created by dongway on 14-7-9.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

#import "MapViewController.h"

//此处坐标为长沙某地坐标
#define DeviceFrame [UIScreen mainScreen].applicationFrame
#define Latitude 28.1658601239483
#define Longitude 112.947241748764

@interface MapViewController ()

@end

@implementation MapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.mapView = [[MAMapView alloc] initWithFrame:DeviceFrame];
    self.mapView.delegate = self;
    self.mapView.visibleMapRect = MAMapRectMake(220880104.0, 101476980.0,  9249.0, 13265.0);
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(Latitude, Longitude);
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    MAPointAnnotation *point1 = [[MAPointAnnotation alloc] init];
    point1.coordinate = CLLocationCoordinate2DMake(Latitude, Longitude);
    [annotations addObject:point1];
    [self.mapView addAnnotations:annotations];
    
    [self.view addSubview:self.mapView];
    
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout= NO;      //设置气泡可以弹出，默认为NO
            annotationView.animatesDrop = YES;       //设置标注动画显示，默认为NO
            annotationView.draggable = NO;           //设置标注可以拖动，默认为NO
//            annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];  //设置气泡右侧按钮
        }
        return annotationView;
    }
    return nil;
}

@end
