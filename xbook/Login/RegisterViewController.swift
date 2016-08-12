//
//  RegisterViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/12.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var topLayoutConstraint: NSLayoutConstraint!
    @IBAction func registerAction(sender: AnyObject) {
        let user = AVUser()
        
        user.username = self.username.text
        user.password = self.password.text
        user.email = self.email.text
        user.signUpInBackgroundWithBlock { (success, error) in
            if(success)
            {
                
                ProgressHUD.showSuccess("注册成功，请验证邮箱")
                
                self.dismissViewControllerAnimated(true) {
                    
                }
            }else{
                if error.code == 125{
                    ProgressHUD.showError("邮箱不合法")
                    
                }else if error.code == 203{
                    ProgressHUD.showError("该邮箱已经注册")
                    
                }else if error.code == 202{
                    ProgressHUD.showError("用户名已经存在")
                    
                }else {
                    ProgressHUD.showError("注册失败")
                    
                }
                
            }
    }
    }
    @IBAction func close(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action:Selector(hidKeyword()))
        self.view.addGestureRecognizer(gesture)
        
    }
    func hidKeyword(){
        self.username .resignFirstResponder()
        self.password.resignFirstResponder()
        self.email.resignFirstResponder()
    }
    func  keyboardWillShowNotification(notification:NSNotification)
    {
        UIView.animateWithDuration(0.3, animations:{()->Void in
            self.topLayoutConstraint.constant = -200
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    func  keyboardWillHideNotification(notification:NSNotification)
    {
        UIView.animateWithDuration(0.3, animations:{()->Void in
            self.topLayoutConstraint.constant = 8
            self.view.layoutIfNeeded()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
