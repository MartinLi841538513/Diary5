//
//  SignUpViewController.swift
//  SwiftStudy3
//
//  Created by dongway on 14-7-12.
//  Copyright (c) 2014年 dongway. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet var nickname: UITextField
    var email:String = ""
    var password:String = ""
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
        self.nickname.becomeFirstResponder()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUp(sender: AnyObject) {
        var email = self.email
        var password = self.password
        var nickname = self.nickname.text
        self.userService.signUpWithNickname(nickname,andEmail:email,andPassword:password,andViewController:self)
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
