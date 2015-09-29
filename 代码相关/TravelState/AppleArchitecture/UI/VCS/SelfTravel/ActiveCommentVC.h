//
//  ActiveCommentVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-12.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveInfo.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"

@interface ActiveCommentVC : BaseViewController<EGORefreshTableDelegate>

{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
}
//egorefresh
@property (nonatomic, assign) BOOL reloading;

@property (retain, nonatomic) IBOutlet UITableView *commentTableView;

@property (retain, nonatomic) IBOutlet UITextField *commentTextField;
@property (nonatomic,retain) ActiveInfo *activeInfo;
//初始化评论数据
-(void)refreshUI;
@end
