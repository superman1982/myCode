//
//  MyOrdersVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"
#import "MyOrderCell.h"
#import "AgentSearchTypeVC.h"

@interface MyOrdersVC : BaseViewController<EGORefreshTableDelegate,MyOrderCellDelegate,AgentSearchTypeVCDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
}
//egorefresh
@property (nonatomic, assign) BOOL reloading;

@property (strong, nonatomic) IBOutlet UIScrollView *buttonContentView;

@property (retain, nonatomic) IBOutlet ClickableTableView *orderTableView;
#pragma mark 初始化网络请求
-(void)initWebData;
#pragma mark 刷新订单详情页面
-(void)refreshOrderUI;
@end
