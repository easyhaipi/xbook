//
//  Push_TypeViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/10.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class Push_TypeViewController: UIViewController {

    var segmentController1:AKSegmentedControl?
    var segmentController2:AKSegmentedControl?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGB(232, g: 231, b: 231)
        let segmentLabel = UILabel(frame:CGRectMake((SCREEN_WIDTH-300)/2,20,300,20))
        segmentLabel.font = UIFont(name: MY_FONT,size: 12)
        segmentLabel.text = "请选择分类"
        segmentLabel.shadowOffset = CGSizeMake(0, 1)
        segmentLabel.shadowColor = UIColor.whiteColor()
        segmentLabel.textColor = RGB(82, g: 113, b: 113)
        segmentLabel.textAlignment = .Center
        self.view.addSubview(segmentLabel)
        
        
        self.initSegment()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     初始化segemnt
     */
    func initSegment(){
        let buttonArray = [
            ["image":"ledger","title":"文字","font":MY_FONT],
            ["image":"drama masks","title":"人文社科","font":MY_FONT],
            ["image":"aperture","title":"生活","font":MY_FONT]
            
        ]
        self.segmentController1 = AKSegmentedControl(frame:CGRectMake(10,60,SCREEN_WIDTH-20,37))
        self.segmentController1?.initButtonWithTitleandImage(buttonArray)
        self.view.addSubview(self.segmentController1!)
        self.segmentController1?.addTarget(self, action: #selector(Push_TypeViewController.segmentControllerAction), forControlEvents: .ValueChanged)
        
        let buttonArray2 = [
            ["image":"atom","title":"经管","font":MY_FONT],
            ["image":"alien","title":"科技","font":MY_FONT],
            ["image":"fire element","title":"网络流行","font":MY_FONT]
            
        ]
        self.segmentController2 = AKSegmentedControl(frame:CGRectMake(10,110,SCREEN_WIDTH-20,37))
        self.segmentController2?.initButtonWithTitleandImage(buttonArray2)
        self.view.addSubview(self.segmentController2!)
       self.segmentController2?.addTarget(self, action: #selector(Push_TypeViewController.segmentControllerAction), forControlEvents: .ValueChanged)
        
    }
    
    func segmentControllerAction(segment:AKSegmentedControl) {
        var index = segment.selectedIndexes.firstIndex;
        print(index)
        if segment==self.segmentController1 {
            self.segmentController2?.setSelectedIndex(3)
        }else{
             self.segmentController1?.setSelectedIndex(3)
            index += 3
        }
    }
    
    

    func ok()
    {
        
    }
    func close()
    {
        self.dismissViewControllerAnimated(true) {
            
        }
    }

}
