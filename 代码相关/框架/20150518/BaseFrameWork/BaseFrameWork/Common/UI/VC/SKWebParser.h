//
//  SKWebParser.h
//  Seework
//
//  Created by lin on 15-5-7.
//  Copyright (c) 2015年 seeyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKWebParser : NSObject

typedef NS_ENUM(NSInteger, SKWebURLType) {
    SKWebSetLink = 1000,
    SKWebReadFileLink,
    SKWebHasMessage,
    SKWebFetchQueue,
};

+ (SKWebURLType)webUrlStr:(NSString *)url; // 截取来自UIWebView的url
//获取JS本地文件
+(NSString *)getFileData:(NSString *)aParameterStr;
//获取单个JS文件
+(NSString *)readCmpFile:(NSString *)aFileName;
//处理url参数
+(NSArray *)handleURLParameters:(NSString *)aURLStrl;
@end
 