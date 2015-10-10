//
//  kZPagedScrollView.m
//  测试ShowPhoto
//
//  Created by lin on 14-9-29.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "kZPagedScrollView.h"


@interface kZPagedScrollView()
{
    NSMutableSet  *visibleViews;
    NSMutableSet  *reuseCircleViews;
    kZPageViewItem *currentItem;
    NSInteger     currentIndex;
    NSInteger     totalNumber;
}
@end

@implementation kZPagedScrollView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self stupView];
    }
    return self;
}

-(void)dealloc{
    [visibleViews removeAllObjects];
    visibleViews = nil;
    [reuseCircleViews removeAllObjects];
    reuseCircleViews = nil;
    [super dealloc];
}

-(void)stupView{
    self.delegate = self;
    self.pagingEnabled = YES;
    visibleViews = [[NSMutableSet alloc] init];
    reuseCircleViews = [[NSMutableSet alloc] init];
    self.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.backgroundColor = [UIColor blackColor];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layOutSubviewWithFrame:frame];
}

-(void)layOutSubviewWithFrame:(CGRect)aFrame{
    for (kZPageViewItem *item in visibleViews) {
        item.frame = [self getRectAtIndex:item.tag];
        [self addSubview:item];
    }
    CGPoint offset = CGPointMake(self.bounds.size.width * currentIndex, 0);
    [self setContentOffset:offset animated:NO];
    [self setContentSizeOfScrollView];
}

-(void)oritationChangedReLayoutImageviews{
    for (kZPageViewItem *item in visibleViews) {
        item.bounds = CGRectMake(0, 0, self.bounds.size.width - SPACEWIDTH, self.bounds.size.height);
//        item.bounds = self.bounds;
        [item setImageViewFrame];
    }
    
    for (kZPageViewItem *item in reuseCircleViews) {
        item.bounds = CGRectMake(0, 0, self.bounds.size.width - SPACEWIDTH, self.bounds.size.height);
//        item.bounds = self.bounds;
    }
}

-(void)setContentSizeOfScrollView{
    NSInteger numberOfPage = 0;
    if ([_kzScrollViewDelegate respondsToSelector:@selector(numberOfPagesInScrollView:)]) {
        numberOfPage = [_kzScrollViewDelegate numberOfPagesInScrollView:self];
        totalNumber = numberOfPage;
    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width * numberOfPage, self.bounds.size.height);

}

-(kZPageViewItem *)getPageView:(NSInteger)aIndex{
    kZPageViewItem *vPageViewItem = nil;
    if (reuseCircleViews.count > 0) {
        for (kZPageViewItem *item in reuseCircleViews) {
            if ([item isKindOfClass:[kZPageViewItem class]]) {
                vPageViewItem = [item retain];
                break;
            }
        }
        if (vPageViewItem) {
            [reuseCircleViews removeObject:vPageViewItem];
        }
        if ([_kzScrollViewDelegate respondsToSelector:@selector(prepareToReusePageViewAtIndex:WithItem:)]) {
            [_kzScrollViewDelegate prepareToReusePageViewAtIndex:aIndex WithItem:vPageViewItem];
        }
    }else{
        if ([_kzScrollViewDelegate respondsToSelector:@selector(PagedViewItemForScrollViewAtIndex:)]) {
            vPageViewItem = [_kzScrollViewDelegate PagedViewItemForScrollViewAtIndex:aIndex];
        }
    }
    return vPageViewItem;
}

-(CGRect)getRectAtIndex:(NSInteger)aIndex{
    CGRect itemRect = CGRectMake(self.bounds.size.width * aIndex , 0, self.bounds.size.width - SPACEWIDTH, self.bounds.size.height);
    return itemRect;
}

-(BOOL)isDisPlayingIndex:(NSInteger)aIndex{
    for (kZPageViewItem *item in visibleViews) {
        if (item.tag == aIndex) {
            return YES;
        }
    }
    return NO;
}

/* 测试ShowPhoto[811:60b] _imageView.frame:{{-1.8020728e-06, 93.5}, {440, 293}}*/

-(void)tilePages{
    
    CGRect visibleBounds = self.bounds;
    int firstVisiblePage = floorf(CGRectGetMinX(visibleBounds)/visibleBounds.size.width);
    int lastVisiblePage =  floorf((CGRectGetMaxX(visibleBounds) -1 ) / visibleBounds.size.width);
    if (firstVisiblePage <0 || lastVisiblePage >= totalNumber) {
        return;
    }
    for (kZPageViewItem *item in visibleViews) {
        if (item.tag < firstVisiblePage || item.tag > lastVisiblePage) {
            [item removeFromSuperview];
            [reuseCircleViews addObject:item];
        }
    }
    
    [visibleViews minusSet:reuseCircleViews];
    
    for (int index = firstVisiblePage; index <= lastVisiblePage; index++) {
        if (![self isDisPlayingIndex:index]) {
            kZPageViewItem *pageViewItem = [self getPageView:index];
            pageViewItem.frame = [self getRectAtIndex:index];
            pageViewItem.tag = index;
            [self addSubview:pageViewItem];
            [visibleViews addObject:pageViewItem];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self tilePages];
    });
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    currentIndex = scrollView.contentOffset.x / self.bounds.size.width;
}

-(void)disPlayItemAtIndex:(NSInteger)aIndex{
    [self setContentSizeOfScrollView];
    CGPoint offset = CGPointMake(self.bounds.size.width * aIndex, 0);
    [self setContentOffset:offset animated:YES];
    [self tilePages];
}
@end
