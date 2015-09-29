//
//  TestMenuItem.h
//  M1IPhone
//
//  Created by lin on 14-6-6.
//  Copyright (c) 2014年 北京致远协创软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyLMenuItem : UIControl
{
    CGRect mOriginFrame;
}
@property (nonatomic,retain) UIImageView *backImageView;

@property (nonatomic,assign) BOOL       isDraged;

@property (nonatomic,assign) NSInteger  itemIndex;

@end
