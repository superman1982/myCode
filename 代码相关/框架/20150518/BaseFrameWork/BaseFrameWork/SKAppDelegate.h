//
//  AppDelegate.h
//  MyProject
//
//  Created by lin on 15-1-5.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKHomePageViewController.h"
#import "SKLoginViewController.h"

@interface SKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) SKHomePageViewController *homeViewController;

@property (nonatomic,retain) SKLoginViewController    *loginViewController;
-(void)showHomeViewController;
-(void)showLoginViewControllerAnimated:(BOOL)aAnimate;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end

