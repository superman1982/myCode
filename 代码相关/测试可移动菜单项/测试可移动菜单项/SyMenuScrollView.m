//
//  SyMenuScrollView.m
//  M1IPhone
//
//  Created by guoyl on 12-11-25.
//  Copyright (c) 2012年 北京致远协创软件有限公司. All rights reserved.
//

#import "SyMenuScrollView.h"

@implementation SyMenuScrollView

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

@end
