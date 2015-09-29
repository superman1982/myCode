//
//  SetingViewController.h
//  ZHMS-PDA
//
//  Created by klbest1 on 13-12-12.
//  Copyright (c) 2013年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PersonalInfomationVC.h"
#import "LoginVC.h"
#import "RegisterVC.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"


@interface MyLvTuBangVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,PersonalInfomationVCDelegate,LoginVCDelegate,RegisterVCDelegate,EGORefreshTableDelegate>
{
    //是否点击活动路书
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
}
//egorefresh
@property (nonatomic, assign) BOOL reloading;

//菜单上的表单
@property (retain, nonatomic) IBOutlet UITableView *menuTableView;

//头像
@property (retain, nonatomic) IBOutlet UIImageView *headerImageUrl;
//头像button
@property (retain, nonatomic) IBOutlet UIButton *headerImageUrlButton;
//昵称
@property (retain, nonatomic) IBOutlet UILabel *nickname;
//会员时长
@property (retain, nonatomic) IBOutlet UILabel *memberTime;
//性别
@property (retain, nonatomic) IBOutlet UIImageView *sex;
//提醒数目
@property (retain, nonatomic) IBOutlet UIButton *isPaySms;
//消息数目
@property (retain, nonatomic) IBOutlet UIButton *alertMessage;

//提示设置支付密码
@property (retain, nonatomic) IBOutlet UIView *noticeContentView;
@property (retain, nonatomic) IBOutlet UIView *noticeView;
//没有登录旅途邦的View
@property (strong, nonatomic) IBOutlet UIView *withoutLoginView;

#pragma mark 添加未登录“我的旅途邦”
-(void)addUnLoginVC;
#pragma mark 充值
- (IBAction)chongZhiClicked:(id)sender;
#pragma mark 更新页面数据
-(void)setUI;
@end
