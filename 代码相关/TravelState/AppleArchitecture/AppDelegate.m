//
//  iPadAppDelegate.m
//  iPad
//
//  Jackson.He

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "ViewControllerManager.h"
#import "FileManager.h"
#import "NetManager.h"
#import "MainConfig.h"
#import "UserManager.h"
#import "RootTabBarVC.h"
#import "ImageCacher.h"
#import "ConfigFile.h"
#import "BaiDuMapView.h"
#import "DefaultHomeVC.h"
//-----分享sdk添加
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
//-----
//----支付宝--
#import "PartnerConfig.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
//----
#import "Reachability.h"

//---百度导航sdk---
#import "BNCoreServices.h"
#import "BNaviSoundManager.h"

@implementation AppDelegate

@synthesize navigationController = mNavigationController;

#pragma mark -
#pragma mark Application lifecycle
- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {
    self.window = SAFE_ARC_AUTORELEASE([[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]);
    
    mNavigationController = [[UINavigationController alloc] init];
    self.window.rootViewController = mNavigationController;
    
    // 配置了一个32MB磁盘高速缓存4MB的内存中缓存。
    // 磁盘高速缓存驻留在默认的iOS缓存目录中，在一个子目录称为“nsurlcache”。
    int vCacheSizeMemory = 4 * 1024 * 1024;  // 4MB
    int vCacheSizeDisk = 32 * 1024 * 1024;   // 32MB
    NSURLCache* vSharedCache = SAFE_ARC_AUTORELEASE([[NSURLCache alloc] initWithMemoryCapacity: vCacheSizeMemory
                                                                                  diskCapacity: vCacheSizeDisk
                                                                                      diskPath: @"nsurlcache"]);
    [NSURLCache setSharedURLCache: vSharedCache];
    
    mIsLoadData = NO;
    mIsBackgroundRun = NO;
    mIsReloadData = NO;
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    // 由于TerminalData中的某些变量需要初始化一下才能用，
	// 所以这里必须调用一下TerminalData的初始化，否则有可能调用某些函数要报错的
	mTerminalData = [TerminalData instanceTerminalData];
    // 注册推送通知功能
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // 判断程序是不是由推送服务完成的
    if (launchOptions != nil) {
        // NSDictionary* vPushNotifications = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    }
    
    [ViewControllerManager createViewController:@"RootTabBarVC"];
    [ViewControllerManager showBaseViewController:@"RootTabBarVC" AnimationType:vaDefaultAnimation SubType:0];
    
    //初始化分享
    [self initializePlat];
    //版本检测
    [[TerminalData instanceTerminalData] checkVersion:YES];
    //检测用户是否自动登录
    [UserManager checkIfIsAutoLoginWithCompletionBlock:nil];
    
    // 初始化导航SDK引擎
    [BNCoreServices_Instance initServices:BaiDuMapKey];
    
    //开启引擎，传入默认的TTS类
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil SoundService:[BNaviSoundManager getInstance]];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void) application: (UIApplication*) application didRegisterForRemoteNotificationsWithDeviceToken: (NSData *) deviceToken {
//    NSString* vTmpStr = @"";
//    NSString* vOldToken = [NSString stringWithFormat: @"%@", deviceToken];
//    
//    NSString* vPrefix = @"<";
//    NSString* vSuffix = @">";
//    if ([vOldToken hasPrefix: vPrefix] && [vOldToken hasSuffix: vSuffix]) {
//        // 去掉头尾
//        NSString* vTmpStr1 = [vOldToken substringFromIndex: [vPrefix length]];
//        vTmpStr = [vTmpStr1 substringToIndex: [vTmpStr1 length] - [vSuffix length]]; 
//    } else if ([vOldToken hasPrefix: vPrefix] && ![vOldToken hasSuffix: vSuffix]) {
//        vTmpStr = [vOldToken substringFromIndex: [vPrefix length]];
//    } else if (![vOldToken hasPrefix: vPrefix] && [vOldToken hasSuffix: vSuffix]) {
//        vTmpStr = [vOldToken substringToIndex: [vOldToken length] - [vSuffix length]];
//    } else {
//        vTmpStr = [NSString stringWithString: vOldToken];
//    }
    
//    NSString* vNewToken = [vTmpStr stringByReplacingOccurrencesOfString: @" " withString: @""];
//    // 上传deviceToken
//    // [MCMSManager uploadDeviceToken: vNewToken];
//    
//    // devicetoken = a6899db4 dea26eeb 896b3f3c 4c7743e2 cf78e952 65f600ef 573b44eb e266cac5;   iPad 5.1
//    // devicetoken = dc3881e7 6a8c7ac4 7a3568cb 5aeece08 25c9f096 9f9f244c 96663775 913291b8;   Stevenfu
//    // devicetoken = 0391fcb4 33a386cf 6ab108d1 0cd25f35 72b643dd 69cdecca 7d300a6c fa43c565;   HeXin
}

- (void) application: (UIApplication*) application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (ISDEBUG) {
        LOG(@"Failed to get token, error: %@", error);
    }
}

- (void) application: (UIApplication *) application didReceiveRemoteNotification: (NSDictionary *) aUserInfo {
    if (ISDEBUG) {
        LOG(@"UserInfo: %@", aUserInfo);
    }
    
    if (mIsBackgroundRun) {
        // 处理推送消息
        if (!mIsReloadData) {
            // 显示完后就必须处理push消息
        }
    }
}

- (void) applicationDidBecomeActive: (UIApplication *) application {
    // 上传deviceToken
    // [MCMSManager uploadDeviceToken: @""];
    
    mInternetReach = [Reachability reachabilityForInternetConnection];
	[mInternetReach startNotifier];
    
    NetworkStatus netStatus = [mInternetReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未能连接到网络，请检查您的网络 ！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            break;
        }
            
    }
}

- (void) applicationDidEnterBackground: (UIApplication *) application {
    mIsBackgroundRun = YES;
    if (mEnterBackgroundTime != nil) {
        SAFE_ARC_RELEASE(mEnterBackgroundTime);
        mEnterBackgroundTime = nil;
    }
    mEnterBackgroundTime = [[NSString alloc] initWithString: [Function nowInterval]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark -
#pragma mark Memory management
- (void) applicationDidReceiveMemoryWarning: (UIApplication *) application {
    if (ISDEBUG) {
        LOG(@"Receive Memory Warning");
        // 应用程序接收到一个内存警告，应该清除共享的高速缓存，释放内存。
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

- (void) dealloc {
    // 先释放掉加载的所有的ViewController
    [ViewControllerManager freeBaseViewController];
    
    if (mEnterBackgroundTime != nil) {
        SAFE_ARC_RELEASE(mEnterBackgroundTime);
        mEnterBackgroundTime = nil;
    }
    
    if (mNavigationController != nil) {
        SAFE_ARC_RELEASE(mNavigationController);
        mNavigationController = nil;
    }
    
	SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark -其他辅助功能
#pragma mark 分享设置
- (void)initializePlat
{
    [ShareSDK registerApp:@"161594744833"];
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"1993553337"
                               appSecret:@"ae538eee27c914ef3cbf2a9260cec6c4"
                             redirectUri:@"http://www.hnqlhr.com"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801498894"
                                  appSecret:@"0ff439713ed947ae7487dfc7fe59bf90"
                                redirectUri:@"http://www.hnqlhr.com"
                                   wbApiCls:[WeiboApi class]];
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxd0428ec7ef803f44" wechatCls:[WXApi class]];
    
    
    //监听用户信息变更
    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(userInfoUpdateHandler:)];
}


- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = NSLocalizedString(@"TEXT_SINA_WEIBO", @"新浪微博");
            break;
        case ShareType163Weibo:
            platName = NSLocalizedString(@"TEXT_NETEASE_WEIBO", @"网易微博");
            break;
        case ShareTypeDouBan:
            platName = NSLocalizedString(@"TEXT_DOUBAN", @"豆瓣");
            break;
        case ShareTypeFacebook:
            platName = @"Facebook";
            break;
        case ShareTypeKaixin:
            platName = NSLocalizedString(@"TEXT_KAIXIN", @"开心网");
            break;
        case ShareTypeQQSpace:
            platName = NSLocalizedString(@"TEXT_QZONE", @"QQ空间");
            break;
        case ShareTypeRenren:
            platName = NSLocalizedString(@"TEXT_RENREN", @"人人网");
            break;
        case ShareTypeSohuWeibo:
            platName = NSLocalizedString(@"TEXT_SOHO_WEIBO", @"搜狐微博");
            break;
        case ShareTypeTencentWeibo:
            platName = NSLocalizedString(@"TEXT_TENCENT_WEIBO", @"腾讯微博");
            break;
        case ShareTypeTwitter:
            platName = @"Twitter";
            break;
        case ShareTypeInstapaper:
            platName = @"Instapaper";
            break;
        case ShareTypeYouDaoNote:
            platName = NSLocalizedString(@"TEXT_YOUDAO_NOTE", @"有道云笔记");
            break;
        case ShareTypeGooglePlus:
            platName = @"Google+";
            break;
        case ShareTypeLinkedIn:
            platName = @"LinkedIn";
            break;
        default:
            platName = NSLocalizedString(@"TEXT_UNKNOWN", @"未知");
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}

#pragma mark 分享
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - 支付宝相关
//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parse:url application:application];
    //分享
    [ShareSDK handleOpenURL:url
                        wxDelegate:self];
	return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                //通知相关页面更新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didPaysuccess" object:nil];
			}
            
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}


//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未能连接到网络，请检查您的网络 ！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            alert = nil;
            break;
        }
    }
}

@end
