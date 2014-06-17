//
//  ViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-12.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var textField1 : UITextField = nil
    @IBOutlet var label1 : UILabel = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(sender : AnyObject) {
        var text:String = self.textField1.text
        self.label1.text = text
    }

}

