//
//  UIViewController+SkViewControllerCategory.m
//  MyProject
//
//  Created by lin on 15-1-14.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "UIViewController+SkViewControllerCategory.h"

@implementation UIViewController (SkViewControllerCategory)

-(SKAppDelegate *)appDelegate{
    return (SKAppDelegate *)[UIApplication sharedApplication].delegate;
}

-(void)setAppDelegate:(SKAppDelegate *)delegate{

}

@end
