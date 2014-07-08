//
//  IconCollectionViewCell.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-8.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {

    @IBOutlet strong var imageView: UIImageView = UIImageView(image: UIImage(named: "weather.png"))
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
}
