//
//  GeneralFactory.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class GeneralFactory: NSObject {
    
    
    static func addTitleViewWithTitle(target:UIViewController,title1:String="关闭",title2:String="确认")
    {
        let btn1 = UIButton(frame:CGRectMake(10,20,40,20))
        btn1.setTitle(title1, forState: .Normal)
        btn1.contentHorizontalAlignment  = .Left
        btn1.setTitleColor(MAIN_RED, forState: .Normal)
        btn1.titleLabel?.font = UIFont(name: MY_FONT,size: 14)
        target.view.addSubview(btn1)
        
        
        let btn2 = UIButton(frame:CGRectMake(SCREEN_WIDTH-50,20,40,20))
        btn2.setTitle(title2, forState: .Normal)
        btn2.contentHorizontalAlignment  = .Right
        btn2.setTitleColor(MAIN_RED, forState: .Normal)
        btn2.titleLabel?.font = UIFont(name: MY_FONT,size: 14)
        target.view.addSubview(btn2)
        
        
        
        btn1.addTarget(target, action: Selector("close"), forControlEvents: .TouchUpInside)
        btn2.addTarget(target, action: Selector("ok"), forControlEvents: .TouchUpInside)
        
    }

}
