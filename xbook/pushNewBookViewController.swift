//
//  pushNewBookViewController.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class pushNewBookViewController: UIViewController,BookTitleDelegate,PhotoPickerDelegate {
    
 var bookTitleView:BookTitleView?
    override func viewDidLoad() {
        
       
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.bookTitleView = BookTitleView(frame:CGRectMake(0,40,SCREEN_WIDTH,160))
        self.bookTitleView?.delegate = self
        self.view.addSubview(self.bookTitleView!)
        
        
        
        
        
        
        
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func choiceCover() {
        print("------选择封面")
        
        
        
        let vc = PhotoPickerViewController()
        vc.delegate = self
        self.presentViewController(vc, animated: true) { 
            
        }
        
    }
    
    
    func getImageFromPicker(image: UIImage) {
        self.bookTitleView?.BookCover?.setImage(image, forState: .Normal)
    }
    
    func close() {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    func ok() {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
   

}
