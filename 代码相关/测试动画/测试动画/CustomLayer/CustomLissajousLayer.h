//
//  CustomLissajousLayer.h
//  测试动画
//
//  Created by lin on 14-6-26.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
/*    BOOL shouldMoveToPoint = YES;
 
 for (CGFloat t = 0.0; t < TWO_PI + increment; t = t + increment) {
 CGFloat x = amplitude * sin(a * t + delta);
 CGFloat y = amplitude * sin(b * t);
 if (shouldMoveToPoint) {
 CGPathMoveToPoint(path, NULL, x, y);
 shouldMoveToPoint = NO;
 } else {
 CGPathAddLineToPoint(path, NULL, x, y);
 }
 }*/
@interface CustomLissajousLayer : CALayer
{
    NSMutableSet *keySets;
    NSMutableArray *animationArray;
    CADisplayLink *displayLink;
}
@property (nonatomic,assign) CGFloat amplitude;

@property (nonatomic,assign) CGFloat a;

@property (nonatomic,assign) CGFloat b;

@property (nonatomic,assign) CGFloat delta;

@end
