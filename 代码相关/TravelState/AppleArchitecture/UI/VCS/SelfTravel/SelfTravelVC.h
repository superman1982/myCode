//
//  SelfTravelVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"
#import "SliderViewController.h"
#import "ActiveBookVC.h"
#import "SelfDriveCell.h"
#import "ActiveDetailVC.h"
#import "SelfDriveCell.h"

@interface SelfTravelVC : BaseViewController<EGORefreshTableDelegate,ActiveBookVCDelegate,SelfDriveCellDelegate>
//egorefresh
@property (nonatomic, assign) BOOL reloading;
//normal路线
@property (nonatomic,retain) NSMutableArray *routesArray;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UITableView *routeTableView;
//活动路数button
@property (retain, nonatomic) IBOutlet UIButton *huodongLushuButton;
//推荐行程button
@property (retain, nonatomic) IBOutlet UIButton *recommendButton;
//暂无活动路数提示
@property (retain, nonatomic) IBOutlet UILabel *zanWuHuoDongLuShuLable;
-(void)initSelfDriveData;
//分解活动数据
-(ActiveInfo *)analyzeActivityDic:(NSDictionary *)aDic;
//更新某行活动信息
-(void)reloadActiveDataOnRow:(ActiveInfo *)aInfo;
//请求网络数据提示信息
@property (nonatomic,retain) NSString *noticeStr;

-(void)gotoActiveDetailVC:(id )aInfo;

@end
