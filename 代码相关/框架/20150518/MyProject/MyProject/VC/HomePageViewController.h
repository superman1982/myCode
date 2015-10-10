//
//  HomePageViewController.h
//  MyProject
//
//  Created by lin on 15-1-14.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKHomePageViewController.h"

@interface HomePageViewController : SKHomePageViewController

@property (retain, nonatomic) IBOutlet UIButton *cacheImageButton;

@property (retain, nonatomic) IBOutlet UIImageView *homeImageView;
@property (nonatomic,retain)  NSMutableDictionary *moduleDics;
@end
