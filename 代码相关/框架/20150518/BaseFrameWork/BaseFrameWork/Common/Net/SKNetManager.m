//
//  NetManager.m
//  iPad
//
//  Jackson.He

#import "SKNetManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"

@implementation SKNetManager {
    
}

static SKNetManager  *shareNetManager = nil;

+(SKNetManager *)instanceSkLocalSetting{
    //保证此时没有其它线程对self对象进行修改
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void){
        shareNetManager = [[SKNetManager alloc] init];
    });
    return shareNetManager;
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id) retain
{
    return self;
}

- (oneway void) release
{
    // Does nothing here.
}

- (id) autorelease
{
    return self;
}

- (NSUInteger) retainCount
{
    return INT32_MAX;
}
//--------end--------



+(NSDictionary *)jsonToDic:(id )aJsonStr
{
    NSMutableDictionary *vDict = [NSJSONSerialization JSONObjectWithData:aJsonStr options:kNilOptions error:nil];
    return vDict;
}

+ (AFHTTPRequestOperation *)getURLJsonData:(NSString *)aURLStr
                                   Success:(void (^)(id responseObject, NSError *error))aSuccess
                                   Failure:(void(^)(id responseObject, NSError *error))aFailure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFHTTPRequestOperation *operation = [manager GET:aURLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (aSuccess) {
            aSuccess(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailure) {
            aFailure(operation,error);
        }
        NSLog(@"%@",[error description]);
    }];
    
    return operation;
}


+(AFHTTPRequestOperation *)postURLJsonData:(NSString *)aURLStr
                                 Parameter:(NSDictionary *)aParameter
                                   Success:(void (^)(id responseObject, NSError *error))aSuccess
                                   Failure:(void(^)(id responseObject, NSError *error))aFailure
{
    NSLog(@"postURL:%@",aURLStr);
    NSLog(@"postParemeter:%@",aParameter);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [manager POST:aURLStr parameters:aParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (aSuccess) {
            aSuccess(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailure) {
            aFailure(operation,error);
        }
        NSLog(@"%@",[error description]);
    }];
    return operation;
}


+(AFHTTPRequestOperation *)postURLData:(NSString *)aURLStr
                             Parameter:(NSDictionary *)aParameter
                               Success:(void (^)(id responseObject, NSError *error))aSuccess
                               Failure:(void(^)(id responseObject, NSError *error))aFailure
{
    NSLog(@"postURL:%@",aURLStr);
    NSLog(@"postParemeter:%@",aParameter);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [manager POST:aURLStr parameters:aParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (aSuccess) {
            aSuccess(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailure) {
            aFailure(operation,error);
        }
        NSLog(@"%@",[error description]);
    }];
    
    return operation;
}

+(void)downLoadData:(NSString *)aURLStr
           SavePath:(NSURL *)aSavePath
          imageName:(NSString *)aFileID
            Success:(void (^)(NSURLResponse *response, NSURL *filePath))aSuccess
            Failure:(void(^)(NSURLResponse *responseObject, NSError *error))aFailure{
    if (aURLStr.length == 0 || aURLStr == nil) {
        return;
    }
    if (aSavePath == nil) {
        aSavePath = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:aURLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSLog(@"downLoadURL:%@",aURLStr);
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *vImageSufreix = [response suggestedFilename].pathExtension;
        NSString *vImageName = [aFileID stringByAppendingPathExtension:vImageSufreix];
        return [aSavePath URLByAppendingPathComponent:vImageName];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (filePath.absoluteString.length > 0) {
            if (aSuccess) {
                aSuccess(response,filePath);
            }
        }
        if(error){
            NSLog(@"%@",[error description]);
            if (aFailure) {
                aFailure(response,error);
            }
        }
    }];
    [downloadTask resume];
}

+ (NSString *)jsessionID:(NSString *)aURLStr
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *aCookiesArray = [cookieJar cookiesForURL:[NSURL URLWithString:aURLStr]];
    NSDictionary *aDict = nil;
    for (NSHTTPCookie *cookie in aCookiesArray) {
        aDict = [cookie properties];
    }
    NSString *jsessionID = [aDict objectForKey:@"Value"];
    return jsessionID;
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
