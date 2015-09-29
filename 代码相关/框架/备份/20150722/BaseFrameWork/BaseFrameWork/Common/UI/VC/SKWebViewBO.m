//
//  SKWebViewBO.m
//  Seework
//
//  Created by lin on 15/7/2.
//  Copyright (c) 2015年 seeyon. All rights reserved.
//

#import "SKWebViewBO.h"
#import "SKWelcomeViewController.h"

#define SK_GetLocation   @"getLocation"
#define SK_RemotePush    @"getPushConfig"
#define SK_CloseWindow   @"closeWindow"
#define SK_LoginSuccess  @"initCurrentUser"
#define SK_GrammerVoice  @"translateGrammarVoice"
#define SK_AppUserContact @"initUserNames"
#define SK_TranslateVoice @"translateVoice"
#define SK_GetContactList @"getContactList"
#define SK_ReMoveWelcomeViews  @"toIndex"

@interface SKWebViewBO()
{
    NSString *_callBack;
}
@end

@implementation SKWebViewBO

+(NSString *)cworkRemotePushJsonStringWithCallBack:(NSString *)aCallBack parameterStr:(NSString *)aStr{
    NSDictionary *vDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          aCallBack,@"callback",
                          aStr,@"parameters",
                          nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:vDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonStr autorelease];
}

+(NSString *)cworkVoiceRecognizeSuccesWithData:(NSString *)aResult callBack:(NSString *)aCallBack{
    NSDictionary *vDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"0",@"errorcode",
                          aResult,@"data",
                          nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:vDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    NSString *finalResultStr = [self cworkRemotePushJsonStringWithCallBack:aCallBack parameterStr:jsonStr];
    
    return finalResultStr;
}

+(NSString *)cworkVoiceRecognizeFailedWithErroCode:(int )aCode
                                           message:(NSString *)aMessage
                                          callBack:(NSString *)aCallBack{
    NSString *codeStr = [NSString stringWithFormat:@"%d",aCode];
    NSDictionary *vDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          codeStr,@"errorcode",
                          aMessage,@"errormsg",
                          nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:vDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    NSString *finalResultStr = [self cworkRemotePushJsonStringWithCallBack:aCallBack parameterStr:jsonStr];

    return finalResultStr;
}

+(NSString *)createPathInDocumentDirectory:(NSString *)aFileName{
    //获取沙盒中的文档目录
    NSArray *vDocumentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *vDocumentDirectory=[vDocumentDirectories objectAtIndex:0];
    NSString *vFilePath = [vDocumentDirectory stringByAppendingPathComponent:aFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:vFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:vFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return vFilePath;
}

-(void)dealloc{
    [_callBack release],_callBack = nil;
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)dealAction:(NSDictionary *)aDic webView:(UIWebView *)aWebView{
    NSString *handler  = [aDic objectForKey:@"handler"];
    _callBack = [[aDic objectForKey:@"callback"] retain];
    NSString *webNeedParameter = @"";
    
    if ([handler isEqualToString:SK_ReMoveWelcomeViews]){
        if ([_webViewController isKindOfClass:[SKWelcomeViewController class]]) {
            SKWelcomeViewController *welcomeVC = (SKWelcomeViewController *)_webViewController;
            [welcomeVC removeSelfFromSuperView];
        }
    }
    NSString *nativeFunctionStr = [NSString stringWithFormat:@"javascript:CWORKJSBridge._handleMessageFromNative(%@)",webNeedParameter];
    [aWebView stringByEvaluatingJavaScriptFromString:nativeFunctionStr];
    
}

-(void)dealFetchQueueWithArray:(NSArray *)aArray webView:(UIWebView *)aWebView{
    for (NSDictionary *dic in aArray) {
        [self dealAction:dic webView:aWebView];
    }
}

@end
