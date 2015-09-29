//
//  BaiDuNaviManeger.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BaiDuNaviManeger.h"
#import "BNTools.h"

@implementation BaiDuNaviManeger


- (void)startNavi:(CLLocationCoordinate2D )aStart EndLocation:(CLLocationCoordinate2D)aEnd
{
    BNPosition *vNaviPointStart =  [[BNPosition alloc] init];
    BNPosition *vNaviPointEnd = [[BNPosition alloc] init];
    
    BMapPoint vMapPointStart ;
    BMapPoint vMapPointEnd;
    vMapPointStart.x =  aStart.longitude;
    vMapPointStart.y = aStart.latitude;
    vMapPointEnd.x = aEnd.longitude;
    vMapPointEnd.y = aEnd.latitude;
    
    [BNTools ConvertBaiduMapPoint:&vMapPointStart ToBaiduNaviPoint:vNaviPointStart];
    [BNTools ConvertBaiduMapPoint:&vMapPointEnd ToBaiduNaviPoint:vNaviPointEnd];
    
    NSLog(@"NaviStart%f,",vNaviPointStart.y);
    NSLog(@"NaviEnd%f",vNaviPointEnd.y);
    
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = vNaviPointStart;
    [nodesArray addObject:startNode];
    SAFE_ARC_RELEASE(startNode);
    //也可以在此加入若干个的途经点
    /*
     BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
     midNode.pos = [[BNPosition alloc] init];
     midNode.pos.x = 116.12;
     midNode.pos.y = 39.05087;
     [nodesArray addObject:midNode];
     */
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = vNaviPointEnd;
    [nodesArray addObject:endNode];
    SAFE_ARC_RELEASE(endNode);
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
    
    [nodesArray removeAllObjects];
    SAFE_ARC_RELEASE(nodesArray);
}


#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航");
}

//退出导航声明页面回调
- (void)onExitexitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
}

@end
