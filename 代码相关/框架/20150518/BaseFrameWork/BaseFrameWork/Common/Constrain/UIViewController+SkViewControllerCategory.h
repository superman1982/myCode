//
//  UIViewController+SkViewControllerCategory.h
//  MyProject
//
//  Created by lin on 15-1-14.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKAppDelegate.h"

@interface UIViewController (SkViewControllerCategory)

@property (nonatomic,assign) SKAppDelegate  *appDelegate;

@end
