//
//  SetTableViewCell.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-14.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class SetTableViewCell: UITableViewCell {

    @IBOutlet var imageIcon: UIImageView
    @IBOutlet var title: UILabel
    @IBOutlet var textDetail: UILabel
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
