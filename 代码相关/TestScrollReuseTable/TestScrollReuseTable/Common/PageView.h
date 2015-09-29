//
//  PageView.h
//  TestScrollReuseTable
//
//  Created by lin on 14-5-28.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageView;

@protocol CustomTableViewDelegate <NSObject>
@required;
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(PageView *)aView;
-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(PageView *)aView;
@optional
@end

@protocol CustomTableViewDataSource <NSObject>
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(PageView *)aView;
-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(PageView *)aView;

@end

@interface PageView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *pageTableView;

@property (nonatomic,retain) NSString *identify;

@property (nonatomic,assign) id<CustomTableViewDelegate> delegate;

@property (nonatomic,assign) id<CustomTableViewDataSource> datasource;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) NSInteger pageNumber;

-(void)pageViewWillApear;
-(void)pageVIewDidDissApear;

#pragma mark 模拟删除动画
-(void)removeSelfAnimation;
@end
