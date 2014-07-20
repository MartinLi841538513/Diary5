//
//  EmailViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-12.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {

    @IBOutlet var email: UITextField
    let li_common:Li_common = Li_common()
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.email.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextStep(sender: AnyObject) {
        let email:String = self.email.text
        if self.li_common.isValidateEmail(email) == false{
            LIProgressHUD.showErrorWithStatus("邮箱格式不正确")
        }else if UserService().databaseContainsEmail(email){
            LIProgressHUD.showErrorWithStatus("邮箱已注册")
        }else{
            var storyboard:UIStoryboard = UIStoryboard(name:"User",bundle:nil)
            var viewController:PasswordViewController = storyboard.instantiateViewControllerWithIdentifier("PasswordViewController") as PasswordViewController
            viewController.email = email
            self.navigationController.pushViewController(viewController, animated: true)
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
