//
//  GeneralFactory.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class GeneralFactory: NSObject {
    
    
    static func addTitleViewWithTitle(_ target:UIViewController,title1:String="关闭",title2:String="确认")
    {
        let btn1 = UIButton(frame:CGRect(x: 10,y: 20,width: 40,height: 20))
        btn1.tag = 123
        btn1.setTitle(title1, for: UIControlState())
        btn1.contentHorizontalAlignment  = .left
        btn1.setTitleColor(MAIN_RED, for: UIControlState())
        btn1.titleLabel?.font = UIFont(name: MY_FONT,size: 14)
        target.view.addSubview(btn1)
        
        
        let btn2 = UIButton(frame:CGRect(x: SCREEN_WIDTH-50,y: 20,width: 40,height: 20))
        btn2.tag = 345
        btn2.setTitle(title2, for: UIControlState())
        btn2.contentHorizontalAlignment  = .right
        btn2.setTitleColor(MAIN_RED, for: UIControlState())
        btn2.titleLabel?.font = UIFont(name: MY_FONT,size: 14)
        target.view.addSubview(btn2)
        
        
        
        btn1.addTarget(target, action: #selector(Stream.close), for: .touchUpInside)
        btn2.addTarget(target, action: Selector(("ok")), for: .touchUpInside)
        
    }

}
