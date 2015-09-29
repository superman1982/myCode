//
//  HitView.m
//  测试滑动删除Cell
//
//  Created by lin on 14-8-12.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "SKHitView.h"

@implementation SKHitView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(hitViewHitTest:withEvent:TouchView:)]) {
       return  [_delegate hitViewHitTest:point withEvent:event TouchView:self];
    }
    return nil;
}

@end
