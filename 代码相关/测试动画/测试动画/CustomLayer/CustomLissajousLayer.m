//
//  CustomLissajousLayer.m
//  测试动画
//
//  Created by lin on 14-6-26.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "CustomLissajousLayer.h"
#import "TestStaticFunction.h"

static NSString * const keyForAmplitude = @"amplitude";
static NSString * const keyForA = @"a";
static NSString * const keyForB = @"b";
static NSString * const keyForDelta = @"delta";
static const CGFloat TWO_PI = (CGFloat) (M_PI * 2.0f);


@implementation CustomLissajousLayer
@dynamic amplitude;
@dynamic a;
@dynamic b;
@dynamic delta;


-(id)init{
    self = [super init];
    if (self) {
        if (keySets == nil) {
            keySets = [[NSMutableSet alloc] initWithObjects:keyForAmplitude,keyForA,keyForB,keyForDelta, nil];
        }
        if (animationArray == nil) {
            animationArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

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

-(void)drawInContext:(CGContextRef)ctx{
    [super drawInContext:ctx];
    CGContextTranslateCTM(ctx, CGRectGetWidth([self bounds]) / 2, CGRectGetHeight([self bounds]) / 2.0);
    kDrawCoorinateAix(ctx);
    
    CGFloat amplitude = [[(NSValue *)[self presentationLayer] valueForKey:keyForAmplitude] floatValue];
    float a =[[(NSValue *)[self presentationLayer] valueForKey:keyForA] floatValue];
    float b =[[(NSValue *)[self presentationLayer] valueForKey:keyForB] floatValue];
    float delat = [[(NSValue *)[self presentationLayer] valueForKey:keyForDelta] floatValue];
    float increment = TWO_PI /(a*b *40.0);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetShadow(ctx, CGSizeMake(0.0, 2.5), 5.0);
    BOOL shouldMoveToPoint = YES;
    CGMutablePathRef path = CGPathCreateMutable();
    for (float t = 0.0; t < M_2_PI +increment; t += increment) {
        CGFloat x = amplitude * sin(a*t +delat);
        CGFloat y = amplitude * sin(b*t);
        if (shouldMoveToPoint) {
            CGPathMoveToPoint(path, NULL, x, y);
            shouldMoveToPoint = NO;
        }else{
            CGPathAddLineToPoint(path, NULL, x, y);
        }
    }
    
    CGContextAddPath(ctx, path);
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
    CGContextStrokePath(ctx);
    CFRelease(path);
}

-(id<CAAction>)actionForKey:(NSString *)event{
    NSLog(@"Event:%@",event);
    if ([keySets member:event]) {
        CABasicAnimation *vAnimation = [CABasicAnimation animation];
        vAnimation.fromValue = [[self presentationLayer] valueForKey:event];
        [vAnimation setDelegate:self];
        vAnimation.duration = 1;
        return vAnimation;
    }{
      return   [super actionForKey:event];
    }
    
}


- (void)animationDidStart:(CAAnimation *)anim{
    if ([anim isKindOfClass:[CAPropertyAnimation class]]) {
        NSString *key = [(CAPropertyAnimation *)anim keyPath];
        if ([keySets member:key]) {
            [animationArray addObject:anim];
            if (displayLink == nil) {
                displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkFunction:)];
                [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            }
        }
    }
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [animationArray removeObject:anim];
    if (animationArray.count == 0) {
        [displayLink invalidate];
        displayLink = nil;
        [self setNeedsDisplay];
    }
}

-(void)linkFunction:(id)sender{
    [self setNeedsDisplay];
}

@end



