//
//  kZPagedScrollView.h
//  测试ShowPhoto
//
//  Created by lin on 14-9-29.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kZPageViewItem.h"

@class kZPagedScrollView;
@protocol kZPagedScrollViewDelegate <NSObject>

-(NSInteger)numberOfPagesInScrollView:(kZPagedScrollView *)aView;
-(void)prepareToReusePageViewAtIndex:(NSInteger)aIndex WithItem:(kZPageViewItem *)aPageItem;
-(kZPageViewItem *)PagedViewItemForScrollViewAtIndex:(NSInteger)aIndex;

@end

@interface kZPagedScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,retain) id<kZPagedScrollViewDelegate> kzScrollViewDelegate;
@property (nonatomic,assign) BOOL       orentationisChanged;

-(void)disPlayItemAtIndex:(NSInteger)aIndex;

-(void)oritationChangedReLayoutImageviews;
@end
