//
//  WeatherCollectionViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-11.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

let reuseIdentifier = "cell"

protocol WeatherDelegate:NSObjectProtocol{
    func selectedWeatherImgAction(imgName:String,view:UIView)
}

class WeatherCollectionViewController: UICollectionViewController {
    
    var imageNames:NSMutableArray = NSMutableArray()
    var delegate:WeatherDelegate!

    init(){
        var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(50,50)
        var paddingY:CGFloat = 10
        var paddingX:CGFloat = 10
        layout.sectionInset = UIEdgeInsetsMake(5,5,5,5)
        layout.minimumLineSpacing = paddingY
        layout.scrollDirection = .Vertical
        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.imageNames = self.weatherImgNamesSet()
    }

    func weatherImgNamesSet()->NSMutableArray{
        var imgNames:NSMutableArray = NSMutableArray()
        var imgBaseName:String = "weather"
        for index in 1...9{
            var imgName:String = imgBaseName+String(index)
            imgNames.addObject(imgName)
        }
        return imgNames
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.imageNames.count
    }

    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell? {
        let cell = collectionView!.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        let row = indexPath.row
        let imageName:String = self.imageNames.objectAtIndex(row) as String
        cell.backgroundView = UIImageView(image: UIImage(named: imageName))
        // Configure the cell
        return cell
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        let row = indexPath.row
        let imageName:String = self.imageNames.objectAtIndex(row) as String
        self.delegate.selectedWeatherImgAction(imageName,view:collectionView)
        return true
    }
}
