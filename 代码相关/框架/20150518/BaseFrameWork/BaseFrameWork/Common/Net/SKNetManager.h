//
//  NetManager.h
//  iPad
//
//  Jackson.He

#import "Reachability.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperation.h"

struct UPData{
    NSString * aMethod ;
    NSString * aPath;
    NSDictionary * aParemeter;
    
    id aData;
    NSInteger aDataType;
    NSString * aDataName;
};

@interface SKNetManager : NSObject<NSXMLParserDelegate> {
}

#pragma mark -
#pragma mark 自定义函数

/**
 get请求， 请求数据返回类型是URLData形式
 @param aParameter  需要传的参数
 */

+(AFHTTPRequestOperation *)getURLJsonData:(NSString *)aURLStr
                                  Success:(void (^)(id responseObject, NSError *error))aSuccess
                                  Failure:(void(^)(id responseObject, NSError *error))aFailure;

/**
  post请求， 请求数据返回类型是URLData形式
 @param aParameter  需要传的参数
 */
+(AFHTTPRequestOperation *)postURLData:(NSString *)aURLStr
                             Parameter:(NSDictionary *)aParameter
                               Success:(void (^)(id responseObject, NSError *error))aSuccess
                               Failure:(void(^)(id responseObject, NSError *error))aFailure;

/**
 post请求， 请求数据返回类型是JSON形式
 @param aParameter  需要传的参数
 */
+(AFHTTPRequestOperation *)postURLJsonData:(NSString *)aURLStr
                                 Parameter:(NSDictionary *)aParameter
                                   Success:(void (^)(id responseObject, NSError *error))aSuccess
                                   Failure:(void(^)(id responseObject, NSError *error))aFailure;

+(void)downLoadData:(NSString *)aURLStr
           SavePath:(NSURL *)aSavePath
             imageName:(NSString *)aFileID
            Success:(void (^)(NSURLResponse *response, NSURL *filePath))aSuccess
            Failure:(void(^)(NSURLResponse *responseObject, NSError *error))aFailure;

+ (NSString *)jsessionID:(NSString *)aURLStr;

// 某一特定网络地址是否是连通的
+ (BOOL) isConnectNet: (NSString*) aNetWorkAddress;
// 是否已联网
+ (BOOL) isConnectNet;

+(NSDictionary *)jsonToDic:(id )aJsonStr;
@end
