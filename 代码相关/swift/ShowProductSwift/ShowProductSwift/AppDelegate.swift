//
//  AppDelegate.swift
//  ShowProductSwift
//
//  Created by lin on 14-7-14.
//  Copyright (c) 2014 lin. All rights reserved.
//
/* -----------------------------！！！！read me first！！！！！-----------------
1、本人搞IOS开发的，下载demo的朋友，如果你是IOS开发初学者，有兴趣的人可以查看下面的链接
http://item.taobao.com/item.htm?spm=a230r.1.14.137.drLUj5&id=39818151361&ns=1#detail

2、如果你是IOS开发老手，请多多包含。

3、本人之前用Object-c写了一个类似的demo,功能几乎相仿，有兴趣者请点击
http://code4app.com/ios/%E6%96%B0%E9%97%BB%E5%B1%95%E7%A4%BA%E7%95%8C%E9%9D%A2/53a267b6933bf051468b54b8

-------------------------------------------end-------------------------*/
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        
        var vMessageVC:MessageVC = MessageVC(nibName: nil, bundle: nil)
        var vNaviVC = UINavigationController(rootViewController: vMessageVC)
        self.window!.rootViewController = vNaviVC
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

