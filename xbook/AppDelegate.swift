//
//  AppDelegate.swift
//  xbook
//
//  Created by taobaichi on 16/6/30.
//  Copy    right © 2016年 taobaichi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //设置leanCloud
        
        AVOSCloud.setApplicationId("WmwD4rDeSmBHI3wQo43CKUnS-gzGzoHsz", clientKey: "Sw091yOHsjyAIaRvTftH0Tng"
        )
        AVAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        
        
        
        
        
        
        self.window = UIWindow(frame:CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: SCREEN_HEIGHT))
        let tabBarController = UITabBarController()
        let rankController = UINavigationController(rootViewController:rankViewController())
        let searchController = UINavigationController(rootViewController:SearchViewController())
        let pushController = UINavigationController(rootViewController:pushViewController())
        let circleController = UINavigationController(rootViewController:circleViewController())
        let moreController = UINavigationController(rootViewController:moreViewController())
        
//          let moreController2 = UINavigationController(rootViewController:moreViewController())
        tabBarController.viewControllers = [rankController,searchController,pushController,circleController,moreController];
        
        
        let tabbarItem1 = UITabBarItem(title: "排行榜",image: UIImage(named:"bio"),selectedImage:UIImage(named:"bio_red") )
        let tabbarItem2 = UITabBarItem(title: "发现",image: UIImage(named:"timer 2"),selectedImage:UIImage(named:"timer 2_red"))
        let tabbarItem3 = UITabBarItem(title: "",image: UIImage(named:"pencil"),selectedImage:UIImage(named:"pencil_red"))
        let tabbarItem4 = UITabBarItem(title: "圈子",image: UIImage(named:"users two-2"),selectedImage:UIImage(named:"users two-2_red"))
        let tabbarItem5 = UITabBarItem(title: "更多",image: UIImage(named:"more"),selectedImage:UIImage(named:"more_red"))
//        let tabbarItem6 = UITabBarItem(title: "测试",image: UIImage(named:"more"),selectedImage:UIImage(named:"more_red"))

        rankController.tabBarItem = tabbarItem1
        searchController.tabBarItem = tabbarItem2
        pushController.tabBarItem = tabbarItem3
        circleController.tabBarItem = tabbarItem4
        moreController.tabBarItem = tabbarItem5
//        moreController2.tabBarItem = tabbarItem6
        
        rankController.tabBarController?.tabBar.tintColor = MAIN_RED
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

