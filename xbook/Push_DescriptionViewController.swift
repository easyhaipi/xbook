//
//  Push_DescriptionViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/10.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit
typealias Push_DescriptionViewBlock = (description:String)->Void


class Push_DescriptionViewController: UIViewController {

    var textView:JVFloatLabeledTextView?
    var callBlock:Push_DescriptionViewBlock?
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.whiteColor()
        
        self.textView = JVFloatLabeledTextView(frame: CGRectMake(8, 58, SCREEN_WIDTH-16, SCREEN_HEIGHT-58-16)
        )
        self.view.addSubview(self.textView!)
        
        self.textView?.placeholder = "---撰写详细的评价，吐槽"
        self.view.tintColor = UIColor.grayColor()
        self.textView?.becomeFirstResponder()
        
        self.textView?.font = UIFont(name: MY_FONT,size: 13)
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func  keyboardWillShowNotification(notification:NSNotification)
    {
        let rect = XKeyBoard.returnKeyBoardWindow(notification)
        self.textView?.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height,0)
        
    }
    
    func  keyboardWillHideNotification(notification:NSNotification)
    {
     self.textView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func ok()
    {
        self.callBlock!(description:(self.textView?.text)!)
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    func close()
    {
        self.dismissViewControllerAnimated(true) {
            
        }
    }


}
