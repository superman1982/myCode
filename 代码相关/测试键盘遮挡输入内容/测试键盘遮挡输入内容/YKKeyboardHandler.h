//
//  KBKeyboardHandler.h
//  测试键盘遮挡输入内容
//
//  Created by lin on 15/11/15.
//  Copyright © 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KBKeyboardHandlerDelegate

- (void)keyboardSizeChanged:(CGSize)delta;

@end
@interface YKKeyboardHandler : NSObject

- (id)init;

// Put 'weak' instead of 'assign' if you use ARC
@property(nonatomic, assign) id<KBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end