//
//  NetManager.h
//  iPad
//
//  Jackson.He

#import "Reachability.h"
#import "HttpDefine.h"
#import "SVProgressHUD.h"
#import "AFXMLRequestOperation.h"

struct UPData{
    NSString * aMethod ;
    NSString * aPath;
    NSDictionary * aParemeter;
    
    id aData;
    NSInteger aDataType;
    NSString * aDataName;
};

@interface NetManager : NSObject<NSXMLParserDelegate> {
    
}

#pragma mark -
#pragma mark 自定义函数
// 以同步的方法，通过URL从网络获取数据
+ (NSData*) getDataFromURL: (NSString*) aURL timeout: (int) aTimeout;
// 以同步的方法，通过URL提交数据
+ (NSData*) getDataFromURL: (NSString*) aURL Paremeter:(NSDictionary *)aParemeter timeout: (int) aTimeout;
// 以同步的方式，通过URL及参数提交数据
+ (NSData*) postToURL: (NSString*) aURL timeout: (int) aTimeout;
// 以同步的方式，通过URL及参数提交数据,如果采用Post的方式的话，参数是不需要编码的
+ (NSData*) postToURL: (NSString*) aURL data: (NSData*) aData timeout: (int) aTimeout;
//以同步方式获取数据,参数编码
+(NSData *) postToURLSynchronous: (NSString*) aURL Paremeter: (NSDictionary*) aParemeter timeout: (int) aTimeout RequestName:(NSString *)aName;
//异步post方式获取网络数据
+(void)postDataFromWebAsynchronous:(NSString *)aURL
                         Paremeter:(NSDictionary *)aDic
                           Success:(void (^)(NSURLResponse *response,id responseObject))aSuccess
                           Failure:(void(^)(NSURLResponse *response, NSError *error))aFailure
                       RequestName:(NSString *)aName
                            Notice:(NSString *)aNotice;
+(void)postURLData:(NSString *)aURLStr
         Parameter:(NSDictionary *)aParameter
           Success:(void (^)(id responseObject, NSError *error))aSuccess
           Failure:(void(^)(id responseObject, NSError *error))aFailure;

-(void)xmlURLData:(NSURLRequest *)aRequest
          Success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser))aSuccess
          Failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser))aFailure;
//异步get方式获取网络数据
+(void)getURLDataFromWeb:(NSString *)aURLStr
               Parameter:(NSDictionary *)aParameter
                 Success:(void (^)(NSURLResponse *response,id responseObject))aSuccess
                 Failure:(void(^)(NSURLResponse *response, NSError *error))aFailure
             RequestName:(NSString *)aName
                  Notice:(NSString *)aNotice;
+(void)getURLData:(NSString *)aURLStr
        Parameter:(NSDictionary *)aParameter
          Success:(void (^)(id responseObject, NSError *error))aSuccess
          Failure:(void(^)(id responseObject, NSError *error))aFailure;
//上传数据
+(void)upLoadData:(struct UPData *)aUPData
    ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))aProgress
CompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))aSuccess
          Failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailure;

// 某一特定网络地址是否是连通的
+ (BOOL) isConnectNet: (NSString*) aNetWorkAddress;
// 是否已联网
+ (BOOL) isConnectNet;

+(NSDictionary *)jsonToDic:(id )aJsonStr;
@end
