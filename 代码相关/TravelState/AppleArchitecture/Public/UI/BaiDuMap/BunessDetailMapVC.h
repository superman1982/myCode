//
//  BunessDetailMapVC.h
//  CTBNewProject
//
//  Created by klbest1 on 13-12-9.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiDuMapView.h"
#import "BaiDuDataLoader.h"

@protocol BunessDetailMapVCDelegate <NSObject>

-(void)BunessDetailMapDidBack:(id)sender;
@end
@interface BunessDetailMapVC : UIViewController<BaiDuMapViewDelegate,BaiDuDataLoaderDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
//站点名或商家名
@property (retain, nonatomic) IBOutlet UILabel *bunessNameLable;
//站点button
@property (retain, nonatomic) IBOutlet UIButton *siteNoButton;
//弹出气泡
@property (retain, nonatomic) IBOutlet UIView *mapPaoPaoView;
//气泡里层view
@property (retain, nonatomic) IBOutlet UIView *mapPaoPaoInContentView;

//去这里button
@property (retain, nonatomic) IBOutlet UIButton *gothereButton;
//附近商家button
@property (retain, nonatomic) IBOutlet UIButton *nearByButton;


@property (nonatomic,assign) id<BunessDetailMapVCDelegate> delegate;


//在地图上显示商家位置
-(void) setBunessMapData:(id )aInfo SearchType:(SearchType)aType;
//规划行车线路
-(void)driveLineSearchWithStartLocation:(CLLocationCoordinate2D) aStartlocation EndLocation:(CLLocationCoordinate2D) aEndLocation;
//查询停车场，加油站
-(void)searchGasAndStopStation:(SearchType )aSearchType;
//添加大头针
-(void)adddAnnotation:(NSArray *)aArray SearchType:(SearchType )aType;
// 重设view大小位置
-(void)reSetViewFrame:(CGRect)aFrame;

//规划连续线路信息
-(void)searchMutilLineWithLocationArray:(NSArray *)aArray;
//添加站点大头针
-(void)addSitesAnnotation:(NSArray *)aArray;
@end
