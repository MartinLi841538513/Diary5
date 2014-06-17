//
//  DiaryCell.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class DiaryCell: UITableViewCell {

    @IBOutlet var weather : UIImageView = nil
    @IBOutlet var photo : UIImageView = nil
    @IBOutlet var locate : UIImageView = nil
    @IBOutlet var voice : UIImageView = nil
    @IBOutlet var photoImg : UIImageView = nil
    @IBOutlet var diaryContent : UILabel = nil
    @IBOutlet var time : UILabel = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
