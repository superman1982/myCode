//
//  MyNoticeVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"
#import "AgentSearchTypeVC.h"

@interface MyNoticeVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,AgentSearchTypeVCDelegate>
//提醒表单
@property (retain, nonatomic) IBOutlet ClickableTableView *noticeTableView;
@property (retain, nonatomic) IBOutlet UIButton *agentButton;
@property (retain, nonatomic) IBOutlet UIButton *insuranceButton;
@property (retain, nonatomic) IBOutlet UIButton *chongZhiButton;

//egorefresh
@property (nonatomic, assign) BOOL reloading;
@end
