//
//  MessageVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"

@interface MessageVC : BaseViewController<EGORefreshTableDelegate>
//消息表单
@property (retain, nonatomic) IBOutlet UITableView *messageTableView;
//egorefresh
@property (nonatomic, assign) BOOL reloading;

@end
