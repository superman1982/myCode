//
//  MyRoutesCell.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-5.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveInfo.h"

typedef enum {
    btMyActiveBook = 0,   //报名
    btMyActiveEnd,
} MyActiveButtonType;

@interface MyRoutesCell : UITableViewCell
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
//活动图片

@property (retain, nonatomic) IBOutlet UIImageView *activeImageView;

//官方图片标致
@property (retain, nonatomic) IBOutlet UIImageView *officalImageView;


@property (nonatomic,retain) ActiveInfo *activeInfo;

@property (nonatomic,assign) MyActiveButtonType cellButtonType;

-(void)setCell:(ActiveInfo *)aActiInfo;

@end
