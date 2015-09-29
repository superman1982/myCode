//
//  UIView+ViewAnimation.m
//  测试动画
//
//  Created by lin on 14-6-3.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "UIView+ViewAnimation.h"

@implementation UIView (ViewAnimation)

-(void)roate360DegreeAnimation:(float )aDuration{
    CAKeyframeAnimation *vKeyAnimation = [CAKeyframeAnimation animation];
    vKeyAnimation.values = @[
                             [NSValue valueWithCATransform3D: CATransform3DMakeRotation(0.0, 0, 1, 0)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 1, 0)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 1, 0)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.26, 0, 1, 0)],
                             ];
    vKeyAnimation.cumulative = YES;
    vKeyAnimation.repeatCount = 1;
    vKeyAnimation.duration = aDuration;
    vKeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:vKeyAnimation forKey:@"transform"];
}

-(void)animationWithGroup{
//    NSArray *vLayerArray = [self.layer.sublayers copy];
//    [vLayerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//    
//    CALayer *vLayer = [[CALayer alloc] init];
//    vLayer.backgroundColor = [UIColor grayColor].CGColor;
//    vLayer.frame = CGRectMake(10, 10, 40, 40);
//    vLayer.cornerRadius = 5;
    //平移
    CABasicAnimation *vMoveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    vMoveAnimation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    CGPoint vToPoint = self.layer.position;
    vToPoint.x = vToPoint.x + 180;
    vMoveAnimation.toValue = [NSValue valueWithCGPoint:vToPoint];
    //旋转
    CABasicAnimation *vRotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    vRotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    vRotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 6];
    
    //放大缩小
    CABasicAnimation *vScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    vScaleAnimation.autoreverses = YES;
    vScaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    vScaleAnimation.fromValue = [NSNumber numberWithFloat:2.5];
    vScaleAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *vGroupAnimation = [CAAnimationGroup animation];
    vGroupAnimation.autoreverses = NO;
    vGroupAnimation.duration = 3.0;
    vGroupAnimation.animations = [NSArray arrayWithObjects:
                                  vMoveAnimation,
                                  vRotateAnimation,
                                  vScaleAnimation,
                                  nil];
    vGroupAnimation.fillMode = kCAFillModeForwards;
    vGroupAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:vGroupAnimation forKey:@"test"];
}

-(void)animationWith3DScale{
    if ([self.layer animationForKey:@"transform"] != nil) {
        return;
    }
    CABasicAnimation *transFromAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [transFromAnimation setRepeatCount:1000];
    [transFromAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transFromAnimation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    CATransform3D v3DTransForm = CATransform3DMakeScale(0.5, .5, 1);

    [transFromAnimation setToValue:[NSValue valueWithCATransform3D:v3DTransForm]];
    [transFromAnimation setAutoreverses:YES];
    transFromAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:transFromAnimation forKey:@""];
}

-(void)animationWithWiggle{
    if ([self.layer animationForKey:@"wiggle"] != nil) {
        return;
    }
    CABasicAnimation *vWiggleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [vWiggleAnimation setRepeatCount:CGFLOAT_MAX];
    [vWiggleAnimation setDuration:.1];
    [vWiggleAnimation setFromValue:[NSNumber numberWithFloat: M_PI /100]];
    [vWiggleAnimation setAutoreverses:YES];
    [vWiggleAnimation setToValue:[NSNumber numberWithFloat: -M_PI /100]];
    [self.layer addAnimation:vWiggleAnimation forKey:@"wiggle"];
}

-(void)scaleOutAnimation:(float)aDuration{
    [UIView animateWithDuration:aDuration animations:^{
        CGAffineTransform vTransform = CGAffineTransformScale(CGAffineTransformIdentity, .05, .05);
        [self setTransform:vTransform];
    } completion:^(BOOL finished) {
        CGAffineTransform vTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        [self setTransform:vTransform];
        
        vTransform = CGAffineTransformMakeTranslation(320, self.frame.origin.y);
        [self setTransform:vTransform];
        
        [UIView animateWithDuration:aDuration animations:^{
            CGAffineTransform vTransform = CGAffineTransformMakeTranslation(0, self.frame.origin.y);
            [self setTransform:vTransform];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)animationFollowPath{
    CGMutablePathRef vPath = CGPathCreateMutable();
    CGPathMoveToPoint(vPath, NULL, 20, 30);
    CGPathAddLineToPoint(vPath, NULL, 200, 100);
    CGPathAddCurveToPoint(vPath, NULL, 60, 150, 40,300, 200, 340);
    CGPathAddArc(vPath, NULL, 200, 340, 60, 0 ,M_PI, NO);
    
    [self.layer removeAllAnimations];
    CAKeyframeAnimation *vAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [vAnimation setPath:vPath];
    [vAnimation setCalculationMode:kCAAnimationCubic];
    [vAnimation setRotationMode:kCAAnimationRotateAuto];
    [vAnimation setRepeatCount:CGFLOAT_MAX];
    [vAnimation setAutoreverses:YES];
    [vAnimation setDuration:3];
    [self.layer addAnimation:vAnimation forKey:@"path"];    
}

@end
