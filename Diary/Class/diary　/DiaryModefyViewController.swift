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

class DiaryModefyViewController: UIViewController,UIActionSheetDelegate,UIMenuBarDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, FaceDelegate,WeatherDelegate,UITextViewDelegate,Li_ImageViewerDelegate{
    
    @IBOutlet var dateView: UIView
    @IBOutlet var yearAndMonth: UILabel
    @IBOutlet var day: UILabel
    @IBOutlet var weekday: UILabel
    
    @IBOutlet var faceImageView: UIImageView = nil
    @IBOutlet var weatherImageView: UIImageView = nil
    @IBOutlet var content : UITextView = nil
    @IBOutlet var saveAndModefyButton : UIBarButtonItem = nil
    
    @IBOutlet var locateView: UIImageView
    
    @IBOutlet var photo: UIImageView = nil
    @IBOutlet var takePhotoButton: UIImageView = nil
    var diary:Diary = Diary()
    let diaryService:DiaryService = DiaryService()
    let li_common:Li_common = Li_common()
    var menuBar:UIMenuBar = UIMenuBar()
    var userDefault:UserDefault = UserDefault()
    var locationManager:CLLocationManager = CLLocationManager()
    var fontColor:UIColor = UIColor()
    var status:Int = 0
    var datePicker:UIDatePicker = UIDatePicker()
    var alertview:UIView! = UIView()
    var keyboardHeaderView:UIView = UIView()
    var weatherCollectionViewController:WeatherCollectionViewController = WeatherCollectionViewController()
    var faceCollectionViewController:FaceCollectionViewController = FaceCollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

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
    
    
    //#pragma mark - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: AnyObject[]!){
        let thelocations:NSArray = locations as NSArray
        let location:CLLocation = thelocations.objectAtIndex(0) as CLLocation
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        if latitude != nil {
            LIProgressHUD.showSuccessWithStatus("定位成功")
            self.diary.latitude = latitude
            self.diary.longitude = longitude
            var geocoder:CLGeocoder = CLGeocoder()
            var placemarks:NSArray?
            var error:NSError?
            geocoder.reverseGeocodeLocation(location, completionHandler:{(placemarks,error) in
                if error == nil && placemarks.count > 0{
                    let placemark:CLPlacemark = (placemarks as NSArray).objectAtIndex(0) as CLPlacemark
                    let name:String = placemark.name != nil ? placemark.name : ""
                    let locality:String = placemark.locality != nil ? placemark.locality : ""
                    let subLocality:String = placemark.subLocality != nil ? placemark.subLocality : ""
                    let thoroughfare:String = placemark.thoroughfare != nil ? placemark.thoroughfare : ""

                    self.diary.detailAddress = "\(name)"
                    self.diary.address = "\(locality)\(subLocality)\(thoroughfare)"
                    var text:String = "位置:\(self.diary.address)"
                    self.li_common.Li_popUpfrombottomWithText(text,parentView:self.view)
                    println(placemark)
                }
            })
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    //#pragma mark -UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        if image != nil {
            println("成功")
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!){
        var image:UIImage!
        if picker.allowsEditing {
            image = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        }else{
            image = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        }
    UIImageWriteToSavedPhotosAlbum(image,self,Selector("imageDidFinishSavingWithErrorContextInfo:error:contextInfo:"),nil) //这是存到了手机图库
        let imagePath:String = self.li_common.Li_storageImgToDomain(image)  //这是存到了沙盒
        self.diary.photos = imagePath
        self.imageDidFinishSaving(imagePath)
        self.dismissModalViewControllerAnimated(true)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!){
        self.dismissModalViewControllerAnimated(true)
    }
    
    
    func imageDidFinishSaving(path:String){
        var image:UIImage = UIImage(contentsOfFile:path)
        self.photo.image = image
        self.takePhotoButton.hidden = true
        println("saved to domain successed")
    }
    
    func imageDidFinishSavingWithErrorContextInfo(image:UIImage!,error:NSErrorPointer,contextInfo:CMutableVoidPointer){
        if error != nil {
            println("saved to album successed")
        }else{
            println(error)
        }
    }

    /*
        #FaceDelegate
    */
    func selectedFaceImgAction(imgName:String,view:UIView){
        
        self.li_common.Li_bottomViewAnimatedDown(view.superview.superview)
        self.faceImageView.image = UIImage(named:imgName)
        self.diary.mood = self.diaryService.translateExpressWithImageName(imgName)
    }
    
    /*
        #WeatherDelegate
    */
    func selectedWeatherImgAction(imgName:String,view:UIView){
        self.li_common.Li_bottomViewAnimatedDown(view.superview.superview)
        self.weatherImageView.image = UIImage(named:imgName)
        self.diary.weather = self.diaryService.translateWeatherWithImageName(imgName)
    }
    
    /*
        #UITextViewDelegate
    */
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool{
        if textView.text == "写点啥记录今天的心情吧..."{
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        return true
    }
    
    /*
        #Li_ImageViewerDelegate
    */
    func imageSuccessReturn(){
        self.navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    func date(sender : AnyObject) {
        func produceAlertView(){
            var screen:UIScreen = UIScreen.mainScreen()
            var devicebounds:CGRect = screen.bounds
            var deviceWidth:CGFloat = devicebounds.width
            var deviceHeight:CGFloat = devicebounds.height
            var viewColor:UIColor = UIColor(white:0, alpha: 0.6)
            
            //设置日期弹出窗口
            alertview = UIView(frame:CGRectMake(0,devicebounds.height,devicebounds.width,devicebounds.height))
            alertview.backgroundColor = viewColor
            alertview.userInteractionEnabled = true
            var tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:Selector("cancelAction:"))
            alertview.addGestureRecognizer(tap)
            //设置datepicker
            datePicker.datePickerMode = .Date
            datePicker.backgroundColor = UIColor.whiteColor()
            datePicker.frame = CGRect(x:10,y:deviceHeight-297,width:deviceWidth-10*2,height:216)
            
            //设置 确定 和 取消 按钮
            var li_common:Li_common = Li_common()
            var selectedButton:UIButton = li_common.Li_createButton("确定",x:10,y:deviceHeight-80,width:deviceWidth-10*2,height:35,target:self, action: Selector("selectedAction:"))
            var cancelButton:UIButton = li_common.Li_createButton("取消",x:10,y:deviceHeight-40,width:deviceWidth-10*2,height:35,target:self, action: Selector("cancelAction:"))
            
            alertview.addSubview(datePicker)
            alertview.addSubview(selectedButton)
            alertview.addSubview(cancelButton)
            
            self.view.addSubview(alertview)
        }
        self.content.resignFirstResponder()
        produceAlertView()
        self.li_common.Li_bottomViewAnimatedPopup(alertview)
    }
    
    /*
        天气
    */
    func weatherAction(sender: AnyObject) {
        self.content.resignFirstResponder()
        func weatherIconsSelect(){
            self.weatherCollectionViewController.view.frame = CGRectMake(0,0,DeviceFrame.size.width,200)
            self.li_common.Li_viewPopUpFromBottomView(self.weatherCollectionViewController.view,popupOnView:self.view)
        }
        
        switch self.status{
        case 0,2:
            weatherIconsSelect()
        default:println("")
        }
    }
    
    /*
        表情
    */
    func FaceSelectAction(sender: AnyObject) {
        self.content.resignFirstResponder()
        func faceIconsSelect(){
            self.faceCollectionViewController.view.frame = CGRectMake(0,0,DeviceFrame.size.width,200)
            self.li_common.Li_viewPopUpFromBottomView(self.faceCollectionViewController.view,popupOnView:self.view)
        }
        switch self.status{
        case 0,2:
            faceIconsSelect()
        default:println("")
        }
    }
    
    /*
        天气
    */
    func weatherSelectAction(sender:AnyObject){
        self.content.resignFirstResponder()

        func weatherIconsSelect(){
            self.weatherCollectionViewController.view.frame = CGRectMake(0,0,DeviceFrame.size.width,200)
            self.li_common.Li_viewPopUpFromBottomView(self.weatherCollectionViewController.view,popupOnView:self.view)
        }
        switch self.status{
        case 0,2:
            weatherIconsSelect()
        default:println("")
        }

    }
    
    //单击是定位，双击是地图模式
    func handleTapGesture(sender:UITapGestureRecognizer){
        self.content.resignFirstResponder()
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
        self.content.resignFirstResponder()
        if self.status == 0||self.status == 2{
            self.diary.latitude = 0
            self.diary.longitude = 0
            self.diary.address = ""
            self.diary.detailAddress = ""
            LIProgressHUD.showSuccessWithStatus("消除位置信息成功")
        }
    }
    
    /*
        从相册中选择照片或者浏览照片
    */
    func selectPhotoFromAlbumOrBrowsePhoto(sender:AnyObject!){
        self.content.resignFirstResponder()

        switch self.status {
        case 0,2:
            self.selectPhotoFromAlbum()
        case 1:
            self.browsePhoto()
        default:
            println("")
        }
    }
    
    //从相册中选择照片
    func selectPhotoFromAlbum(){

        var imageController:UIImagePickerController = UIImagePickerController()
        imageController.sourceType = .PhotoLibrary
        imageController.videoMaximumDuration = 10.0
        imageController.allowsEditing = true
        imageController.delegate = self
        self.presentViewController(imageController,animated:true,completion:nil) //貌似说只能以模态形式展示
        println("从相册中选择照片")
    }
    
    //浏览照片
    func browsePhoto(){
        let li_ImageViewer:Li_ImageViewer = Li_ImageViewer(frame:self.photo.frame)
        li_ImageViewer.delegate = self
        let image:UIImage = UIImage(contentsOfFile:self.diary.photos)
        if image != nil{
            li_ImageViewer.imageView.image = image
        }else{
            li_ImageViewer.imageView.image = UIImage(named:"DongWay76")
        }
        self.view.addSubview(li_ImageViewer)
        UIView.animateWithDuration(0.2, animations:{
            li_ImageViewer.frame = CGRect(x: 0,y: 0,width: DeviceFrame.width,height: DeviceFrame.height+StatusBarFrame.height)
            li_ImageViewer.imageView.frame = CGRectMake(0,(li_ImageViewer.frame.height-li_ImageViewer.frame.width)/2,li_ImageViewer.frame.width,li_ImageViewer.frame.width)
            li_ImageViewer.backgroundColor = UIColor.blackColor()
        })
        self.navigationController.setNavigationBarHidden(true, animated: true)
        
        println("浏览照片")
    }
    
    /*
        拍照
    */
    func takePhoto(sender:AnyObject!){
        func takePhotoAction(){
            var imageController:UIImagePickerController = UIImagePickerController()
            imageController.sourceType = .Camera
            imageController.videoQuality = .TypeHigh
            imageController.videoMaximumDuration = 10.0
            imageController.allowsEditing = true
            imageController.delegate = self
            self.presentViewController(imageController,animated:true,completion:nil) //貌似说只能以模态形式展示
        }
        switch self.status {
        case 0,2:
            takePhotoAction()
        default:
            println("")
        }
    }
    
    /*
        拍视频以及播放视频
    */
    func takeOrBrowerMovie(sender:AnyObject!){
        println("拍视频以及播放视频")
    }
    
    /*
        新增状态模式参数设置
    */
    func addModeSet(){
        self.status = 0
        self.basicModefyModeSet()
        //设置默认日期为今天
        var date:NSDate = NSDate()
        var dateTuple:(String,String,String,String) = self.diaryService.tupleFromDate(date)
        self.setDateViewWithDateTuple(dateTuple)
        self.diary.date = self.diaryService.dateStringFromDate(date)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            self.reLocationAction(self)
        })
    }
    
    /*
         日记明细模式参数设置
    */
    func detailModeSet(diary:Diary){

        self.basicModeSet()
        
        self.takePhotoButton.hidden = true
        self.dateView.userInteractionEnabled = false
        self.status = 1
        self.saveAndModefyButton.title = "更多"
        self.title = "日记详情"
        self.content.text = self.diary.content
        self.content.backgroundColor = self.view.backgroundColor
        self.content.textColor = UIColor.blackColor()
        let dateTuple:(String,String,String,String) = self.diaryService.tupleFromDateString(self.diary.date)
        self.setDateViewWithDateTuple(dateTuple)
        self.content.editable = false
        self.faceImageView.image = UIImage(named:self.diaryService.translateExpressWithWords(self.diary.mood))
        self.weatherImageView.image = UIImage(named:self.diaryService.translateWeatherWithWords(self.diary.weather
            ))
        
        let image:UIImage = UIImage(contentsOfFile:self.diary.photos)
        if image != nil {
            self.photo.image = image
        }else{
            self.photo.image = UIImage(named:self.diary.photos)
        }
    }
    //修改状态模式参数设置
    func updateModeSet(){
        self.status = 2
        self.basicModefyModeSet()
    }
    func basicModefyModeSet(){

        self.basicModeSet()
        self.saveAndModefyButton.title = "保存"
        self.title = "编辑日记"
        self.content.editable = true
        self.content.backgroundColor = UIColor.whiteColor()
        self.dateView.userInteractionEnabled = true
    }
    func basicModeSet(){
        
        func setDateViewClickeEvent(){
            var gr1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("date:"))
            self.dateView.userInteractionEnabled = true
            self.dateView.addGestureRecognizer(gr1)
        }
        //设置“定位”单击和双击的效果
        func setLocationButtonClickEvent(){
            var gr1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
            var gr2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
            var longTouch:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self,action:Selector("cancelLocationInfo:"))
            
            gr1.numberOfTapsRequired = 1
            gr1.requireGestureRecognizerToFail(gr2)//这里保证双击的时候不会出发单击时间
            gr2.numberOfTapsRequired = 2
            longTouch.minimumPressDuration = 1
            self.locateView.addGestureRecognizer(gr1)
            self.locateView.addGestureRecognizer(gr2)
            self.locateView.addGestureRecognizer(longTouch)
        }
        //设置照片的单击双击和长按效果。单击从相册选择相片或者浏览照片
        func setPhotoButton(){
            var photogr1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("selectPhotoFromAlbumOrBrowsePhoto:"))
            var takePhotoButtongr1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("selectPhotoFromAlbumOrBrowsePhoto:"))
            var photogr2:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:Selector("takePhoto:"))
            var takePhotoButtongr2:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:Selector("takePhoto:"))
            var photolongTouch:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self,action:Selector("takeOrBrowerMovie:"))
            var takePhotoButtonlongTouch:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self,action:Selector("takeOrBrowerMovie:"))
            photogr1.numberOfTapsRequired = 1
            takePhotoButtongr1.numberOfTapsRequired = 1
            photogr2.numberOfTapsRequired = 2
            takePhotoButtongr2.numberOfTapsRequired = 2
            photogr1.requireGestureRecognizerToFail(photogr2)
            takePhotoButtongr1.requireGestureRecognizerToFail(takePhotoButtongr2)
            self.photo.addGestureRecognizer(photogr1)
            self.takePhotoButton.addGestureRecognizer(takePhotoButtongr1)
            self.photo.addGestureRecognizer(photogr2)
            self.takePhotoButton.addGestureRecognizer(takePhotoButtongr2)
            self.photo.addGestureRecognizer(photolongTouch)
            self.takePhotoButton.addGestureRecognizer(takePhotoButtonlongTouch)
        }
        
        func faceIconEventSet(){
            var faceTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("FaceSelectAction:"))
            self.faceImageView.addGestureRecognizer(faceTap1)
            self.faceCollectionViewController.delegate = self
        }
        func weatherIconEventSet(){
            var weatherTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("weatherSelectAction:"))
            self.weatherImageView.addGestureRecognizer(weatherTap1)
            self.weatherCollectionViewController.delegate = self
        }
        
        func contentEventSet(){
            self.content.delegate = self
            var frame:CGRect = self.content.frame
            frame.size.height = DeviceFrame.height+StatusBarFrame.height-frame.origin.y-10
            self.content.frame = frame
        }
        func listenKeyboard(){
            NSNotificationCenter.defaultCenter().addObserver(self,selector:Selector("keyboardWillShow:"),name:UIKeyboardWillShowNotification,object:nil)
            NSNotificationCenter.defaultCenter().addObserver(self,selector:Selector("keyboardWillHide:"),name:UIKeyboardWillHideNotification,object:nil)
        }
        
        func keyboardHeader(){
            self.keyboardHeaderView.frame = CGRect(x: 0,y: DeviceFrame.height+StatusBarFrame.height,width: DeviceFrame.width,height: 30)
            self.keyboardHeaderView.backgroundColor = UIColor(white:0, alpha: 0.6)
            var hiddenKeyBoardLabel:UILabel = UILabel(frame:CGRect(x:0,y:0,width:DeviceFrame.width-10,height:30))
            hiddenKeyBoardLabel.text = "完成"
            hiddenKeyBoardLabel.textColor = UIColor.blueColor()
            hiddenKeyBoardLabel.textAlignment = .Right
            
            var tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:Selector("hideKeyboard:"))
            self.keyboardHeaderView.userInteractionEnabled = true
            self.keyboardHeaderView.addGestureRecognizer(tap)
            
            self.keyboardHeaderView.addSubview(hiddenKeyBoardLabel)
            self.view.addSubview(self.keyboardHeaderView)
        }
        
        setDateViewClickeEvent()
        setLocationButtonClickEvent()
        setPhotoButton()
        faceIconEventSet()
        weatherIconEventSet()
        contentEventSet()
        listenKeyboard()
        keyboardHeader()
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
        mapViewController.latitude = self.currentDiary().latitude as Double
        mapViewController.longitude = self.currentDiary().longitude as Double
        mapViewController.address = self.currentDiary().address as NSString
        println(self.currentDiary().address)
        println("双击进入地图模式")
    }

    /*
        0,2:点击保存
        1:点击更多
    */
    @IBAction func save(sender : AnyObject) {
        if self.status == 0{
            var diary:Diary = self.currentDiary()
            var result:(Bool,Diary) = self.diaryService.addDiary(diary)
            if result.0==true{
                LIProgressHUD.showSuccessWithStatus("保存成功")
                self.diary = result.1
            }else{
                LIProgressHUD.showErrorWithStatus("添加失败")
            }
            self.detailModeSet(self.diary)
        }else if self.status == 1{
            var menuItem1:UIMenuBarItem = UIMenuBarItem(title:"编辑",target:self,image:UIImage(named:"modify.png"),action:Selector("modefyDiary:"))
            var menuItem2:UIMenuBarItem = UIMenuBarItem(title:"删除",target:self,image:UIImage(named:"delete.png"),action:Selector("deleteDiary:"))
//            var menuItem3:UIMenuBarItem = UIMenuBarItem(title:"分享",target:self,image:UIImage(named:"modify.png"),action:Selector("shareDiary:"))
            var items:NSMutableArray = [menuItem1,menuItem2]
            self.menuBar = UIMenuBar(frame:CGRectMake(10, 0, self.view.bounds.size.width, 240.0) ,items:items)
            self.menuBar.delegate = self
            self.menuBar.items = items
            self.menuBar.show()
        }else if self.status == 2{
            var diary:Diary = self.currentDiary()
            var result:(Bool,Diary) = self.diaryService.updateDiary(diary)
            if result.0==true{
                LIProgressHUD.showSuccessWithStatus("修改成功")
                self.diary = result.1
            }else{
                LIProgressHUD.showErrorWithStatus("修改失败")
            }
            self.detailModeSet(diary)
        }
    }
    
    //获取当前日记对象
    func currentDiary() ->Diary{
        var diary:Diary = Diary()
        diary = self.diary
        diary.content = self.content.text
        diary.userId = self.userDefault.userId()
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
        self.menuBar.dismiss()
        self.diaryService.deleteDiary(self.currentDiary(),inViewController:self)
    }
    
    /*
        分享日记
    */
    func shareDiary(sender:AnyObject){
        self.menuBar.dismiss()
    }
    

    
    //选择日期
    func selectedAction(sender:AnyObject!){
        let dateString:String = self.diaryService.dateStringFromDate(datePicker.date)
        let dateTuple:(String,String,String,String) = self.diaryService.tupleFromDateString(dateString)
        self.diary.date = dateString
        self.setDateViewWithDateTuple(dateTuple)
        removeAlertview()
    }
    
    
    func cancelAction(sender:AnyObject!){
        removeAlertview()
        println("取消")
    }
    
    func removeAlertview(){
        UIView.animateWithDuration(0.4, animations:{
            var frame:CGRect = self.alertview.frame
            frame.origin.y = frame.origin.y + frame.size.height
            self.alertview.frame = frame
        }, completion:{(value:Bool) in
            self.alertview.removeFromSuperview()
        })
    }
    
    //设置日期
    func setDateViewWithDateTuple(dateTuple:(String,String,String,String)){
        self.yearAndMonth.text = "\(dateTuple.0)年\(dateTuple.1)月"
        self.day.text = dateTuple.2
        self.weekday.text = dateTuple.3
    }
    
    //Keyboard will show
    func keyboardWillShow(sender:NSNotification){
        let userInfo = sender.userInfo
        let keyboardInfo : (AnyObject!) = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
        let keyboardRect:CGRect = keyboardInfo.CGRectValue() as CGRect
        let height = keyboardRect.size.height as Float
        
        UIView.animateWithDuration(0.2, animations: {
            var y:Float = DeviceFrame.height+StatusBarFrame.height - height-self.keyboardHeaderView.frame.height
            self.keyboardHeaderView.frame = CGRect(x: 0,y: y,width: DeviceFrame.width,height: 30)
            
            var frame:CGRect = self.content.frame
            frame.size.height = self.keyboardHeaderView.frame.origin.y-frame.origin.y
            self.content.frame = frame
        })
    }
    
    //keyboard will hide
    func keyboardWillHide(sender:NSNotification){
        UIView.animateWithDuration(0.2, animations: {
            self.keyboardHeaderView.frame = CGRect(x: 0,y: DeviceFrame.height+StatusBarFrame.height,width: DeviceFrame.width,height: 30)
            var frame:CGRect = self.content.frame
            frame.size.height = self.keyboardHeaderView.frame.origin.y-frame.origin.y-10
            self.content.frame = frame
        })
    }
    
    //hide keyboard
    func hideKeyboard(sender:AnyObject){
        self.content.resignFirstResponder()
    }
   
}
