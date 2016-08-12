//
//  LoginViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/12.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController ,UIGestureRecognizerDelegate{
    @IBOutlet var topLayoutConstraint: NSLayoutConstraint!

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBAction func login(sender: AnyObject) {
        
        
        AVUser.logInWithUsernameInBackground(self.username.text, password: self.password.text){(user,error)->Void in
        
            if error==nil{
                ProgressHUD.showSuccess("登录成功")
                self.dismissViewControllerAnimated(true, completion: { 
                    
                })
            }else{
                if error.code == 210{
                    ProgressHUD.showError("用户名密码不匹配")
                    
                }else if error.code == 211{
                    ProgressHUD.showError("不存在该用户")
                    
                }else if error.code == 216{
                    ProgressHUD.showError("未验证邮箱")
                    
                }else if error.code==1{
                    ProgressHUD.showError("操作频繁")
                    
                }else{
                    ProgressHUD.showError("登录失败")
                }
            }
        }
        
      
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hidKeyword))
     
        self.view.addGestureRecognizer(tapGesture)
        
        
     
    }
    func hidKeyword(){
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
      
        return touch.view == gestureRecognizer.view
    
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
