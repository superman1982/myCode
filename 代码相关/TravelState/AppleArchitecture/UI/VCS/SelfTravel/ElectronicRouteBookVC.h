//
//  ElectronicRouteBookVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderViewController.h"
#import "ClickableScrollView.h"
#import "ScenicDetailVC.h"
#import "CleanCarVC.h"

@interface ElectronicRouteBookVC : BaseViewController<SliderViewControllerDelegate,ScrollViewClickDelegate,ScenicDetailVCDelegate,CleanCarVCDelegate>
//滑动背景View
@property (retain, nonatomic) IBOutlet UIView *tableContentView;
//地图背景View
@property (retain, nonatomic) IBOutlet UIView *mapContentView;
//page背景View
@property (retain, nonatomic) IBOutlet UIScrollView *pageContentView;
//站点日程
@property (strong, nonatomic) IBOutlet UILabel *zhanDianRiChengLable;
//联系领队
@property (retain, nonatomic) IBOutlet UIButton *connectLeaderButton;
//放大或缩小地图的contentView
@property (retain, nonatomic) IBOutlet UIView *expandContentView;
//放大缩小地图
@property (retain, nonatomic) IBOutlet UIButton *exPandAndLengthMapButton;
//电子路书信息
@property (nonatomic,retain)  NSDictionary *electronicDic;
//路书类型
@property (nonatomic,assign)  ActiveType      routesType;

@property (nonatomic,retain) id  leaderPhone;
@end
