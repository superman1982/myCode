//
//  ActivityRouteManeger.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-2.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"
#import <CoreLocation/CoreLocation.h>
#import "BaiDuNaviManeger.h"

#define BOOKEDPEOPLEKEY  @"bookedPeople"

// 下载数据的状态
typedef enum {
    stActivity = 1,      // 分享活动
    stLvTuBang,         // 分享旅途邦
} ShareContentType;

@interface ActivityRouteManeger : NSObject

@property (nonatomic,assign) CLLocationCoordinate2D userChosedBunessCoord;
//用户报名人数
@property (nonatomic,retain) NSMutableDictionary *bookPeopleDic;
//用户选择的省市区
@property (nonatomic,retain) NSDictionary *chosedPlaceDic;

@property (nonatomic,retain) NSNumber *mRootTableSelectedIndex;

@property (nonatomic,retain)   BaiDuNaviManeger *naviManeger;

+ (ActivityRouteManeger *) shareActivityManeger;

//请求点赞，分享，等数据
+ (void)postSharePraseCommentData:(NSString *)aURL Paremeter:(NSDictionary *)aDic Prompt:(NSString *)aPrompt RequestName:(NSString *)aNam;
//显示分享
+ (void)showShare:(NSString *)aTitle Content:(NSString *)aContent Paremeter:(NSDictionary *)aParemeter ShareType:(ShareContentType)aType;

//pragma mark 获取初始化时的省名
+ (NSString *)getProvinceName;
//添加星级的星星
+ (void)addStarsToView:(UIView *)aView StarNumber:(NSInteger)aStarNumber;
//调用百度地图app
+(void)gotoBaiMapApp:(CLLocationCoordinate2D )aStart EndLocation:(CLLocationCoordinate2D)aEnd;
//检查是否登入账号
+(BOOL)checkIfIsLogin;

#pragma mark 刷新和订单相关的页面
+(void)refreshPayRelatedUI;
@end
