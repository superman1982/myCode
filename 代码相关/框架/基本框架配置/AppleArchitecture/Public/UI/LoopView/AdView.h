//
//  AdView.h
//  TestSingleMapView
//
//  Created by klbest1 on 13-11-29.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdViewDelegate <NSObject>

-(void)didAdViewClicked:(id)sender;
@end
@interface AdView : UIView

@property (nonatomic,assign) id<AdViewDelegate> delegate;

//广告初始位置
- (id)initWithFrame:(CGRect)frame;
//添加竖向轮播文字
-(void)addAdsFromVertical:(NSArray *)aAdsArray;
//添加横向轮播文字
-(void)addAdsViewFromHorizontal:(NSArray *)aAdsArray;
@end
