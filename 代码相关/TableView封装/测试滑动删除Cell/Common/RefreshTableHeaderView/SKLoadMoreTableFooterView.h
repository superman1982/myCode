//
//  SKLoadMoreTableFooterView.h
//  测试滑动删除Cell
//
//  Created by lin on 15/7/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKLoadMoreTableFooterViewDelegate <NSObject>

-(void)begainToLoadData:(id)aSender;
-(BOOL)isLoadingData:(id)aSender;
-(void)loadDataFinished:(id)aSender;

@end

@interface SKLoadMoreTableFooterView : UIView

@property (nonatomic,assign) id<SKLoadMoreTableFooterViewDelegate> delegate;
@property (nonatomic,assign) UITableView    *tableView;

- (void)loadMoreScrollViewWillBeginScroll:(UIScrollView *)scrollView;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;

-(void)recoverNormalStateReadyLoadData;

@end
