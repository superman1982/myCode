//
//  StringHelper.h
//  CTBNewProject
//
//  Created by klbest1 on 13-12-5.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringHelper : NSObject

//计算字符串个数，按中文个数，两个英文字母算一个字
+ (int)textLength:(NSString *)text;

//计算字符串高度和宽度
+(CGSize)caluateStrLength:(NSString *)aStr Front:(UIFont *)aFront ConstrainedSize:(CGSize)aSize;
//获取下载URL文件名：aSuffix,URL的文件名后缀， middleStr文件名与后缀中间的分隔字符
+(NSString *)getFileNameFromURL:(NSString *)aURLStr
                      MiddleStr:(NSString *)aStr
                         Suffix:(NSString *)aSuffix;
//获取字符串中的某部分字符如：vip.zip 中的vip
+(NSString *)getUNZipedFileName:(NSString *)aStr MiddleStr:(NSString *)aMiddeStr;
#pragma mark 判断是否是字母数字下划线
+ (BOOL)isLettersAndNumbersAndUnderScore:(NSString *)string;
#pragma mark 判断首位为字母
+ (BOOL)isLettersAtFirstCharactor:(NSString *)string;
@end
