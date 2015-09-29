//
//  SKWebParser.m
//  Seework
//
//  Created by lin on 15-5-7.
//  Copyright (c) 2015年 seeyon. All rights reserved.
//

#import "SKWebParser.h"

#define Local_Set       @"setting://address"
#define Cmp_ReadFile    @"cmp_ios_params="
#define Has_Message     @"_has_message"
#define Fetch_Queue     @"cworkjsbridge://_fetch_queue/"


@implementation SKWebParser

+(id)stringToJsonData:(NSString *)aStr{
    [aStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *vParameterData = [aStr dataUsingEncoding:NSUTF8StringEncoding];
    id jsonDta = [NSJSONSerialization JSONObjectWithData:vParameterData options:NSJSONReadingMutableContainers error:nil];
    return jsonDta;
}

+ (SKWebURLType)webUrlStr:(NSString *)url // 截取来自UIWebView的url
{
    NSRange ns = [url rangeOfString:Local_Set];
    if (ns.location != NSNotFound) {
        return SKWebSetLink;
    }
    ns = [url rangeOfString:Cmp_ReadFile];
    if (ns.location != NSNotFound) {
        return SKWebReadFileLink;
    }
    ns = [url rangeOfString:Has_Message];
    if (ns.location != NSNotFound) {
        return SKWebHasMessage;
    }
    ns = [url rangeOfString:Fetch_Queue];
    if (ns.location != NSNotFound) {
        return SKWebFetchQueue;
    }

    return 0;
}

+(NSString *)readCmpFile:(NSString *)aFileName{
    NSString *appPath = [[NSBundle mainBundle] resourcePath];
    NSString *vFilePath = [appPath stringByAppendingFormat:@"/JSCode/%@.js",aFileName];
//    NSString *vFilePath =[[NSBundle mainBundle] pathForResource:aFileName ofType:@"js"];
    NSString *vFileStr = [NSString stringWithContentsOfFile:vFilePath encoding:NSUTF8StringEncoding error:nil];
    return vFileStr;
}

+(NSString *)getFileData:(NSString *)aParameterStr{
    NSMutableString *vFiledataStr = [NSMutableString stringWithCapacity:0];
    
    //将参数传字典
    NSRange vRange = [aParameterStr rangeOfString:Cmp_ReadFile];
    NSInteger vLocationJson = vRange.location + vRange.length ;
    
    NSString *vSubParameterStr = [aParameterStr substringFromIndex:vLocationJson];
    NSString *vJsonStr = [vSubParameterStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *vParameterData = [vJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *vDic = [NSJSONSerialization JSONObjectWithData:vParameterData options:NSJSONReadingMutableContainers error:nil];
    if([[vDic objectForKey:@"action"] isEqualToString:@"readFile"]){
        //获取文件名
        NSArray *vFileNameArray = [vDic objectForKey:@"args"];
        for (NSString *fileName in vFileNameArray) {
            NSString *vDataStr = [self readCmpFile:fileName];
            if (vDataStr != nil) {
                [vFiledataStr appendString:vDataStr];
            }
        }
    }

    return vFiledataStr;
}

+(NSArray *)handleURLParameters:(NSString *)aURLStr{
    NSString *jsonParameter = [aURLStr stringByReplacingOccurrencesOfString:Fetch_Queue withString:@""];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
    jsonParameter = [jsonParameter stringByReplacingPercentEscapesUsingEncoding:enc];
    
    NSArray *arrayOfParameter = [SKWebParser stringToJsonData:jsonParameter];
    return arrayOfParameter;
}

@end
