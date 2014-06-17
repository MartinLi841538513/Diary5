//
//  DiaryModefyViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-6-13.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class DiaryModefyViewController: UIViewController {

    @IBOutlet var test : UILabel = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        test.text = "11"
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

}
