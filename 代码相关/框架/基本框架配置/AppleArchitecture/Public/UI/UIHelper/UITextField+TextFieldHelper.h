//
//  UITextField+TextFieldHelper.h
//  BaseArchitecture
//
//  Created by lin on 14-8-7.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TextFieldHelper)
+(UITextField *)createTextFieldWithFrontSize:(CGFloat)aFrontSize
                                    Delegate:(id)aDelegate
                                 PlaceHolder:(NSString *)aPlaceHolder
                            BackGroundColoer:(UIColor *)aColor;
@end
