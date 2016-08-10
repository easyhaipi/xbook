//
//  Push_TitleViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/10.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit


typealias Push_TitleCallBack = (Title:String)->Void

class Push_TitleViewController: UIViewController {

    var textField:UITextField?
    var callBack:Push_TitleCallBack?
    
    /**
     参数传递
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor .whiteColor()
        
        self.textField = UITextField(frame:CGRectMake(15,60,SCREEN_WIDTH - 30,30))
        self.textField?.borderStyle = .RoundedRect
        self.textField?.placeholder = "书评标题"
        self.textField?.font = UIFont(name:MY_FONT,size: 12)
        self.view.addSubview(self.textField!)
        
        self.textField?.becomeFirstResponder()
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func ok()
    {
        
        self.callBack?(Title:self.textField!.text!)
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    func close()
    {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

}
