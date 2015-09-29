//
//  CheckManeger.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckManeger : NSObject

#pragma mark 检查是否是数字
+(BOOL)checkIfIsDigits:(NSString *)aStr;
#pragma mark 检查是否是合法的电话号码
+(BOOL)checkIfIsAllowedPhoneNumber:(NSString *)aPhone;
#pragma mark 检查是否是合法的车牌
+(BOOL)checkIfIsAllowedCarLisence:(NSString *)aLisence;
#pragma mark 判断是否是字母数字
+ (BOOL)isLettersAndNumbers:(NSString *)string;
@end
