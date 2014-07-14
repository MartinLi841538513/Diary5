//
//  FaceCollectionViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-11.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

protocol FaceDelegate:NSObjectProtocol{
    func selectedFaceImgAction(imgName:String,view:UIView)
}

class FaceCollectionViewController: UICollectionViewController {

    var faceImgNames:NSMutableArray = NSMutableArray()
    var delegate:FaceDelegate!
    
    init(){
        var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(30,30)
        var paddingY:CGFloat = 10
        var paddingX:CGFloat = 10
        layout.sectionInset = UIEdgeInsetsMake(5,5,5,5)
        layout.minimumLineSpacing = paddingY
        layout.scrollDirection = .Vertical
        super.init(collectionViewLayout: layout)
        // Custom initialization
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.faceImgNames = faceImgNamesSet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func faceImgNamesSet()->NSMutableArray{
        var imgNames:NSMutableArray = NSMutableArray()
        var imgBaseName:String = "Expression_"
        for index in 1...60{
            var imgName:String = imgBaseName+String(index)
            imgNames.addObject(imgName)
        }
        return imgNames
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    // #pragma mark UICollectionViewDataSource


    override func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.faceImgNames.count
    }

    override func collectionView(collectionView: UICollectionView?, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell? {
        let cell = collectionView?.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        let row = indexPath.row
        let imgName:String = self.faceImgNames.objectAtIndex(row) as String
        // Configure the cell
        cell.backgroundView = UIImageView(image: UIImage(named: imgName))
        return cell
    }

    // pragma mark <UICollectionViewDelegate>

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView?, shouldHighlightItemAtIndexPath indexPath: NSIndexPath?) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        let row = indexPath.row
        let imgName:String = self.faceImgNames.objectAtIndex(row) as String
        self.delegate.selectedFaceImgAction(imgName,view:collectionView)
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView?, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath?) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView?, canPerformAction action: String?, forItemAtIndexPath indexPath: NSIndexPath?, withSender sender: AnyObject) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView?, performAction action: String?, forItemAtIndexPath indexPath: NSIndexPath?, withSender sender: AnyObject) {
    
    }
    */

}
