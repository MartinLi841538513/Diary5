//
//  MapViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-9.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit
let DeviceFrame:CGRect = UIScreen.mainScreen().applicationFrame
let Latitude:Double = 28.1658601239483
let Longitude:Double = 112.947241748764

class MapViewController: UIViewController,MAMapViewDelegate{

    var mapView:MAMapView = MAMapView()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.mapView.frame = DeviceFrame
        self.mapView.showsUserLocation = true
        
        self.mapView.visibleMapRect = MAMapRectMake(220880104.0, 101476980.0,  9249.0, 13265.0);
        
        var annotations:NSMutableArray = NSMutableArray()
        var point1:MAPointAnnotation = MAPointAnnotation()
        point1.coordinate = CLLocationCoordinate2DMake(Latitude,Longitude)
        point1.title = "point1"
        annotations.addObject(point1)
        self.mapView.addAnnotations(annotations)
        
        
        
        self.view.addSubview(self.mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation:MAAnnotation!) -> MAAnnotationView!{
//        if annotation.isKindOfClass(MAPointAnnotation.self) == true {
//            var pointReuseIndetifier:String = "pointReuseIndetifier"
//            var annotationView:MAPinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(pointReuseIndetifier) as MAPinAnnotationView
//            if annotationView==nil{
//                annotationView = MAPinAnnotationView(annotation:annotation,reuseIdentifier:pointReuseIndetifier)
//                
//            }
//        }
        return nil
    }

}
