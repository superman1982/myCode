//
//  TestMenuItem.m
//  M1IPhone
//
//  Created by lin on 14-6-6.
//  Copyright (c) 2014年 北京致远协创软件有限公司. All rights reserved.
//

#import "SyLMenuItem.h"

@implementation SyLMenuItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mOriginFrame = frame;
        [self commInit];
        [self setBackgroundColor:[UIColor orangeColor]];
    }
    return self;
}

-(void)commInit{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.frame];
    }
    [self addSubview:_backImageView];
}

-(void)dealloc{
    [_backImageView release],_backImageView = nil;
    [super dealloc];
}

-(void)setIsDraged:(BOOL)isDraged {
    [UIView animateWithDuration:.2 animations:^{
        NSLog(@"Drag，moved");
        if (isDraged) {
            CGRect vFrame = self.frame;
            vFrame.origin.x += 10;
            vFrame.origin.y  -= 10;
            self.frame = vFrame;
        }/*else{
            self.frame = mOriginFrame;
        }*/
    } completion:^(BOOL finished) {
        _isDraged = isDraged;
    }];
}


#pragma mark - Touch
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	[[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
	[[self nextResponder] touchesCancelled:touches withEvent:event];
}

@end
