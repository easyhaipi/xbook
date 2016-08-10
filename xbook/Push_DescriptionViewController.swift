//
//  Push_DescriptionViewController.swift
//  xbook
//
//  Created by taobaichi on 16/8/10.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class Push_DescriptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.yellowColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
