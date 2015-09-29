//
//  UITextField+TextFieldHelper.m
//  BaseArchitecture
//
//  Created by lin on 14-8-7.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "UITextField+TextFieldHelper.h"

@implementation UITextField (TextFieldHelper)

+(UITextField *)createTextFieldWithFrontSize:(CGFloat)aFrontSize
              Delegate:(id)aDelegate
           PlaceHolder:(NSString *)aPlaceHolder
      BackGroundColoer:(UIColor *)aColor
{
    UITextField *vFiled = [[UITextField alloc] init];
    vFiled.borderStyle = UITextBorderStyleNone;
    vFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    vFiled.font = [UIFont systemFontOfSize:aFrontSize];
    vFiled.delegate = aDelegate;
    vFiled.placeholder = aPlaceHolder;
    vFiled.backgroundColor = aColor;
    vFiled.returnKeyType = UIReturnKeyDone;
    return vFiled;
}

@end
