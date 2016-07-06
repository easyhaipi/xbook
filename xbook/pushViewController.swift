//
//  pushViewController.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class pushViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    self.view.backgroundColor = UIColor.whiteColor()
    self.setNavigationBar()
      
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setNavigationBar(){
        let navigationView = UIView(frame:CGRectMake(0,-20,SCREEN_WIDTH,65))
        navigationView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar .addSubview(navigationView)
        
        
        let addBookButton = UIButton(frame:CGRectMake(20,20,SCREEN_WIDTH,45))
        addBookButton.setImage(UIImage(named: "plus circle"), forState: .Normal)
        addBookButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addBookButton.setTitle("     新建书评", forState: .Normal)
        addBookButton.titleLabel?.font = UIFont(name:MY_FONT,size: 15)
        addBookButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        addBookButton.addTarget(self, action:#selector(pushViewController.pushNewBookAction), forControlEvents: .TouchUpInside)
        
        
        navigationView .addSubview(addBookButton)
        
    }
    
    
    func pushNewBookAction(){
      
        
        
        let vc = pushNewBookViewController()
        GeneralFactory.addTitleViewWithTitle(vc)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    
}
