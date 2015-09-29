//
//  AdView.m
//  TestSingleMapView
//
//  Created by klbest1 on 13-11-29.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import "AdView.h"
#import "Macros.h"
#import "AnimationTransition.h"

#define VerticalAdWidth     300

@interface AdView ()

{
    UIView *mAdsView;  //添加广告的view
    NSTimer *mAdsTimer;  //移动广告的timer
}

@end

@implementation AdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commInit:frame];
    }
    return self;
}

-(void)commInit:(CGRect)aFrame
{
    mAdsView = [[UIView alloc] init];
    self.clipsToBounds = YES;
}

-(CGSize)caluateStrLength:(NSString *)aStr Front:(UIFont *)aFront ConstrainedSize:(CGSize)aSize
{
    CGSize vStrSize = [aStr sizeWithFont:aFront constrainedToSize:aSize];
    
    return vStrSize;
}

-(void)addAdsViewFromHorizontal:(NSArray *)aAdsArray
{
    if (aAdsArray.count == 0) {
        NSLog(@"传入广告为空!");
        return;
    }
    CGSize vConstrainedSize = CGSizeMake(CGFLOAT_MAX, 21);
    UIFont *vFront = [UIFont systemFontOfSize:14];
    //将广告内容Lable添加到mAdsView上，动态改变mAdsView的宽
    for ( int i = 0; i < aAdsArray.count; i++) {
        NSString *AdStr = [aAdsArray objectAtIndex:i];
        //计算广告文字要显示的宽
        CGSize vAdSize = [self caluateStrLength:AdStr Front:vFront ConstrainedSize:vConstrainedSize];
        //根据广告文字长度设置Lable宽
        UILabel *vAdLable = [[UILabel alloc] initWithFrame:CGRectMake (mAdsView.frame.size.width + 50,0, vAdSize.width, 21)];
        vAdLable.text = AdStr;
        vAdLable.font = vFront;
        
        [mAdsView addSubview:vAdLable];
        //重新设置mAdsView的宽
        [mAdsView setFrame:CGRectMake(0, 0, mAdsView.frame.size.width + vAdLable.frame.size.width + 50, 21)];
        
    }
    [self addSubview:mAdsView];

    //移动广告
    [self changeAdsHorizontal];
}

-(void)addAdsFromVertical:(NSArray *)aAdsArray
{
    if (aAdsArray.count == 0) {
        NSLog(@"传入广告为空!");
        return;
    }
    CGSize vConstrainedSize = CGSizeMake(VerticalAdWidth, CGFLOAT_MAX);
    UIFont *vFront = [UIFont systemFontOfSize:15];
    //将广告内容Lable添加到mAdsView上，动态改变mAdsView的宽
    for ( int i = 0; i < aAdsArray.count; i++) {
        NSString *vAdStr = [aAdsArray objectAtIndex:i];
        vAdStr = [NSString stringWithFormat:@"  •%@",vAdStr];
        //计算广告文字要显示的宽
        CGSize vAdSize = [self caluateStrLength:vAdStr Front:vFront ConstrainedSize:vConstrainedSize];
        float vAdHeight = vAdSize.height> 44 ? vAdSize.height : 44;
        //根据广告文字长度设置Lable宽
        UILabel *vAdLable = [[UILabel alloc] initWithFrame:CGRectMake (0,mAdsView.frame.origin.y + mAdsView.frame.size.height, 320, vAdHeight)];
        [vAdLable setNumberOfLines:0];
        vAdLable.text = vAdStr;
        vAdLable.font = vFront;
        vAdLable.layer.borderWidth = 0.5;
        vAdLable.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
        //为广告添加点击事件
        UIButton *vAdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vAdButton setFrame:vAdLable.frame];
        [vAdButton setTag:i];
        [vAdButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [mAdsView addSubview:vAdLable];
        [mAdsView addSubview:vAdButton];
        //重新设置mAdsView的宽
        [mAdsView setFrame:CGRectMake(0, 0, 320, mAdsView.frame.size.height + vAdLable.frame.size.height)];
        
    }
    [self addSubview:mAdsView];
    //移动广告
    [self changeAdsVertical];
    
}

-(void)changeAdsVertical{
    mAdsTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(adsChangingVertical:) userInfo:nil repeats:YES];
}

-(void)changeAdsHorizontal{
    mAdsTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(adsChangingHorizontal:) userInfo:nil repeats:YES];
}

-(void)adsChangingHorizontal:(id)sender{
   
    //mAdsView完全移动到左边时，又重新初始化mAdsView的位置
    if (mAdsView.frame.origin.x <= -mAdsView.frame.size.width) {
        mAdsView.frame = CGRectMake(250, mAdsView.frame.origin.y, mAdsView.frame.size.width, mAdsView.frame.size.height);
    }
    
    [UIView beginAnimations:@"" context:@""];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    mAdsView.frame = CGRectMake(mAdsView.frame.origin.x- 4, mAdsView.frame.origin.y, mAdsView.frame.size.width, mAdsView.frame.size.height);
    
    [UIView commitAnimations];
}

//移动广告
-(void)adsChangingVertical:(id)sender{
    //mAdsView完全移动到上面时，又重新初始化mAdsView的位置
    if (mAdsView.frame.origin.y <= -mAdsView.frame.size.height) {
        mAdsView.frame = CGRectMake(0, self.frame.size.height, mAdsView.frame.size.width, mAdsView.frame.size.height);
    }
    
    [UIView beginAnimations:@"" context:@""];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    mAdsView.frame = CGRectMake(mAdsView.frame.origin.x, mAdsView.frame.origin.y - 4, mAdsView.frame.size.width, mAdsView.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark - 其他业务点击事件
-(void)addButtonClicked:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(didAdViewClicked:)]) {
        [_delegate didAdViewClicked:[NSNumber numberWithInt:sender.tag]];
    }
}
@end
