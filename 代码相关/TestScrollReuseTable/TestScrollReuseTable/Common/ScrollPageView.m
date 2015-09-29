//
//  ScrollPageView.m
//  TestScrollReuseTable
//
//  Created by lin on 14-5-28.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "ScrollPageView.h"


#define GAP           10
#define TAGSTART      1000

@implementation ScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _numberOfVisiualPages = 1;
        _numberOfTotalPages = 4;
        if (mVisibalePages == nil) {
            mVisibalePages = [[NSMutableArray alloc] init];
        }
        if (mReciclePages == nil) {
            mReciclePages = [[NSMutableArray alloc] init];
        }
        [self commInit];
    }
    return self;
}

-(void)commInit{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        [_scrollView setFrame:CGRectMake(0, 0, 320 + 2 *GAP, self.frame.size.height)];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBackgroundColor:[UIColor blackColor]];
    }
    [self addSubview:_scrollView];
    
    [self addPages];
}

-(void)dealloc{
    [mVisibalePages removeAllObjects],[mVisibalePages release],mVisibalePages = nil;
    [mReciclePages removeAllObjects],[mReciclePages release],mReciclePages = nil;
    [_scrollView release];_scrollView = nil;
    [super dealloc];
}

-(void)setNumberOfTotalPages:(NSInteger)numberOfTotalPages{
    _numberOfTotalPages = numberOfTotalPages;
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * _numberOfTotalPages, _scrollView.frame.size.height)];
}

-(void)addPages{
    CGRect vCurrentVisualRect = _scrollView.bounds;
    NSInteger firstPageIndex = floorf((CGRectGetMinX(vCurrentVisualRect))/CGRectGetWidth(vCurrentVisualRect));
    NSInteger lastPageIndex = floorf((CGRectGetMaxX(vCurrentVisualRect)-1)/CGRectGetWidth(vCurrentVisualRect))+ _numberOfVisiualPages;
    lastPageIndex = MIN(lastPageIndex, _numberOfTotalPages);
    if (_edit) {
        firstPageIndex -= 1;
    }
    if (firstPageIndex < 0) {
        firstPageIndex = 0;
    }
    if (lastPageIndex >= _numberOfTotalPages) {
        lastPageIndex = _numberOfTotalPages -1;
    }
    _currentPage = firstPageIndex;
    
    //移除不在屏幕外的视图
    for (PageView *aView in mVisibalePages) {
        if (aView.pageIndex < firstPageIndex || aView.pageIndex > lastPageIndex) {
            if (aView.superview != nil) {
                [aView removeFromSuperview];
                [aView pageVIewDidDissApear];
                [mReciclePages addObject:aView];
            }
        }
    }
    [mVisibalePages removeObjectsInArray:mReciclePages];
    
    //加载需要显示的视图
    for(int i = firstPageIndex; i <= lastPageIndex; i++)
    {
        if (![self isDisplayingPageIndex:i]) {
            PageView *vPageView = [self getPageView];
            vPageView.pageIndex = i;
            vPageView.tag = TAGSTART + i;
            [vPageView setFrame:CGRectMake(i * (320 + 2 *GAP), 0, vPageView.frame.size.width, vPageView.frame.size.height)];
            NSLog(@"panelFrame(%f,%f,%f,%f)",vPageView.frame.origin.x,vPageView.frame.origin.y,vPageView.frame.size.width,vPageView.frame.size.height);
            [_scrollView addSubview:vPageView];
            [mVisibalePages addObject:vPageView];
//            [vPageView pageViewWillApear];
        }

    }
}


#pragma mark 该页面是否已经被显示
-(BOOL)isDisplayingPageIndex:(NSInteger)aIndex{
    for (PageView *vView in mVisibalePages) {
        if (vView.pageIndex ==aIndex) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark 回收机制，回收不在屏幕现实外的视图
-(PageView *)dequeReusePageViewWithIdentify:(NSString *)aIdentifyStr{
    NSPredicate *vPredicate = [NSPredicate predicateWithFormat:@"SELF.identify == %@ ",aIdentifyStr];
    NSArray *vFilterArray = [mReciclePages filteredArrayUsingPredicate:vPredicate];
    PageView *vPageView = [vFilterArray lastObject];
    if (vPageView) {
        [[vPageView retain] autorelease];
        [mReciclePages removeObject:vPageView];
    }
    return vPageView;
}

#pragma mark 获取PageView
-(PageView *)getPageView{
    static NSString *identify = @"pageView";
    PageView *vPageView = [self dequeReusePageViewWithIdentify:identify];
    if (vPageView == nil) {
        vPageView = [[[PageView alloc] initWithFrame:CGRectMake(0, 0, 320,self.frame.size.height)] autorelease];
        vPageView.delegate = self;
        vPageView.datasource = self;
    }
    
    return vPageView;
}


#pragma mark 移除当前视图
-(void)removeCurrentPageView{
    PageView *vPage = (PageView *)[_scrollView viewWithTag:TAGSTART + _currentPage];
    [vPage removeSelfAnimation];
    _numberOfTotalPages -= 1;
    //add code 移除视图内容
    //-----
    [_scrollView setContentSize:CGSizeMake(((320 + 2*GAP) * _numberOfTotalPages),_scrollView.bounds.size.height)];
    //重新加载新的内容
    [vPage pageViewWillApear];
}

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(PageView *)aView{
    return 44;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(PageView *)aView{

}

-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(PageView *)aView{
    return 4;
}
-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(PageView *)aView{
        static NSString *identify = @"myCell";
        UITableViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:identify];
        if (vCell == nil) {
            vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    vCell.textLabel.text = [NSString stringWithFormat:@"CurrentPage:%d",aView.pageIndex];
    return vCell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self addPages];
}
// any offset changes

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
    if (lastShowedPageIndex != _currentPage) {
        PageView *vView = (PageView *)[_scrollView viewWithTag:TAGSTART + _currentPage];
        [vView pageViewWillApear];
    }
    lastShowedPageIndex = _currentPage;
    
}

@end
