//
//  TestStaticFunction.h
//  测试动画
//
//  Created by lin on 14-6-26.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <CoreGraphics/CoreGraphics.h>


static const float kWidth = 1000;
static const float Hight = 45.0;

static void kDrawCoorinateAix(CGContextRef context){
    CGContextSaveGState(context);
    
    CGContextBeginPath(context);
    //DrawX
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextMoveToPoint(context, -kWidth, 0.0);
    CGContextAddLineToPoint(context, kWidth, 0.0);
    CGContextDrawPath(context, kCGPathStroke);
    
    //DrawY
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
    CGContextMoveToPoint(context, .0, Hight);
    CGContextAddLineToPoint(context, 0.0, -Hight);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}

