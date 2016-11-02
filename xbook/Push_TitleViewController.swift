//
//  Push_TitleViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/10.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit


typealias Push_TitleCallBack = (_ Title:String)->Void

class Push_TitleViewController: UIViewController {

    var textField:UITextField?
    var callBack:Push_TitleCallBack?
    
    /**
     参数传递
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.textField = UITextField(frame:CGRect(x: 15,y: 60,width: SCREEN_WIDTH - 30,height: 30))
        self.textField?.borderStyle = .roundedRect
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
        
        self.callBack?(self.textField!.text!)
        self.dismiss(animated: true) {
            
        }
    }
    func close()
    {
        self.dismiss(animated: true) { 
            
        }
    }

}
