//
//  pushBook.swift
//  XBook
//
//  Created by xlx on 15/12/24.
//  Copyright © 2015年 xlx. All rights reserved.
//

import UIKit

class pushBook: NSObject {
    
    
    static func pushBookInBack(dict:NSDictionary,object:AVObject){

        object.setObject(dict["BookName"], forKey: "BookName")
        object.setObject(dict["BookEditor"], forKey: "BookEditor")
        object.setObject(dict["title"], forKey: "title")
        object.setObject(dict["score"], forKey: "score")
        object.setObject(dict["type"], forKey: "type")
        object.setObject(dict["detailType"], forKey: "detailType")
        object.setObject(dict["description"], forKey: "description")
        object.setObject(AVUser.currentUser(), forKey: "user")
        let cover = dict["BookCover"] as? UIImage
        let coverFile = AVFile(data: UIImagePNGRepresentation(cover!))
        coverFile.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                object.setObject(coverFile, forKey: "cover")
                object.saveEventually({ (success, error) -> Void in
                    if success {
                        /**
                        *  调用通知
                        */
                        NSNotificationCenter.defaultCenter().postNotificationName("pushCallBack", object: nil, userInfo: ["success":"true"])
                    }else{
                        NSNotificationCenter.defaultCenter().postNotificationName("pushCallBack", object: nil, userInfo: ["success":"false"])
                    }
                })
            }else{
                        NSNotificationCenter.defaultCenter().postNotificationName("pushCallBack", object: nil, userInfo: ["success":"false"])
            }
        }
    }
    
}
