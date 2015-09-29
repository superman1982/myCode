//
//  ConfigFile.h
//  iPad
//
//  Jackson.He
//
#import "ConstDef.h"

@interface ConfigFile : NSObject {
    
}

#pragma mark -
#pragma mark 字典相关信息
// 写字典到文件
+ (BOOL) writeDictionaryToFile: (NSString *) aFileName dictionary: (NSDictionary *) aDict;
// 写数组到文件
+ (BOOL) writeArrayToFile: (NSString *) aFileName array: (NSArray *) aArray;
// 读字典
+ (NSDictionary *) readConfigDictionary;
// 保存字典
+ (void) saveConfigDictionary: (NSDictionary *) aDictionary;

#pragma mark -
#pragma mark 系统配置的相关信息
// 保存用户信息
+ (void) saveUserinfo: (NSString *) aUserName passWord: (NSString *) aPassWord isRemeberUserAcount: (BOOL) aIsRemeber isUNLogin:(BOOL)isUnLogin;
// 返回LoginAuto, 读取用户信息
+ (BOOL) readUserinfo: (NSString **) aUserName passWord: (NSString **) aPassWord;

// 分享标志
+ (NSString *) getShareActive;
// 保存分享标志
+ (void) saveShareActive: (NSString *) aShareSign;

// 获取程序启动时是否需要清除缓存开关标志
+ (BOOL) getStartClearCache;
// 保存程序启动时清除缓存开关标志
+ (void) saveStartClearCache: (BOOL) aIsStartClearCache;

// 获取新闻自动推送标志
+ (BOOL) getNewsAutoPush;
// 保存新闻自动推送标志
+ (void) saveNewsAutoPush: (BOOL) aNewIsAutoPush;

// 获取最大缓存大小
+ (NSString *) getMaxCache;
// 保存最大缓存大小
+ (void) saveMaxCache: (NSString *) aMaxCache;

// 获得激活信息，返回是否激活以及激活的TerminalID
+ (NSString *) getActiveTerminalID;
// 保存激活的TerminalID
+ (void) saveActiveTerminalID: (NSString *) aTerminalID;

// 增加文章到收藏夹中
+ (void) addArtilceToFavorite: (NSString *) aTitle URL: (NSString *) aArticleURL;
// 根据URL移除收藏夹中的文章
+ (void) removeArtilceFromFavoriteByURL: (NSString *) aArticleURL;
// 移除收藏夹中的所有文章
+ (void) removeAllArticleFromFavorite;
// 该ArticleURL是否已被收藏
+ (BOOL) isFavorite: (NSString *) aArticleURL;
// 获取所有的收藏夹数据
+ (void) getAllFavoriteArray: (NSMutableArray **) aFavoriteArrays;

// 读取资源版本
+ (NSString *) getResourceVersion;
// 保存资源版本
+ (void) saveResourceVersion: (NSString *) aResourceVersion;

// 保存deviceToken
+ (void) saveDeviceToken: (NSString *) aDeviceToken;
// 获取deviceToken
+ (NSString *) getDeviceToken;

@end