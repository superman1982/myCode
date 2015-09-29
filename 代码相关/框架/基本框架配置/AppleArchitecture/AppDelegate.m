//
//  iPadAppDelegate.m
//  iPad
//
//  Jackson.He

#import "AppDelegate.h"
#import "ViewControllerManager.h"
#import "UserManager.h"
#import "Reachability.h"
#import "Function.h"

@implementation AppDelegate

#pragma mark -
#pragma mark Application lifecycle
- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {
    self.window = SAFE_ARC_AUTORELEASE([[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]);
    
    self.window.backgroundColor = [UIColor whiteColor];
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
    
    [ViewControllerManager createViewControllerManegaerForkeys:@[NOMAL_MANEGER]];
    ViewControllerManager *vManeger = [ViewControllerManager getViewControllerManagerWithKey:NOMAL_MANEGER];
    [vManeger createViewController:@"LoginViewController"];
    [vManeger showBaseViewController:@"LoginViewController" AnimationType:vaDefaultAnimation SubType:0];
    self.window.rootViewController = vManeger.navigationController;
    //版本检测
    [[TerminalData instanceTerminalData] checkVersion:YES];
    //检测用户是否自动登录
    [UserManager checkIfIsAutoLoginWithCompletionBlock:nil];
    
    
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
        NSLog(@"Failed to get token, error: %@", error);
    }
}

- (void) application: (UIApplication *) application didReceiveRemoteNotification: (NSDictionary *) aUserInfo {
    if (ISDEBUG) {
        NSLog(@"UserInfo: %@", aUserInfo);
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
        NSLog(@"Receive Memory Warning");
        // 应用程序接收到一个内存警告，应该清除共享的高速缓存，释放内存。
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

- (void) dealloc {
    // 先释放掉加载的所有的ViewController
    [[ViewControllerManager getViewControllerManagerWithKey:NOMAL_MANEGER]freeBaseViewController];
    
    if (mEnterBackgroundTime != nil) {
        SAFE_ARC_RELEASE(mEnterBackgroundTime);
        mEnterBackgroundTime = nil;
    }
    
	SAFE_ARC_SUPER_DEALLOC();
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
