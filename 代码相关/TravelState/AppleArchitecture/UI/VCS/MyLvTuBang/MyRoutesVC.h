//
//  MyRoutesVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"

@interface MyRoutesVC : BaseViewController<EGORefreshTableDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
}
//egorefresh
@property (nonatomic, assign) BOOL reloading;
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UITableView *routeTableView;

#pragma mark 刷新数据
-(void)refreshWebData;

@end
