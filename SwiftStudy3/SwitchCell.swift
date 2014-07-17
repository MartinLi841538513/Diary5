//
//  SwitchTableViewCell.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-16.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit
protocol SwitchCellDelegate:NSObjectProtocol{
    func switchButtonAction(sender: AnyObject)
}

class SwitchCell: UITableViewCell {

    var delegate:SwitchCellDelegate!
    @IBOutlet var switchButton: UISwitch
    @IBOutlet var title: UILabel
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        self.switchButton.on = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchButtonAction(sender: AnyObject) {
        self.delegate.switchButtonAction(sender)
    }
    
    

}
