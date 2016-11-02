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
    @IBAction func registerAction(_ sender: AnyObject) {
        let user = AVUser()
        
        user.username = self.username.text
        user.password = self.password.text
        user.email = self.email.text
        user.signUpInBackground { (success, error) in
            if(success)
            {
                
                ProgressHUD.showSuccess("注册成功，请验证邮箱")
                
                
                
                self.dismiss(animated: true) {
                    
                }
            }else{
                if error?._code == 125{
                    ProgressHUD.showError("邮箱不合法")
                    
                }else if error?._code == 203{
                    ProgressHUD.showError("该邮箱已经注册")
                    
                }else if error?._code == 202{
                    ProgressHUD.showError("用户名已经存在")
                    
                }else {
                    ProgressHUD.showError("注册失败")
                    
                }
                
            }
    }
    }
    @IBAction func close(_ sender: AnyObject) {
        
        self.dismiss(animated: true) { 
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action:#selector(RegisterViewController.hidKeyword))
        self.view.addGestureRecognizer(gesture)
        
    }
    func hidKeyword(){
        self.username .resignFirstResponder()
        self.password.resignFirstResponder()
        self.email.resignFirstResponder()
    }
    func  keyboardWillShowNotification(_ notification:Notification)
    {
        UIView.animate(withDuration: 0.3, animations:{()->Void in
            self.topLayoutConstraint.constant = -200
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    func  keyboardWillHideNotification(_ notification:Notification)
    {
        UIView.animate(withDuration: 0.3, animations:{()->Void in
            self.topLayoutConstraint.constant = 8
            self.view.layoutIfNeeded()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
