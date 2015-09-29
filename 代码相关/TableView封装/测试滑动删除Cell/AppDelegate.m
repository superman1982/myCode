//
//  AppDelegate.m
//  测试滑动删除Cell
//*****************************read me first ************************/
//  大家好，这是本人第二个作品，有一部分参照了别人的代码，但是大部分还是自己写的
//  大家如果在使用中有什么疑问和Bug可及时与我联系，QQ:2489278559
//  如果对于代码优化，有更好的建议者也可以与我联系。
//  对于学习ios的初学者可以看看我提供的教程：
//  http://item.taobao.com/item.htm?spm=a230r.1.14.294.BRk2Ew&id=39818151361&ns=1#detail
//************************************ end **************************/
//  Created by lin on 14-8-7.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    UINavigationController *vNavi = [[UINavigationController alloc] init];
    self.window.rootViewController = vNavi;
    [vNavi release];
    
    ViewController *vVC = [[ViewController alloc] initWithNibName:nil bundle:nil];
    [vNavi pushViewController:vVC animated:YES];
    [vVC release];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
