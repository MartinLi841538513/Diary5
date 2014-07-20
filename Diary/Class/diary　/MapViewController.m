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
{

}

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
    self.title = @"地图模式";
    self.mapView = [[MAMapView alloc] initWithFrame:DeviceFrame];
    self.mapView.delegate = self;
    self.mapView.visibleMapRect = MAMapRectMake(220880104.0, 101476980.0,  9249.0, 13265.0);

    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    MAPointAnnotation *point1 = [[MAPointAnnotation alloc] init];
    point1.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    point1.title = self.address;
    [annotations addObject:point1];
    [self.mapView addAnnotations:annotations];
    [self.mapView selectAnnotation:annotations[0] animated:YES];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);

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
            annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
            annotationView.animatesDrop = YES;       //设置标注动画显示，默认为NO
            annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
            annotationView.centerOffset = CGPointMake(-annotationView.frame.size.width/2, 0);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button addTarget:self action:@selector(annotationAction:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView=button;  //设置气泡右侧按钮
        }
        return annotationView;
    }
    return nil;
}

-(void)annotationAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
