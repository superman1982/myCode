//
//  AppDelegate.m
//  MyProject
//
//  Created by lin on 15-1-5.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKAppDelegate.h"
#import "SKLoginViewController.h"
#import "BaseFrameWork.h"
#import "SKLocalSetting.h"

@interface SKAppDelegate ()

@end

@implementation SKAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    SKLocalSetting *localSetting = [SKLocalSetting instanceSkLocalSetting];
    if (!localSetting.isInstalledApplicaiton) {
        localSetting.isInstalledApplicaiton = YES;
        localSetting.needShowWelcomePages = YES;
    }
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
    [self showLoginViewControllerAnimated:NO];
    [self.window makeKeyAndVisible];
    [SKLocalSetting saveSetting];
    return YES;
}

-(void)showHomeViewController{
    self.homeViewController.view.frame = CGRectMake(self.window.frame.size.width, 0, self.homeViewController.view.frame.size.width, self.homeViewController.view.frame.size.height);
    [self.window addSubview:self.homeViewController.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.loginViewController.view.alpha = 0.5;
        self.homeViewController.view.alpha = 1.0;
        self.homeViewController.view.frame = CGRectMake(0, 0, self.homeViewController.view.frame.size.width, self.homeViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.homeViewController.view removeFromSuperview];
        self.window.rootViewController = self.homeViewController;
    }];
}

-(void)showLoginViewControllerAnimated:(BOOL)aAnimate{
    self.loginViewController.view.frame = CGRectMake(-self.window.frame.size.width, 0, self.loginViewController.view.frame.size.width, self.loginViewController.view.frame.size.height);
    [self.window addSubview:self.loginViewController.view];
    CGFloat vDuration = 0.3;

    if (aAnimate) {
        [UIView beginAnimations:@"add loginView" context:@""];
        [UIView setAnimationDuration:vDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(loginAnimationComplete)];
    }

    if(_homeViewController != nil){
        self.homeViewController.view.alpha = 0.5;
    }
    self.loginViewController.view.alpha = 1.0;
    self.loginViewController.view.frame = CGRectMake(0, 0, self.loginViewController.view.frame.size.width, self.loginViewController.view.frame.size.height);
    
    if (aAnimate) {
        [UIView commitAnimations];
    }else{
        [self loginAnimationComplete];
    }
    
}

-(void)loginAnimationComplete{
    [self.loginViewController.view removeFromSuperview];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    self.window.rootViewController = naviController;
    [naviController setNavigationBarHidden:YES];
    [naviController autorelease];
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
