//
//  PasswordViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-12.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet var password: UITextField
    var email:String = ""
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextStep(sender: AnyObject) {
        var password:NSString = self.password.text
        if password.length > 5{
            var storyboard:UIStoryboard = UIStoryboard(name:"User",bundle:nil)
            var viewController:ConfirmPasswordViewController = storyboard.instantiateViewControllerWithIdentifier("ConfirmPasswordViewController") as ConfirmPasswordViewController
            viewController.email = self.email
            viewController.password = self.password.text
            self.navigationController.pushViewController(viewController, animated: true)
        }else{
            LIProgressHUD.showErrorWithStatus("密码长度至少6位")
        }
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
