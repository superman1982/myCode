//
//  MenuRoundAnimationView.m
//  测试动画
//
//  Created by lin on 14-6-4.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "MenuRoundAnimationView.h"

#define BUTTON_TAG_START 1000

#define MENU_EXPAND_RADIUS 120

#define MAX_MENU_EXPAND_RADIUS MENU_EXPAND_RADIUS+12

#define MIN_MENU_EXPAND_RADIUS  MENU_EXPAND_RADIUS -12

@implementation MenuRoundAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        if (mButtonArrays == nil) {
            mButtonArrays = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void)dealloc{
    [mButtonArrays removeAllObjects],[mButtonArrays release],mButtonArrays = nil;
    [super dealloc];
}

-(void)setMenuInfo:(NSArray *)aItemsInfo CenterItem:(NSDictionary *)aDic{
    UIButton *vCenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *vNomalImageStr = [aDic objectForKey:NOMAL_KEY];
    NSString *vSeletedImageStr = [aDic objectForKey:SELETED_KEY];
    int      vWidth = [[aDic objectForKey:IMAGE_WIDTH_KEY] intValue];
    [vCenterButton setFrame:CGRectMake(0, 0, vWidth, vWidth)];
    [vCenterButton setBackgroundImage:[UIImage imageNamed:vNomalImageStr] forState:UIControlStateNormal];
    [vCenterButton setBackgroundImage:[UIImage imageNamed:vSeletedImageStr] forState:UIControlStateSelected];
    [vCenterButton setCenter:self.center];
    [vCenterButton setTag:BUTTON_TAG_START];
    [self addSubview:vCenterButton];
    [vCenterButton addTarget:self action:@selector(centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    mCenterRect = vCenterButton.frame;
    mCenterPoint = vCenterButton.center;
    
    int vTag = 0;
    for (NSDictionary *lDic in aItemsInfo) {
        vTag++;
        UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
        int      lWidth = [[lDic objectForKey:IMAGE_WIDTH_KEY] intValue];
        NSString *lNomalImageStr = [lDic objectForKey:NOMAL_KEY];
        NSString *lSeletedImageStr = [lDic objectForKey:SELETED_KEY];
        [lButton setFrame:CGRectMake(0, 0, lWidth, lWidth)];
        [lButton setBackgroundImage:[UIImage imageNamed:lNomalImageStr] forState:UIControlStateNormal];
        [lButton setBackgroundImage:[UIImage imageNamed:lSeletedImageStr] forState:UIControlStateSelected];
        [lButton setCenter:self.center];
        [lButton setTag:(BUTTON_TAG_START + vTag)];
        lButton.alpha = 0;
        [lButton addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mButtonArrays addObject:lButton];
        [self addSubview:lButton];
    }
}

-(void)centerButtonClicked:(UIButton *)sender{
    isOpen > 0 ? [self closeAnimation] : [self openAnimation];
}

-(void)itemButtonClicked:(UIButton *)sender{
}

-(void)openAnimation{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setButtonsExpandLocation:MAX_MENU_EXPAND_RADIUS];
        for (UIButton *lButton in mButtonArrays) {
            lButton.alpha = 1;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            [self setButtonsExpandLocation:MENU_EXPAND_RADIUS];
        } completion:^(BOOL finished) {
            isOpen = YES;
        }];
    }];
}

-(void)closeAnimation{
    [UIView animateWithDuration:.3 animations:^{
        [self setButtonsExpandLocation:0];
        for (UIButton *lButton in mButtonArrays) {
            lButton.alpha = 0;
        }
    } completion:^(BOOL finished) {
        isOpen = NO;
    }];
}

-(void)setButtonsExpandLocation:(float)aRadius{
    float vDegree = 60/180.0 * M_PI;
    float vWidth = aRadius * cosf(vDegree);
    float vHight = aRadius * sinf(vDegree);
    
    switch (mButtonArrays.count) {
        case 2:
        {
            UIButton *vButtonOne = [mButtonArrays objectAtIndex:0];
            UIButton *vButtonTwo = [mButtonArrays objectAtIndex:1];
            CGRect vCenterRectOne = CGRectMake(mCenterRect.origin.x - vWidth, mCenterRect.origin.y- vHight,vButtonOne.frame.size.width,vButtonOne.frame.size.height);
            CGRect vCenterRectTwo = CGRectMake(mCenterRect.origin.x + vWidth, mCenterRect.origin.y - vHight, mCenterRect.size.width, mCenterRect.size.height);
            [vButtonOne setFrame:vCenterRectOne];
            [vButtonTwo setFrame:vCenterRectTwo];
        }
            break;
        case 3:
        {
            UIButton *vButtonOne = [mButtonArrays objectAtIndex:0];
            UIButton *vButtonTwo = [mButtonArrays objectAtIndex:1];
            UIButton *vButtonThree = [mButtonArrays objectAtIndex:2];
            CGPoint vCenterPointOne = CGPointMake(mCenterPoint.x, mCenterPoint.y - aRadius);
            CGPoint vCenterPointTwo = CGPointMake(mCenterPoint.x + vHight, mCenterPoint.y + vWidth);
            CGPoint vCenterPointThree = CGPointMake(mCenterPoint.x - vHight, mCenterPoint.y + vWidth);
            [vButtonOne setCenter:vCenterPointOne];
            [vButtonTwo setCenter:vCenterPointTwo];
            [vButtonThree setCenter:vCenterPointThree];
        }
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
        default:
            break;
    }
}

@end
