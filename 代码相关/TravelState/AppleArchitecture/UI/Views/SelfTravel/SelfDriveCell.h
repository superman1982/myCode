//
//  SelfDriveCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveInfo.h"

typedef enum {
    btBook = 0,        // 报名
    btDownload,        // 下载
    btDownloading,     //下载中
    btCheckRoutes,     // 查看路书
    btActiveEnd,
} ButtonType;

@protocol SelfDriveCellDelegate <NSObject>
-(void)didSelfDriveCellClicked:(id)sender;
@end

@interface SelfDriveCell : UITableViewCell
{
    NSDateFormatter *mDateFormatter;
}
@property (retain, nonatomic) IBOutlet UIButton *BookAndDownLoadButton;
//评论lable
@property (retain, nonatomic) IBOutlet UILabel *pingLable;
//评论button
@property (retain, nonatomic) IBOutlet UIButton *pingButton;

@property (retain, nonatomic) IBOutlet UIView *view;
//赞Lable
@property (retain, nonatomic) IBOutlet UILabel *zanLable;
@property (retain, nonatomic) IBOutlet UIButton *zanButton;
//分享Lable
@property (retain, nonatomic) IBOutlet UILabel *shareLable;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;
//路线标题
@property (retain, nonatomic) IBOutlet UILabel *routeTitle;
//出发时间
@property (retain, nonatomic) IBOutlet UILabel *startTimeLable;
//旅途邦价格
@property (retain, nonatomic) IBOutlet UILabel *lvTuBangPriceLable;
//原价
@property (retain, nonatomic) IBOutlet UILabel *OriginPriceLable;
//预定人数
@property (retain, nonatomic) IBOutlet UILabel *bookPeopleLable;
//活动图片
@property (retain, nonatomic) IBOutlet UIImageView *activeImageView;
//官方图片标致
@property (retain, nonatomic) IBOutlet UIImageView *officalImageView;
//官方活动模拟点击button
@property (strong, nonatomic) IBOutlet UIButton *officeClickedButton;

//推荐行程需要隐藏的东西
@property (strong, nonatomic) IBOutlet UILabel *lvtuBangPriceDescLable;
@property (strong, nonatomic) IBOutlet UIImageView *priceLineImageView;

@property (nonatomic,assign)  id<SelfDriveCellDelegate>  delegate;

//button类型
@property (nonatomic,assign) ButtonType cellButtonType;
//是否正在下载
@property (nonatomic,assign) BOOL isDownloading;
@property (nonatomic,retain) ActiveInfo *activeInfo;
@property (nonatomic,retain) NSString *roadBookUrl;
-(void)setCell:(ActiveInfo *)aActiInfo;

#pragma mark 推荐路数界面调整
-(void)setRecommendRoutesUI;
#pragma mark 活动路书界面调整
-(void)setActiveRoteUI;
@end
