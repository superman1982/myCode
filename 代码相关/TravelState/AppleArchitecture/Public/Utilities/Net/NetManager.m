//
//  NetManager.m
//  iPad
//
//  Jackson.He

#import "NetManager.h"
#import "ARCMacros.h"
#import "Function.h"
#import "JSONKit.h"
#import "AFNetWorkClient.h"
#import "AFXMLRequestOperation.h"

@implementation NetManager {
    
}

+(NSDictionary *)jsonToDic:(id )aJsonStr
{
    NSString *vJsonStr = [[NSString alloc] initWithData:aJsonStr encoding:NSUTF8StringEncoding];
    NSMutableDictionary *vDict = [vJsonStr objectFromJSONString];
    SAFE_ARC_AUTORELEASE(vJsonStr);
    return vDict;
}

// 以同步的方法，通过URL从网络获取数据
+ (NSData*) getDataFromURL: (NSString*) aURL timeout: (int) aTimeout {
    if (![self isConnectNet]) {
        return nil;
    }
    // 初始化請求
    NSMutableURLRequest *vRequest = [[NSMutableURLRequest alloc] init]; 
    @try {
        // 设置URL
        [vRequest setURL:[NSURL URLWithString: aURL]];
        // 设置超时时间30秒
        [vRequest setTimeoutInterval: aTimeout];
        
        // 设置HTTP方法
        [vRequest setHTTPMethod: @"GET"];
        // 发送同步请求, 这里得returnData就是返回得数据
        NSData *vReturnData = [NSURLConnection sendSynchronousRequest: vRequest 
                                                    returningResponse: nil 
                                                                error: nil]; 
        return vReturnData;
    } @finally {
        SAFE_ARC_RELEASE(vRequest);
    }
}

// 以同步的方法，通过URL提交数据
+ (NSData*) getDataFromURL: (NSString*) aURL Paremeter:(NSDictionary *)aParemeter timeout: (int) aTimeout {
    if (![self isConnectNet]) {
        return nil;
    }
    // 通过post方式传输data到后台服务器
    NSMutableURLRequest *vRequest = [[NSMutableURLRequest alloc] init];
    NSString *vJsonStr= [aParemeter JSONString];
    NSData *vJsonData = [vJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    @try {
        // 设置超时时间30秒
        [vRequest setTimeoutInterval: aTimeout];
        [vRequest setURL: [NSURL URLWithString: aURL]];
        [vRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", @"utf-8"] forHTTPHeaderField: @"Content-Type"];
        [vRequest setHTTPMethod: @"GET"];
        [vRequest setCachePolicy: NSURLRequestUseProtocolCachePolicy];
        [vRequest setHTTPBody: vJsonData];
        // 通过一个静态方法，请求request,这种情况下，会一直阻塞，等到返回结果，简单易用
        NSData *vReturnData = [NSURLConnection sendSynchronousRequest: vRequest
                                                    returningResponse: nil
                                                                error: nil];
        return vReturnData;
    } @finally {
        SAFE_ARC_RELEASE(vRequest);
    }
}

// 以同步的方式，通过URL及参数提交数据,如果采用Post的方式的话，参数是不需要编码的
+ (NSData*) postToURL: (NSString*) aURL timeout: (int) aTimeout {
    if (![self isConnectNet]) {
        return nil;
    }
    // 通过post方式传输data到后台服务器
    NSMutableURLRequest *vRequest = [[NSMutableURLRequest alloc] init];
    @try {
        // 设置超时时间aTimeout秒
        [vRequest setTimeoutInterval: aTimeout];
        
        // 参数字符串
        NSString *vParamStr = nil;
        NSString *vFlag = @"?";
        // 在aURL中找到?的位置
        NSRange vRange = [aURL rangeOfString: vFlag];
        //将?的位置和长度赋值
        int vLocation = vRange.location;
        if (vRange.length > 0) {
            NSString *vTmpStr = [aURL substringToIndex: vLocation]; 
            [vRequest setURL: [NSURL URLWithString: [NSString stringWithFormat: @"%@", vTmpStr]]];
            
            vParamStr = [aURL substringFromIndex: vLocation + [vFlag length]];
        };
        
        [vRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"]; 
        [vRequest setHTTPMethod: @"POST"]; 
        [vRequest setCachePolicy: NSURLRequestUseProtocolCachePolicy]; 
        NSData *vPostData = [vParamStr dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES]; 
        // 据说采用Post的方式可以不传长度
        //    NSString *vPostLength = [NSString stringWithFormat: @"%d", [vPostData length]];
        //    [vRequest setValue: vPostLength forHTTPHeaderField: @"Content-Length"]; 
        [vRequest setHTTPBody: vPostData]; 
        
        // 通过一个静态方法，请求request,这种情况下，会一直阻塞，等到返回结果，简单易用
        NSData *vReturnData = [NSURLConnection sendSynchronousRequest: vRequest 
                                                    returningResponse: nil 
                                                                error: nil];
        return vReturnData;
    } @finally {
        SAFE_ARC_RELEASE(vRequest);
    }
}

// 以同步的方式，通过URL及参数提交数据,如果采用Post的方式的话，参数是不需要编码的
+ (NSData*) postToURL: (NSString*) aURL data: (NSData*) aData timeout: (int) aTimeout {
    if (![self isConnectNet]) {
        return nil;
    }
    // 通过post方式传输data到后台服务器
    NSMutableURLRequest *vRequest = [[NSMutableURLRequest alloc] init];
    @try {
        // 设置超时时间aTimeout秒
        [vRequest setTimeoutInterval: aTimeout];
        [vRequest setURL: [NSURL URLWithString: aURL]];
        [vRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
        [vRequest setHTTPMethod: @"POST"];
        [vRequest setCachePolicy: NSURLRequestUseProtocolCachePolicy];
        [vRequest setHTTPBody: aData]; 
        // 通过一个静态方法，请求request,这种情况下，会一直阻塞，等到返回结果，简单易用
        NSData *vReturnData = [NSURLConnection sendSynchronousRequest: vRequest 
                                                    returningResponse: nil 
                                                                error: nil];
        return vReturnData;
        
    } @finally {
        SAFE_ARC_RELEASE(vRequest);
    }
}

+(NSData *) postToURLSynchronous: (NSString*) aURL Paremeter: (NSDictionary*) aParemeter timeout: (int) aTimeout RequestName:(NSString *)aName{
    if (![self isConnectNet]) {
        return nil;
    }
    // 通过post方式传输data到后台服务器
    NSMutableURLRequest *vRequest = [[NSMutableURLRequest alloc] init];
    NSString *vJsonStr= [aParemeter JSONString];
    LOG(@"%@requestURL:%@",aName,aURL);
    LOG(@"%@requestParemeter:%@",aName,vJsonStr);
    NSData *vJsonData = [vJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    @try {
        // 设置超时时间aTimeout秒
        [vRequest setTimeoutInterval: aTimeout];
        [vRequest setURL: [NSURL URLWithString: aURL]];
        [vRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", @"utf-8"] forHTTPHeaderField:@"Content-Type"];
        [vRequest setHTTPMethod: @"POST"];
        [vRequest setCachePolicy: NSURLRequestUseProtocolCachePolicy];
        [vRequest setHTTPBody: vJsonData];
        // 通过一个静态方法，请求request,这种情况下，会一直阻塞，等到返回结果，简单易用
        NSData *vReturnData = [NSURLConnection sendSynchronousRequest: vRequest
                                                    returningResponse: nil
                                                                error: nil];
        if (vReturnData == Nil) {
            [SVProgressHUD showErrorWithStatus:@"网络错误，请检查您的网络!"];
        }
        #ifdef DEBUG
        //测试代码
        NSDictionary *vReturnDic = [NetManager jsonToDic:vReturnData];
        NSString *vReturnMessage = [vReturnDic objectForKey:@"stateMessage"];
        LOG(@"%@returnMessage:%@\n%@returnData%@",aName,vReturnMessage,aName,vReturnDic);
        //-----
        #endif
        return vReturnData;
        
    } @finally {
        SAFE_ARC_RELEASE(vRequest);
    }
}

+(void)postDataFromWebAsynchronous:(NSString *)aURL
                         Paremeter:(NSDictionary *)aDic
                           Success:(void (^)(NSURLResponse *response,id responseObject))aSuccess
                           Failure:(void(^)(NSURLResponse *response, NSError *error))aFailure
                       RequestName:(NSString *)aName
                            Notice:(NSString *)aNotice
{
    NSString *vJsonStr= [aDic JSONString];
    NSData *vJsonData = [vJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *vURL = [NSURL URLWithString:aURL];
    LOG(@"%@requestURL:%@",aName,aURL);
    LOG(@"%@requestParemeter:%@",aName,vJsonStr);
    
    NSMutableURLRequest *vURLRequest = [NSMutableURLRequest requestWithURL:vURL];
    [vURLRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [vURLRequest setTimeoutInterval:10.0f];
    [vURLRequest setHTTPMethod:@"POST"];
    [vURLRequest setHTTPBody:vJsonData];
    [vURLRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", @"utf-8"] forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    SAFE_ARC_AUTORELEASE(queue);
    if (aNotice != Nil) {
        [SVProgressHUD showWithStatus:aNotice];
    }
    
    [NSURLConnection sendAsynchronousRequest:vURLRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data,
                                               NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (aNotice != Nil) {
                                       [SVProgressHUD dismiss];
                                   }
                                   if ([data length] >0 && error == nil){
                                       if (aSuccess) {
                                           #ifdef DEBUG
                                           //测试代码
                                           NSDictionary *vReturnDic = [NetManager jsonToDic:data];
                                           NSString *vReturnMessage = [vReturnDic objectForKey:@"stateMessage"];
                                           LOG(@"%@returnMessage:%@\n%@returnData%@",aName,vReturnMessage,aName,vReturnDic);
                                           
                                           if (vReturnDic == Nil) {
                                               NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                               LOG(@"服务器错误%d",responseCode);
                                           }
                                           //-----
                                            #endif
                                           aSuccess(response,data);
                                         
                                       }
                                       
                                   }else if ([data length] == 0 && error == nil){
                                       LOG(@"Nothing was downloaded.");
                                   }else if (error != nil){
                                       LOG(@"Error happened = %@", error);
                                       if (aFailure) {
                                           aFailure(response,error);
                                       }
                                       [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                   }
                               });
                           }];
}

+(void)getURLDataFromWeb:(NSString *)aURLStr
               Parameter:(NSDictionary *)aParameter
                 Success:(void (^)(NSURLResponse *response,id responseObject))aSuccess
                 Failure:(void(^)(NSURLResponse *response, NSError *error))aFailure
             RequestName:(NSString *)aName
                  Notice:(NSString *)aNotice
{
    NSString *vJsonStr= [aParameter JSONString];
    NSData *vJsonData = [vJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *vURL = [NSURL URLWithString:aURLStr];
    NSMutableURLRequest *vURLRequest = [NSMutableURLRequest requestWithURL:vURL];
    [vURLRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [vURLRequest setTimeoutInterval:30.0f];
    [vURLRequest setHTTPMethod:@"GET"];
    [vURLRequest setHTTPBody:vJsonData];
    [vURLRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", @"utf-8"] forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    SAFE_ARC_AUTORELEASE(queue);
    if (aNotice!= Nil) {
        [SVProgressHUD showWithStatus:aNotice];
    }
     LOG(@"%@RequestUR:%@",aName,aURLStr);
    [NSURLConnection sendAsynchronousRequest:vURLRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data,
                                               NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [SVProgressHUD dismiss];
                                   if ([data length] >0 && error == nil){
                                       if (aSuccess) {
                                           aSuccess(response,data);
                                       }
#ifdef DEBUG
                                       //测试代码
                                       NSDictionary *vReturnDic = [NetManager jsonToDic:data];
                                       LOG(@"%@returnMessage:%@\n",aName,vReturnDic);
                                       //-----
#endif
                                   }else if ([data length] == 0 && error == nil){
                                       LOG(@"Nothing was downloaded.");
                                       
                                   }else if (error != nil){
                                       LOG(@"Error happened = %@", error);
                                       [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                       if (aFailure) {
                                           aFailure(response,error);
                                       }
                                   }
                               });
                           }];
}


//传入全路径的URL
+(void)getURLData:(NSString *)aURLStr
        Parameter:(NSDictionary *)aParameter
          Success:(void (^)(id responseObject, NSError *error))aSuccess
          Failure:(void(^)(id responseObject, NSError *error))aFailure{
    
    AFNetWorkClient *vGetClient = [[AFNetWorkClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [vGetClient getPath:aURLStr parameters:aParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (aSuccess) {
            aSuccess(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (aFailure) {
            aFailure(operation,error);
        }
    }];
    
}

//因为baseURL部分都是一样的如@"http://118.123.249.138:7001/services/"，
//所以传入不一样的URL部分即可，如@"chat/queryUsersNearby"
+(void)postURLData:(NSString *)aURLStr
         Parameter:(NSDictionary *)aParameter
           Success:(void (^)(id responseObject, NSError *error))aSuccess
           Failure:(void(^)(id responseObject, NSError *error))aFailure
{
    [[AFNetWorkClient sharedClient] postPath:aURLStr parameters:aParameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            [mutablePosts addObject:attributes];
        }
        
        if (aSuccess) {
            aSuccess(JSON,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailure) {
            aFailure(operation,error);
        }
    }];
}

-(void)xmlURLData:(NSURLRequest *)aRequest
          Success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))aSuccess
          Failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))aFailure
{
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:aRequest
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                                                                                               
                                                                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                                                                                               
                                                                                           }];
    
    [operation start];
}

// 某一特定网络地址是否是连通的
+ (BOOL) isConnectNet: (NSString*) aNetWorkAddress {
    // aNetWorkAddress = @"www.apple.com"
    Reachability* vReachability = [Reachability reachabilityWithHostname: aNetWorkAddress];
    if ([vReachability currentReachabilityStatus] == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

// 是否wifi
+ (BOOL) isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G或是GPRS
+ (BOOL) isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

// 是否已联网
+ (BOOL) isConnectNet {
    return ([self isEnableWIFI] || [self isEnable3G]);
}


@end
