//
//  UIView+ViewAnimation.h
//  测试动画
//
//  Created by lin on 14-6-3.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (ViewAnimation)
//帧动画
-(void)roate360DegreeAnimation:(float )aDuration;
//模拟移除页面，弹出新的页面
-(void)scaleOutAnimation:(float)aDuration;
//CoreAnimation Demo
//组和动画
-(void)animationWithGroup;
//3d放大缩小
-(void)animationWith3DScale;
//摇晃
-(void)animationWithWiggle;
//按照路径进行帧动画
-(void)animationFollowPath;
@end
