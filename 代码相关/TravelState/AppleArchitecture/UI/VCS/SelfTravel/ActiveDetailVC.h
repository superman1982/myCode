//
//  ActiveDetailVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveInfo.h"
#import "SelfDriveCell.h"


@interface ActiveDetailVC : BaseViewController
{
    NSDateFormatter *mDateFormatter;
}
@property (retain, nonatomic) IBOutlet UIButton *bookButton;
//保存活动详情信息
@property (nonatomic,retain) NSDictionary *detailDic;

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIWebView *detailWebView;
//下载或是查看button
@property (retain, nonatomic) IBOutlet UIButton *donwLoadOrCheckButton;
//客服button
@property (retain, nonatomic) IBOutlet UIButton *customButton;
//活动信息
@property (nonatomic,retain) ActiveInfo *acticeInfo;
//赞
@property (retain, nonatomic) IBOutlet UILabel *zanLable;
//分享
@property (retain, nonatomic) IBOutlet UILabel *shareLable;
//评论
@property (retain, nonatomic) IBOutlet UILabel *commentLable;

//button类型
@property (nonatomic,assign) ButtonType cellButtonType;

//刷新评论，分享，赞的数量
-(void)setLableCount:(ActiveInfo *)aInfo;
@end
