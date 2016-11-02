//
//  rankViewController.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import UIKit

class rankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.white
        
//        AVUser.logOut()
        
        if AVUser.current()==nil {
            let storyBoard = UIStoryboard(name: "Login",bundle: nil)
            let LoginVc = storyBoard.instantiateViewController(withIdentifier: "Loginin")
            self.present(LoginVc, animated: true, completion: {
                
            })
        }
        
        
        let label = UILabel(frame:CGRect(x: 0,y: 0,width: 300,height: 30))
        label.textColor = UIColor.black
        label.center = self.view.center
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.text = "哈哈哈哈"
        label.font = UIFont(name:MY_FONT,size: 14)
        self.view.addSubview(label)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
