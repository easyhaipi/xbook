//
//  config.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

import Foundation


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let MAIN_RED = UIColor(colorLiteralRed: 235/255, green: 114/255, blue: 118/255, alpha: 1)

let MY_FONT =  "Bauhaus ITC"
func RGB(_ r:Float,g:Float,b:Float)->UIColor{
    return UIColor(colorLiteralRed:r/255.0,green:g/255.0,blue:b/255.0,alpha:1.0)
}
