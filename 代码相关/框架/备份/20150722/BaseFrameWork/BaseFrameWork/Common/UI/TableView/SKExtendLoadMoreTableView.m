//
//  SKExtendLoadMoreTableView.m
//  测试滑动删除Cell
//
//  Created by lin on 15/7/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKExtendLoadMoreTableView.h"

@interface SKExtendLoadMoreTableView()<SKLoadMoreTableFooterViewDelegate>
{
    BOOL                      _isLoading;
}
@end

@implementation SKExtendLoadMoreTableView

-(void)dealloc{
    SK_RELEASE_SAFELY(_footerView);
    [super dealloc];
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addFooterView];
    }
    return self;
}
-(void)addFooterView{
    if (_footerView == nil) {
        _footerView = [[SKLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 100)];
        _footerView.delegate = self;
        _footerView.backgroundColor = self.homeTableView.backgroundColor;
        _footerView.tableView = self.homeTableView;
    }
//    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.homeTableView addSubview:_footerView];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _footerView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 100);
}

#pragma mark - 辅助功能
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(numberOfRowsInTableView:InSection:FromView:)]) {
        NSInteger vRows = [self.dataSource numberOfRowsInTableView:tableView InSection:section FromView:self];
        mRowCountWithOutLoadMoreCell = vRows;
        return mRowCountWithOutLoadMoreCell ;
    }
    return 0;
}

-(void)handleLoadData{
    self.loadType = UITableViewLoadTypeLoadMore;
    if ([self.delegate respondsToSelector:@selector(loadData:FromView:)]) {
        [self.delegate loadData:^(int aAddedRowCount) {
            [self.homeTableView reloadData];
            [self loadDataFinished:nil];
        } FromView:self];
    }else{
        //自己模拟下载
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.homeTableView reloadData];
            [self loadDataFinished:nil];
        });

    }
}

-(void)reloadTableView{
    switch (self.loadType) {
        case UITableViewLoadTypeRefresh:
             [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
            break;
            case UITableViewLoadTypeLoadMore:
        {
            [self.homeTableView reloadData];
            [self loadDataFinished:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark EGORefresh
-(void)doneLoadingTableViewData{
    [super doneLoadingTableViewData];
    _footerView.frame =  CGRectMake(0, self.homeTableView.contentSize.height, self.homeTableView.frame.size.width, 100);
}

#pragma mark LoadMoreDelegate
-(void)begainToLoadData:(id)aSender{
    _isLoading = YES;
    [self handleLoadData];
}

-(BOOL)isLoadingData:(id)aSender{
    return _isLoading;
}

-(void)loadDataFinished:(id)aSender{
    _isLoading = NO;
    [_footerView recoverNormalStateReadyLoadData];
}
-(BOOL)noDataToLoad:(id)aSender{
    if ([self.delegate respondsToSelector:@selector(noDataToLoadFromView:)]) {
        return [self.delegate noDataToLoadFromView:self];
    }
    
    return NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [super scrollViewWillBeginDragging:scrollView];
    [_footerView loadMoreScrollViewWillBeginScroll:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    [_footerView loadMoreScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [_footerView loadMoreScrollViewDidEndDragging:scrollView];
}

@end
