//
//  StringHelper.m
//  CTBNewProject
//
//  Created by klbest1 on 13-12-5.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

//计算字符个数
+ (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}
//计算字符串高度和宽度
+(CGSize)caluateStrLength:(NSString *)aStr Front:(UIFont *)aFront ConstrainedSize:(CGSize)aSize
{
//    CGSize vStrSize = [aStr sizeWithFont:aFront constrainedToSize:aSize];
    CGSize vStrSize = [aStr sizeWithFont:aFront constrainedToSize:aSize lineBreakMode:NSLineBreakByCharWrapping];
    return vStrSize;
}

#pragma mark 判断中文，数字，字母，下划线
+ (BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string
{
    int len=string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ))
            return NO;
    }
    return YES;
}

#pragma mark 判断首位为字母
+ (BOOL)isLettersAtFirstCharactor:(NSString *)string
{
    int len=string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:0];
        if(!(isalpha(a)))
            return NO;
        break;
    }
    return YES;
}

#pragma mark 判断是否是字母数字下划线,
+ (BOOL)isLettersAndNumbersAndUnderScore:(NSString *)string
{
    int len=string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ))
            return NO;
    }
    return YES;
}

#pragma mark 获取URL链接文件名（含后缀）
+(NSString *)getFileNameFromURL:(NSString *)aURLStr
                      MiddleStr:(NSString *)aStr
                         Suffix:(NSString *)aSuffix
{
    NSString *vZipName = Nil;
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:aStr ];
    NSScanner* scanner = [[NSScanner alloc] initWithString:aURLStr];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        if ([pairString hasSuffix:aSuffix]) {
            vZipName = pairString;
            break;
        }
    }
    if (vZipName.length == 0) {
        LOG(@"getFileNameFromURL路径错误!");
    }
    return vZipName;
}

#pragma mark 获取某个字符串的最后所带的文件名 （不含后缀）
+(NSString *)getUNZipedFileName:(NSString *)aStr MiddleStr:(NSString *)aMiddeStr{
    NSString *vUNZipName = Nil;
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:aMiddeStr ];
    NSScanner* scanner = [[NSScanner alloc] initWithString:aStr];
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&vUNZipName];
        [scanner scanCharactersFromSet:delimiterSet intoString:nil];
        break;
    }
    return vUNZipName;
}
@end
