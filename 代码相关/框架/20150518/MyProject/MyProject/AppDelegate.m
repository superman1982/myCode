//
//  AppDelegate.m
//  MyProject
//
//  Created by lin on 15-1-5.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "BaseFrameWork.h"
#import "SKLocalSetting.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize loginViewController = _loginViewController;
@synthesize homeViewController = _homeViewController;

-(SKLoginViewController *)loginViewController{
    if (_loginViewController == nil) {
        _loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    return _loginViewController;
}

-(SKHomePageViewController *)homeViewController{
    if (_homeViewController == nil) {
        _homeViewController = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
    }
    return _homeViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    // remove NSHTTPCookie
    NSArray *array = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *aCookie in array) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:aCookie];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [SKLocalSetting saveSetting];

}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *aToken = [[[[[deviceToken description]
                           stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""] retain];
    NSLog(@"deviceToken is: %@", deviceToken);
    // save to local
    [[NSUserDefaults standardUserDefaults] setObject:aToken forKey:@"deviceToken"];
    [aToken release];
    NSLog(@"My token is: %@", aToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"deviceToken"];

}

@end
