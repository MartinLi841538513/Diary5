//
//  DiaryModefyViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//
/*
    status:
    0:新增模式
    1:日记明细模式
    2:修改模式
*/
import UIKit
import CoreLocation

class DiaryModefyViewController: UIViewController,UIActionSheetDelegate,UIMenuBarDelegate,CLLocationManagerDelegate{
    
    @IBOutlet var dateButton : UIButton = nil
    @IBOutlet var content : UITextView = nil
    @IBOutlet var saveAndModefyButton : UIBarButtonItem = nil
    @IBOutlet var relocationButton: UIButton = nil
    var diary:Diary = Diary()
    let diaryService:DiaryService = DiaryService()
    let li_common:Li_common = Li_common()
    var menuBar:UIMenuBar = UIMenuBar()
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    var fontColor:UIColor = UIColor()
    var status:Int = 0
    

    var datePicker:UIDatePicker = UIDatePicker()
    var alertview:UIView! = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fontColor = self.dateButton.currentTitleColor
        
//        var layout:UICollectionViewLayout = UICollectionViewLayout()
//        var collectionView:UICollectionView = UICollectionView(frame: CGRectMake(10,10,300,400), collectionViewLayout: layout)
//        collectionView.registerClass(IconCollectionViewCell.self, forCellWithReuseIdentifier: "IconCollectionViewCell")
//        collectionView.registerNib(UINib(nibName:"IconCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "IconCollectionViewCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = UIColor.greenColor()
//        self.view.addSubview(collectionView)
        
        //0:日记新增模式  1:日记明细模式
        if self.status == 0{
            self.addModeSet()
        }else if self.status == 1{
            self.detailModeSet(self.diary)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int{
//        println("1")
//        return 10
//    }
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int{
//        println("4")
//        return 2
//    }
//    
//    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!{
//        println("3")
//        var identifier:String = "IconCollectionViewCell"
//        var cell:IconCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath:indexPath) as IconCollectionViewCell
//        cell.imageView = UIImageView(image: UIImage(named: "weather.png"))
//        return cell
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize{
//    println("2")
//        return CGSizeMake(96,100)
//    }
    
    //CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: AnyObject[]!){
        let thelocations:NSArray = locations as NSArray
        let location:CLLocation = thelocations.objectAtIndex(0) as CLLocation
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        if latitude != nil {
            self.diary.latitude = latitude
            self.diary.longitude = longitude
            var geocoder:CLGeocoder = CLGeocoder()
            var placemarks:NSArray?
            var error:NSError?
            geocoder.reverseGeocodeLocation(location, completionHandler:{(placemarks,error) in
                if error == nil && placemarks.count > 0{
                    var placemark:CLPlacemark = (placemarks as NSArray).objectAtIndex(0) as CLPlacemark
                    self.diary.detailAddress = "\(placemark.name)"
                    self.diary.address = "\(placemark.locality)\(placemark.subLocality)\(placemark.thoroughfare)"
                    var text:String = "位置:\(self.diary.address)"
                    self.li_common.Li_popUpfrombottomWithText(text,parentView:self.view)
                }
            })
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func date(sender : AnyObject) {
        var screen:UIScreen = UIScreen.mainScreen()
        var devicebounds:CGRect = screen.bounds
        var deviceWidth:CGFloat = devicebounds.width
        var deviceHeight:CGFloat = devicebounds.height
        var viewColor:UIColor = UIColor(white:0, alpha: 0.6)
        
        //设置日期弹出窗口
        alertview = UIView(frame:devicebounds)
        alertview.backgroundColor = viewColor
        alertview.userInteractionEnabled = true
        
        //设置datepicker
        datePicker.datePickerMode = .Date
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.frame = CGRect(x:10,y:deviceHeight-297,width:deviceWidth-10*2,height:216)
        
        //设置 确定 和 取消 按钮
        var li_common:Li_common = Li_common()
        var selectedButton:UIButton = li_common.Li_createButton("确定",x:10,y:deviceHeight-80,width:deviceWidth-10*2,height:35,target:self, action: Selector("selectedAction"))
        var cancelButton:UIButton = li_common.Li_createButton("取消",x:10,y:deviceHeight-40,width:deviceWidth-10*2,height:35,target:self, action: Selector("cancelAction"))
        
        alertview.addSubview(datePicker)
        alertview.addSubview(selectedButton)
        alertview.addSubview(cancelButton)
        
        self.view.addSubview(alertview)
    }
    
    
    //单击是定位，双击是地图模式
    func handleTapGesture(sender:UITapGestureRecognizer){
        let touchCount:Int = sender.numberOfTapsRequired
        switch touchCount {
        case 1:
            self.reLocationAction(self)
        case 2:
            self.goToMap(self)
        default:println("")
        }
    }
    
    //长按取消位置信息（出于对个别隐私用户的需求，增加功能）
    func cancelLocationInfo(sender:AnyObject){
        if self.status == 0||self.status == 2{
            self.diary.latitude = 0
            self.diary.longitude = 0
            self.diary.address = ""
            self.diary.detailAddress = ""
            LIProgressHUD.showSuccessWithStatus("消除位置信息成功")
        }
    }
    
    /*
        新增状态模式参数设置
    */
    func addModeSet(){
        self.status = 0
        self.basicModefyModeSet()
        //设置默认日期为今天
        var currentDate:String = self.li_common.Li_dateString(NSDate())
        self.dateButton.setTitle(currentDate, forState: UIControlState.Normal)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            self.reLocationAction(self)
        })
    }
    /*
         日记明细模式参数设置
    */
    func detailModeSet(diary:Diary){
        self.status = 1
        self.saveAndModefyButton.title = "更多"
        self.title = "日记详情"
        self.content.text = self.diary.content
        self.dateButton.setTitle(self.diary.date,forState:UIControlState.Normal)
        self.content.editable = false
        self.dateButton.enabled = false
        self.dateButton.setTitleColor(self.fontColor, forState: UIControlState.Normal)
        self.basicModeSet()
    }
    //修改状态模式参数设置
    func updateModeSet(){
        self.status = 2
        self.basicModefyModeSet()
    }
    func basicModefyModeSet(){
        self.saveAndModefyButton.title = "保存"
        self.title = "编辑日记"
        self.content.editable = true
        self.dateButton.enabled = true
        self.basicModeSet()
    }
    func basicModeSet(){
        //设置“定位”单击和双击的效果
        func setLocationButtonClickEvent(){
            var gr1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
            var gr2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
            var longTouch:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self,action:Selector("cancelLocationInfo:"))
            
            gr1.numberOfTapsRequired = 1
            gr1.requireGestureRecognizerToFail(gr2)//这里保证双击的时候不会出发单击时间
            gr2.numberOfTapsRequired = 2
            longTouch.minimumPressDuration = 1
            self.relocationButton.addGestureRecognizer(gr1)
            self.relocationButton.addGestureRecognizer(gr2)
            self.relocationButton.addGestureRecognizer(longTouch)
        }
        setLocationButtonClickEvent()
    }
    


    //单击“定位”或者获取位置信息
    func reLocationAction(sender: AnyObject) {
        //定位
        func locationAction(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 1000.0
            self.locationManager.startUpdatingLocation()
        }
        //打印位置信息
        func alertLocation(){
            if self.diary.latitude != 0 && self.diary.longitude != 0 {
                var text:String = "位置:\(self.diary.address)"
                self.li_common.Li_popUpfrombottomWithText(text,parentView:self.view)
            }else{
                var text:String = "那天不想定位"
                self.li_common.Li_popUpfrombottomWithText(text,parentView:self.view)
            }
        }
        
        switch self.status {
        case 0,2:
            locationAction()
        case 1:
            alertLocation()
        default:println("")
        }
        
        
    }
    
    //双击“定位”进入地图模式
    func goToMap(sender: AnyObject) {
        var mapViewController:MapViewController = MapViewController(nibName:nil, bundle:nil)
        self.navigationController.pushViewController(mapViewController,animated:true)
        println("双击进入地图模式")
    }

    /*
        0,2:点击保存
        1:点击更多
    */
    @IBAction func save(sender : AnyObject) {
        if self.status == 0{
            var diary:Diary = self.currentDiary()
            self.diaryService.addDiary(diary)
            self.diary = self.diaryService.theLatestDiary()//这样就能或得到diary的id，那么就可以根据id修改这片新增的日记
            self.detailModeSet(self.diary)
        }else if self.status == 1{
            var menuItem1:UIMenuBarItem = UIMenuBarItem(title:"编辑",target:self,image:UIImage(named:"modify.png"),action:Selector("modefyDiary:"))
            var menuItem2:UIMenuBarItem = UIMenuBarItem(title:"删除",target:self,image:UIImage(named:"modify.png"),action:Selector("deleteDiary:"))
            var menuItem3:UIMenuBarItem = UIMenuBarItem(title:"分享",target:self,image:UIImage(named:"modify.png"),action:Selector("shareDiary:"))
            var items:NSMutableArray = [menuItem1,menuItem2,menuItem3]
            self.menuBar = UIMenuBar(frame:CGRectMake(10, 0, self.view.bounds.size.width, 240.0) ,items:items)
            self.menuBar.delegate = self
            self.menuBar.items = items
            self.menuBar.show()
        }else if self.status == 2{
            var diary:Diary = self.currentDiary()
            self.diaryService.updateDiary(diary)
            self.detailModeSet(diary)
        }
    }
    
    //获取当前日记对象
    func currentDiary() ->Diary{
        var diary:Diary = Diary()
        diary = self.diary
        diary.date = dateButton.currentTitle
        diary.content = self.content.text
        return diary
    }
    
    /*
        编辑（修改）日记
    */
    func modefyDiary(sender:AnyObject){
        self.updateModeSet()
        self.menuBar.dismiss()
    }
    
    /*
        删除日记
    */
    func deleteDiary(sender:AnyObject){
        self.diaryService.deleteDiary(self.currentDiary())
        self.menuBar.dismiss()
        self.navigationController.popViewControllerAnimated(true)
    }
    
    /*
        分享日记
    */
    func shareDiary(sender:AnyObject){
        self.menuBar.dismiss()
    }
    

    
    //选择日期
    func selectedAction(){
        var dateString:String = self.li_common.Li_dateString(datePicker.date)
        dateButton.setTitle(dateString, forState: UIControlState.Normal)
        removeAlertview()
    }
    
    
    func cancelAction(){
        removeAlertview()
        println("取消")
    }
    
    func removeAlertview(){
        alertview.removeFromSuperview()
    }
    

   
}
