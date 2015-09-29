//
//  RootViewController.h
//  CarServices
//
//  Created by klbest1 on 14-1-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"
#import "BaseViewController.h"
#import "LoginVC.h"
#import "DefaultHomeVC.h"
#import "BaiDuMapView.h"
#import "RegisterVC.h"
#import "ChoseProvinceVC.h"
#import "WelcomeVC.h"
#import "SelfTravelVC.h"
#import "MyLvTuBangVC.h"

@interface RootTabBarVC : BaseViewController<CustomTabBarControllerDelegate,DefaultHomeVCDelegate,BaiDuMapViewDelegate,ChoseProvinceVCDelegate,WelcomeVCDeleate>

@property (nonatomic,retain) SelfTravelVC *selfDriveVC;

@property (nonatomic,retain) MyLvTuBangVC *myLvTuBang;

#pragma mark 设置我的旅途邦Navi
-(void)reSetMylvTuBangNaviBar;
#pragma mark 隐藏购物车导航条部分设置
-(void)hideShopingCarNavi;
#pragma mark 显示购物车编辑按钮等
-(void)setShoppingCarNavi;
@end
