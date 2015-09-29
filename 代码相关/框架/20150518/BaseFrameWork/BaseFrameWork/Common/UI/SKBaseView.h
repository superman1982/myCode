//
//  SkBaseView.h
//  BaseFrameWork
//
//  Created by lin on 15-1-14.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKBaseView : UIView

@property (nonatomic,assign) float  width;

@property (nonatomic,assign) float height;
-(void)setupViews;
-(void)setupForPhone;
-(void)setupForPad;
-(void)layoutWithFrame:(CGRect)aFrame;
-(void)layoutForPhonePoraitWithFrame:(CGRect)aFrame;
-(void)layouForPhoneLandScapeWithFrame:(CGRect)aFrame;
-(void)layoutForPadPoraitWithFrame:(CGRect)aFrame;
-(void)layouForPadLandScapeWithFrame:(CGRect)aFrame;
@end
