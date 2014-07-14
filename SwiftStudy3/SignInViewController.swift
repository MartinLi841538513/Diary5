//
//  SignInViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-12.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit


class SignInViewController: UIViewController {

    
    @IBOutlet var email: UITextField
    @IBOutlet var password: UITextField
    @IBOutlet var registerButton: UILabel
    var userService:UserService = UserService()
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
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:Selector("register:"))
        self.registerButton.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        var email:String! = self.email.text
        var password:String = self.password.text
        self.userService.signInWithEmail(email,andPassword:password,andViewController:self)
    }
    
    func register(sender:AnyObject){
        var storyboard:UIStoryboard = UIStoryboard(name:"User",bundle:nil)
        var viewController:EmailViewController = storyboard.instantiateViewControllerWithIdentifier("EmailViewController") as EmailViewController
        self.navigationController.pushViewController(viewController, animated: true)
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
