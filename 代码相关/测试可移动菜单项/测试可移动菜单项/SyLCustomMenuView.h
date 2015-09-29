//
//  CustomMenuView.h
//  测试可移动菜单项
//
//  Created by lin on 14-6-6.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyLMenuItem.h"

@interface SyLCustomMenuView : UIView
{
    BOOL    isHold;
    SyLMenuItem *mCurrentMenuItem;
    CGPoint currentTouchPoint;
}
//保存menuitem坐标
@property (nonatomic,retain)      NSMutableArray *menuItemFrames;
//保存Menuitem对象
@property (nonatomic,retain)      NSMutableArray *menuItemInfoArray;
//判断menuitem是否长按
@property (nonatomic,retain)      NSTimer        *holdTimer;
@property (nonatomic,assign)      id             delegate;

- (id)initWithFrame:(CGRect)frame withCloum:(NSInteger)aCloumn Row:(NSInteger)aRow;
@end

@protocol SyLCustomMenuViewDelegate <NSObject>
-(void)didClickedMenuItem:(SyLMenuItem *)sender;

@end