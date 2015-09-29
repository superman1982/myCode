//
//  ConfigFile.m
//  iPad
//
//  Jackson.He
//

#import "ConfigFile.h"
#import "FileManager.h"
#import "TerminalData.h"
#import "ARCMacros.h"

@implementation ConfigFile

#pragma mark -
#pragma mark 字典相关
// 写字典到文件
+ (BOOL) writeDictionaryToFile: (NSString *) aFileName dictionary: (NSDictionary *) aDict {
    BOOL vResult = NO;
	if (aFileName == nil || aDict == nil) {
		return vResult;
	}
	
	NSString *vError;
    NSData *vData = [NSPropertyListSerialization dataFromPropertyList: aDict
                                                               format: NSPropertyListXMLFormat_v1_0
                                                     errorDescription: &vError];
    @try {        
        if (vData != nil) {
            [FileManager writeFileByFileName: aFileName streamFileData: [NSMutableData dataWithData: vData] isAppend: NO];
            vResult = YES;
        }
    } @finally {
        SAFE_ARC_RETAIN(vError);
    }
	return vResult;
}

// 写数组到文件
+ (BOOL) writeArrayToFile: (NSString *) aFileName array: (NSArray *) aArray {
    BOOL vResult = NO;
	if (aFileName == nil || aArray == nil) {
		return vResult;
	}
	
	NSString *vError;
    NSData *vData = [NSPropertyListSerialization dataFromPropertyList: aArray
                                                               format: NSPropertyListXMLFormat_v1_0
                                                     errorDescription: &vError];
    @try {        
        if (vData != nil) {
            [FileManager writeFileByFileName: aFileName streamFileData: [NSMutableData dataWithData: vData] isAppend: NO];
            vResult = YES;
        }
    } @finally {
        SAFE_ARC_RETAIN(vError);
    }
	return vResult;
}

// 读字典
+ (NSDictionary *) readConfigDictionary {
	NSString *vError = nil;
	NSPropertyListFormat vFormat;
    
	NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@", [TerminalData rootDirectory], MCMSCONFIG_FILE];
	@try {	
        // 如果不存在
        if (![FileManager fileIsExist: vFileName]) {
            vFileName = [[NSBundle mainBundle] pathForResource: @"config" ofType: @"mcms"];
        }
        
        NSData *vXMLFile = [[NSFileManager defaultManager] contentsAtPath: vFileName];
        
        NSDictionary *vDict = nil;
        @try {  
            vDict = (NSDictionary *) [NSPropertyListSerialization propertyListFromData: vXMLFile
                                                                      mutabilityOption: NSPropertyListMutableContainersAndLeaves
                                                                                format: &vFormat
                                                                      errorDescription: &vError];
        } @finally {
            SAFE_ARC_RETAIN(vError);
        }
        return vDict;	
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }	
}

// 保存字典
+ (void) saveConfigDictionary: (NSDictionary *) aDictionary {
	if (aDictionary == nil) {
        return;        
    }
    
	NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@", [TerminalData rootDirectory], MCMSCONFIG_FILE];
	@try {
        NSData *vXMLFile = [[NSFileManager defaultManager] contentsAtPath: vFileName];
        if (vXMLFile != nil) { 
            NSString *vError = nil;
            NSPropertyListFormat vFormat;
            // 更新数据
            NSDictionary *vDict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData: vXMLFile
                                                                                   mutabilityOption: NSPropertyListMutableContainersAndLeaves
                                                                                             format: &vFormat
                                                                                   errorDescription: &vError];
            @try {
                if (vDict != nil) {
                    for (NSString* vKey in [aDictionary allKeys]) { 
                        [vDict setValue: [aDictionary valueForKey: vKey] forKey: vKey];
                    }
                    [self writeDictionaryToFile: vFileName dictionary: vDict];
                }
            }@finally {
                SAFE_ARC_RETAIN(vError);
            }
        } else {
            [self writeDictionaryToFile: vFileName dictionary: aDictionary];
        }	
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }
}

#pragma mark -
#pragma mark 用户信息
// 保存用户信息
+ (void) saveUserinfo: (NSString *) aUserName passWord: (NSString *) aPassWord isRemeberUserAcount: (BOOL) aIsRemeber isUNLogin:(BOOL)isUnLogin {
	if (aUserName != nil && aPassWord != nil) {
        NSArray *vValueArray = [NSArray arrayWithObjects: aUserName, aPassWord, [NSNumber numberWithBool:aIsRemeber],[NSNumber numberWithBool:isUnLogin], nil];
        NSArray *vKeyArray = [NSArray arrayWithObjects: USER, PASSWORD, ISREMEMBERUSERACOUNT,ISUNLOGIN, nil];
		NSDictionary *vListDict = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
		[self saveConfigDictionary: vListDict];
	}
}

// 读取用户信息
+ (BOOL) readUserinfo: (NSString **) aUserName passWord: (NSString **) aPassWord {
	NSDictionary *vTmpList = [self readConfigDictionary];
	*aUserName = [vTmpList objectForKey: USER];
	*aPassWord = [vTmpList objectForKey: PASSWORD];
	return (((NSString *)[vTmpList objectForKey: USER]).length);
}

#pragma mark -
#pragma mark 分享标记
// 读取分享标志
+ (NSString *) getShareActive {
	NSDictionary *vTmpList = [self readConfigDictionary];
	NSString *vTmpStr = [vTmpList objectForKey: SHARE];
	return vTmpStr;
}
// 保存分享标志
+ (void) saveShareActive: (NSString*) aShareSign {
    NSArray *vValueArray = [NSArray arrayWithObjects: aShareSign, nil];
    NSArray *vKeyArray = [NSArray arrayWithObjects: SHARE, nil];
	NSDictionary *vTmpList = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
	[self saveConfigDictionary: vTmpList];
}

#pragma mark -
#pragma mark 启动清除数据
// 获取程序启动时是否需要清除缓存开关标志
+ (BOOL) getStartClearCache {
	NSDictionary *vTmpList = [self readConfigDictionary];
    NSString *vClearCacheStr = [vTmpList objectForKey: START_CLEAR_CACHE];
    int vClearCacheInt = [vClearCacheStr intValue];
	return (vClearCacheInt == 1);
}

// 保存程序启动时清除缓存开关标志
+ (void) saveStartClearCache: (BOOL) aIsStartClearCache {
    NSArray *vValueArray = [NSArray arrayWithObjects: [NSString stringWithFormat: @"%d", aIsStartClearCache ? 1: 0], nil];
    NSArray *vKeyArray = [NSArray arrayWithObjects: START_CLEAR_CACHE, nil];
	NSDictionary *vTmpList = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
	[self saveConfigDictionary: vTmpList];
}

#pragma mark -
#pragma mark 新闻自动推送
// 获取新闻自动推送标志
+ (BOOL) getNewsAutoPush {
	NSDictionary *vTmpList = [self readConfigDictionary];
	return ([[vTmpList objectForKey: AUTO_PUSH_NEWS] intValue] == 1);    
}

// 保存新闻自动推送标志
+ (void) saveNewsAutoPush: (BOOL) aNewIsAutoPush  {
    NSArray *vValueArray = [NSArray arrayWithObjects: [NSString stringWithFormat: @"%d", aNewIsAutoPush ? 1: 0], nil];
    NSArray *vKeyArray = [NSArray arrayWithObjects: AUTO_PUSH_NEWS, nil];
    NSDictionary *vTmpList = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
    [self saveConfigDictionary: vTmpList];
}

#pragma mark -
#pragma mark 最大缓存大小
// 获取最大缓存大小
+ (NSString *) getMaxCache {
	NSDictionary *vTmpList = [self readConfigDictionary];
    NSString *vTmpStr = [vTmpList objectForKey: MAX_CACHE];
    // 第一次未设置的时候默认为512MB
    if (vTmpStr == nil) {
        return @"512";
    } else {
        return vTmpStr;
    }
}

// 保存最大缓存大小
+ (void) saveMaxCache: (NSString *) aMaxCache {
    NSArray *vValueArray = [NSArray arrayWithObjects: aMaxCache, nil];
    NSArray *vKeyArray = [NSArray arrayWithObjects: MAX_CACHE, nil];
    NSDictionary *vTmpList = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
    [self saveConfigDictionary: vTmpList];
}

#pragma mark -
#pragma mark 程序激活标识
// 获得激活信息，返回是否激活以及激活的TerminalID
+ (NSString *) getActiveTerminalID {
	NSDictionary *vTmpList = [self readConfigDictionary];
	return [vTmpList objectForKey: ACTIVE_TERMINALID]; 
}

// 保存激活的TerminalID
+ (void) saveActiveTerminalID: (NSString *) aTerminalID {
    NSArray *vValueArray = [NSArray arrayWithObjects: aTerminalID, nil];
    NSArray *vKeyArray = [NSArray arrayWithObjects: ACTIVE_TERMINALID, nil];
    NSDictionary *vTmpList = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
    [self saveConfigDictionary: vTmpList];
}

// 增加文章到收藏夹中
+ (void) addArtilceToFavorite: (NSString *) aTitle URL: (NSString *) aArticleURL {
    if (aTitle == nil || aArticleURL == nil) {
        return;
    }
    // 收藏夹的配置文件
    NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@", [TerminalData rootDirectory], FAVLIST_FILE];
	@try {
        NSMutableArray* vTmpArray = nil;
        
        NSArray *vValueArray = [NSArray arrayWithObjects: aTitle, aArticleURL, nil];
        NSArray *vKeyArray = [NSArray arrayWithObjects: FAV_TITLE, FAV_URL, nil];
        NSDictionary *vTmpList = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
        
        if ([FileManager fileIsExist: vFileName]){
            vTmpArray = [NSMutableArray arrayWithContentsOfFile: vFileName];
            for(NSDictionary *vDictionary in vTmpArray){
                //如果已经存在，则先删除重新插入.
                NSString *vTmpURL = [vDictionary objectForKey: FAV_URL];
                if ([vTmpURL isEqualToString: aArticleURL]){
                    [vTmpArray removeObject: vDictionary];
                    break;
                }
            }
        } else {
            vTmpArray = [NSMutableArray arrayWithCapacity: 0];
        }
        
        if (vTmpArray != nil) {
            [vTmpArray insertObject: vTmpList atIndex: 0];
            [vTmpArray writeToFile: vFileName atomically: YES];
        }
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }
}

// 根据URL移除收藏夹中的文章
+ (void) removeArtilceFromFavoriteByURL: (NSString *) aArticleURL {
    // 收藏夹的配置文件
    NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@", [TerminalData rootDirectory], FAVLIST_FILE];
	@try {
        NSMutableArray *vTmpArray = nil;
        if ([FileManager fileIsExist: vFileName]) {
            vTmpArray = [NSMutableArray arrayWithContentsOfFile: vFileName];
            for (NSDictionary *vDictionary in vTmpArray){
                // 如果已经存在，则删除
                NSString *vTmpURL = [vDictionary objectForKey: FAV_URL];
                if ([vTmpURL isEqualToString: aArticleURL]){
                    [vTmpArray removeObject: vDictionary];
                    break;
                }
            }
        }
        
        if (vTmpArray != nil) {
            [vTmpArray writeToFile: vFileName atomically: YES];
        }
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }
}

// 移除收藏夹中的所有文章
+ (void) removeAllArticleFromFavorite {
    // 收藏夹的配置文件
    NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@", [TerminalData rootDirectory], FAVLIST_FILE];
	@try {
        if ([FileManager fileIsExist: vFileName]){
            [FileManager deleteFile: vFileName];
        }        
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }
}

// 该ArticleURL是否已被收藏
+ (BOOL) isFavorite: (NSString *) aArticleURL {
    // 收藏夹的配置文件
    NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@", [TerminalData rootDirectory], FAVLIST_FILE];
	@try {
        NSMutableArray *vTmpArray = nil;
        if ([FileManager fileIsExist: vFileName]){
            vTmpArray = [NSMutableArray arrayWithContentsOfFile: vFileName];
            for (NSDictionary *vDictionary in vTmpArray){
                // 查看是否存在
                NSString *vTmpURL = [vDictionary objectForKey: FAV_URL];
                if ([vTmpURL isEqualToString: aArticleURL]){
                    return YES;
                }
            }
        }        
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }
    
    return NO;
}

// 获取所有的收藏夹数据
+ (void) getAllFavoriteArray: (NSMutableArray **) aFavoriteArrays {
    if (aFavoriteArrays == nil) {
        return;
    }
    // 收藏夹的配置文件
    NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@", [TerminalData rootDirectory], FAVLIST_FILE];
	@try {
        if ([FileManager fileIsExist: vFileName]){
            NSMutableArray *vTmpArray = [NSMutableArray arrayWithContentsOfFile: vFileName];
            for (NSDictionary* vDictionary in vTmpArray) {
                [*aFavoriteArrays addObject: vDictionary]; 
            }
        }        
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }
}

#pragma mark -
#pragma mark 资源版本
// 读取资源版本
+ (NSString *) getResourceVersion {
    // 资源的配置文件
    NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@",
                           [TerminalData rootDirectory], 
                           RESOURCE_VERSION_FILE];
	@try {
        NSMutableArray *vTmpArray = nil;
        NSString *vTemplateName = @"";
        if ([FileManager fileIsExist: vFileName]){
            vTmpArray = [NSMutableArray arrayWithContentsOfFile: vFileName];
            for (NSDictionary *vDictionary in vTmpArray){
                // 查看是否存在
                NSString *vTmpURL = [vDictionary objectForKey: RESOURCE_TYPE];
                if ([vTmpURL isEqualToString: vTemplateName]){
                    return [vDictionary objectForKey: RESOURCE_VERSION];
                }
            }
        } 
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }
    return nil;
}

// 保存资源版本
+ (void) saveResourceVersion: (NSString *) aResourceVersion {
    // 资源的配置文件
    NSString *vFileName = [[NSString alloc] initWithFormat: @"%@%@",
                           [TerminalData rootDirectory], 
                           RESOURCE_VERSION_FILE];
	@try {
        NSMutableArray *vTmpArray = nil;
        NSString *vTemplateName = @"";
        NSArray *vValueArray = [NSArray arrayWithObjects: vTemplateName, aResourceVersion, nil];
        NSArray *vKeyArray = [NSArray arrayWithObjects: RESOURCE_TYPE, RESOURCE_VERSION, nil];
        NSDictionary *vTmpList = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
        
        if ([FileManager fileIsExist: vFileName]){
            vTmpArray = [NSMutableArray arrayWithContentsOfFile: vFileName];
            for(NSDictionary *vDictionary in vTmpArray){
                // 如果已经存在，则先删除重新插入
                NSString *vTmpURL = [vDictionary objectForKey: RESOURCE_TYPE];
                if ([vTmpURL isEqualToString: vTemplateName]){
                    [vTmpArray removeObject: vDictionary];
                    break;
                }
            }
        } else {
            vTmpArray = [NSMutableArray arrayWithCapacity: 0];
        }
        
        if (vTmpArray != nil) {
            [vTmpArray insertObject: vTmpList atIndex: 0];
            [vTmpArray writeToFile: vFileName atomically: YES];
        }
    } @finally {
        SAFE_ARC_RELEASE(vFileName);
    }
}

// 获取deviceToken
+ (NSString *) getDeviceToken {
	NSDictionary *vTmpList = [self readConfigDictionary];
	return [vTmpList objectForKey: DEVICETOKEN]; 
}

// 保存deviceToken
+ (void) saveDeviceToken: (NSString *) aDeviceToken {
    NSArray *vValueArray = [NSArray arrayWithObjects: aDeviceToken, nil];
    NSArray *vKeyArray = [NSArray arrayWithObjects: DEVICETOKEN, nil];
    NSDictionary *vTmpList = [NSDictionary dictionaryWithObjects: vValueArray forKeys: vKeyArray];
    [self saveConfigDictionary: vTmpList];    
}

@end
