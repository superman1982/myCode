//
//  SLCustomUINavigationController.h
//  相机
//
//  Created by lin on 15-3-11.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLCustomUINavigationControllerDelegate <NSObject>

-(void)didTakePhotoSuccess:(UIImage *)photo;

@end

@interface SLCustomUINavigationController : UINavigationController

@property (nonatomic,assign) id naviDelegate;

-(void)showCamera:(UIViewController *)aParentVC;
@end
