//
//  CustomTableView.h
//
//
//  Created by klbest1 on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SKSlideTableViewCell.h"
#import "SKHitView.h"

@class SKCustomTableView;
@protocol CustomTableViewDelegate <NSObject>
@required;
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView;
-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView;
-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(SKCustomTableView *)aView;
-(void)refreshData:(void(^)())complete FromView:(SKCustomTableView *)aView;

@optional
-(void)didDeleteCellAtIndexpath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView;
//- (void)tableViewWillBeginDragging:(UIScrollView *)scrollView;
//- (void)tableViewDidScroll:(UIScrollView *)scrollView;
////- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView;
@end

@protocol CustomTableViewDataSource <NSObject>
@required;
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(SKCustomTableView *)aView;
-(SKSlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView;

@end

@interface SKCustomTableView : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SlideTableViewCellDelegate,HitViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    NSInteger     mRowCountWithOutLoadMoreCell;
}
//  Reloading var should really be your tableviews datasource
//  Putting it here for demo purposes
@property (nonatomic,assign) BOOL reloading;

@property (nonatomic,retain) UITableView *homeTableView;
@property (nonatomic,retain) NSMutableArray *tableInfoArray;
@property (nonatomic,assign) id<CustomTableViewDataSource> dataSource;
@property (nonatomic,assign) id<CustomTableViewDelegate>  delegate;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
    
#pragma mark 强制列表刷新
-(void)forceToFreshData;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
@end
