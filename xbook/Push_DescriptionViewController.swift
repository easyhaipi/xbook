//
//  Push_DescriptionViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/10.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit
typealias Push_DescriptionViewBlock = (_ description:String)->Void


class Push_DescriptionViewController: UIViewController {

    var textView:JVFloatLabeledTextView?
    var callBlock:Push_DescriptionViewBlock?
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.white
        
        self.textView = JVFloatLabeledTextView(frame: CGRect(x: 8, y: 58, width: SCREEN_WIDTH-16, height: SCREEN_HEIGHT-58-16)
        )
        self.view.addSubview(self.textView!)
        
        self.textView?.placeholder = "---撰写详细的评价，吐槽"
        self.view.tintColor = UIColor.gray
        self.textView?.becomeFirstResponder()
        
        self.textView?.font = UIFont(name: MY_FONT,size: 13)
        XKeyBoard.registerHide(self)
        XKeyBoard.registerShow(self)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func  keyboardWillShowNotification(_ notification:Notification)
    {
        let rect = XKeyBoard.returnWindow(notification)
        self.textView?.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height,0)
        
    }
    
    func  keyboardWillHideNotification(_ notification:Notification)
    {
     self.textView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func ok()
    {
        self.callBlock!((self.textView?.text)!)
        self.dismiss(animated: true) {
            
        }
    }
    func close()
    {
        self.dismiss(animated: true) {
            
        }
    }


}
