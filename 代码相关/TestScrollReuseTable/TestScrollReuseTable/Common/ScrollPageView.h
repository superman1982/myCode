//
//  ScrollPageView.h
//  TestScrollReuseTable
//
//  Created by lin on 14-5-28.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//
/*练习重点：ScrollView布局和PageView重用机制*/
#import <UIKit/UIKit.h>
#import "PageView.h"

@interface ScrollPageView : UIView<CustomTableViewDataSource,CustomTableViewDelegate,UIScrollViewDelegate>

{
    NSMutableArray *mVisibalePages;  //屏幕上要被显示的视图
    NSMutableArray *mReciclePages;  //不在当前屏幕的被回收的页面
    NSInteger    lastShowedPageIndex;
}
@property (nonatomic,retain) UIScrollView *scrollView;

@property (nonatomic,assign) NSInteger numberOfVisiualPages;

@property (nonatomic,assign) NSInteger numberOfTotalPages;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,assign) BOOL      edit;

#pragma mark 移除当前视图
-(void)removeCurrentPageView;
@end
