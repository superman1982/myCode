//
//  AgentBunessVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"
#import "ChoseDistrictVC.h"
#import "BunessDetailVC.h"
#import "AgentSearchTypeVC.h"

@interface AgentBunessVC : BaseViewController<EGORefreshTableDelegate,ChoseDistrictVCDelegate,BunessDetailVCDelegate,AgentSearchTypeVCDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
}
//egorefresh
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic,retain) NSString *bunessTitle;
@property (retain, nonatomic) IBOutlet ClickableTableView *agentBunessTableView;

@property (retain, nonatomic) IBOutlet UILabel *ifHasBunessLable;
@property (nonatomic,retain) NSDictionary *placeDic;

//搜索ContentView
@property (strong, nonatomic) IBOutlet UIView *middleContentView;
//搜索button
@property (strong, nonatomic) IBOutlet UIButton *searchTypeButton;
//输入框
@property (strong, nonatomic) IBOutlet UITextField *searchField;
//是否是搜索商家
@property (nonatomic,assign) BOOL isSearchType;

@property (strong, nonatomic) IBOutlet UIView *servicesContentView;
@property (strong, nonatomic) IBOutlet UIButton *eatButton;
@property (strong, nonatomic) IBOutlet UIButton *sleepButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

#pragma mark 设置列表展示商家
-(void)setNormalShowBunessVC;
#pragma mark 啥子搜索展示商家
-(void)setSearchShowNunessVC;
@end
