//
//  HitView.h
//  测试滑动删除Cell
//
//  Created by lin on 14-8-12.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HitViewDelegate <NSObject>

-(UIView *)hitViewHitTest:(CGPoint)point withEvent:(UIEvent *)event TouchView:(UIView *)aView;

@end
@interface SKHitView : UIView

@property (nonatomic,assign) id<HitViewDelegate> delegate;
@end
