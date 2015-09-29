//
//  CheckManeger.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "CheckManeger.h"
#import "StringHelper.h"

@implementation CheckManeger

#pragma mark 检查是否是合法的电话号码
+(BOOL)checkIfIsAllowedPhoneNumber:(NSString *)aPhone{
    int len=aPhone.length;
    if (len != 11) {
        return NO;
    }
    
   return  [CheckManeger checkIfIsDigits:aPhone];
    
}

#pragma mark 检查是否是数字
+(BOOL)checkIfIsDigits:(NSString *)aStr{
    int len=aStr.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[aStr characterAtIndex:i];
        //检查是否是数字
        if(!(isalnum(a))) {
            return NO;
        }
    }
    
    return YES;
}
#pragma mark 检查是否是合法的车牌
+(BOOL)checkIfIsAllowedCarLisence:(NSString *)aLisence{
    int len = aLisence.length;
    if (len != 7) {
        return NO;
    }
    //第二位为大写字母
    unichar vSecondChar = [aLisence characterAtIndex:1];
    if (!(isupper(vSecondChar))) {
        return NO;
    }
    return YES;
}

#pragma mark 判断是否是字母数字
+ (BOOL)isLettersAndNumbers:(NSString *)string
{
    int len=string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ))
            return NO;
    }
    return YES;
}
@end
