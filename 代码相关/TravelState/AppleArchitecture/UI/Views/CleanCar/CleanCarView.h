//
//  KJFWTableView.h
//  CTB
//
//  Created by klbest1 on 13-7-11.
//  Copyright (c) 2013年 My. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"
#import "ConstDef.h"
#import "BaiDuDataLoader.h"


@protocol CleanCarDelegate <NSObject>

-(void)didSelectedRowAtKJTableview:(id)sender;

@end

@interface CleanCarView : UIView<UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate,BaiDuDataLoaderDelegate>

{
    NSMutableArray *mQcmrInfoArr;
    SearchType mSearchType;
}
//服务列表
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//egorefresh
@property (nonatomic, assign) BOOL reloading;
//所有商家信息
@property (nonatomic,retain) NSMutableArray *qcmrInfoArr;
//列表加载的商家
@property (nonatomic,retain) NSMutableArray *tableInfoArray;
//加载服务列表的vc
@property (nonatomic,retain) UIViewController *parentVC;
//服务类型
@property (nonatomic,assign) SearchType searchType;
@property (nonatomic,assign) id<CleanCarDelegate> KJTableViewdelegate;

//初始化列表
-(void)comInit;
//加载服务数据
-(void)loadBusiness:(SearchType)aType
     BaiDuParemeter:(struct BaiDuCould)aBaiDu
           SortFlag:(SortType)aSortType
       BusinessName:(NSString *)aBusynessName;
#pragma mark 提示是否有商家
-(void)setNoticeUI;
@end
