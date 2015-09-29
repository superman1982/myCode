//
//  BunessDetailVC.h
//  CTBNewProject
//
//  Created by klbest1 on 13-12-9.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BunessDetailMapVC.h"
#import "ShangJiaInfo.h"
#import "ElectronicBunessDetailCell.h"
#import "ElectronicBunessDetailNoTimeCell.h"

@protocol BunessDetailVCDelegate <NSObject>

-(void)didBunessDetailVCBackClicked:(id)sender;
@end

@interface BunessDetailVC : BaseViewController<BunessDetailMapVCDelegate,ElectronicBunessDetailCellDelegate,ElectronicBunessDetailNoTimeCellDelegate>

//商家门头图
@property (strong, nonatomic) IBOutlet UIImageView *bunessHeadPhotoImageView;
//商家名
@property (retain, nonatomic) IBOutlet UILabel *bunessName;
//商家星级
@property (strong, nonatomic) IBOutlet UIImageView *startImageView;
//电话号码
@property (strong, nonatomic) IBOutlet UILabel *phoneLable;
//商家地址
@property (strong, nonatomic) IBOutlet UILabel *addressLable;
//商家详情列表
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
//距离
@property (retain, nonatomic) IBOutlet UILabel *distanceLable;
//是否认证标致
@property (retain, nonatomic) IBOutlet UIImageView *renZhenImageView;

@property (nonatomic,retain)  ShangJiaInfo *shangJiaInfo;

@property (nonatomic,assign) SearchType searchType;

@property (nonatomic,assign) id<BunessDetailVCDelegate> delegate;

//设置商家信息
-(void)setBunessDetailData:(NSDictionary *)aData;

@end
