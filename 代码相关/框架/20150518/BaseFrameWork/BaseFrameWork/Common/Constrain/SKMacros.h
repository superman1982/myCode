//
//  SKMacros.h
//  iPad
//
//  
//

#import "SKAppDelegate.h"

// 应用程序托管
#define AppDelegateInstance	                        ((SKAppDelegate *)([UIApplication sharedApplication].delegate))

#define YK_BACKGROUND_COLOR  [UIColor colorWithRed:0.960784 green:0.964706 blue:0.964706 alpha:1]
#define YK_BUTTON_COLOR     [UIColor colorWithRed:0.137255 green:0.603922 blue:0.913725 alpha:1]


#define YK_String(key)               NSLocalizedString(key, nil)
// 其它的宏定义
#ifdef DEBUG
	#define                                         NSLog(...) NSLog(__VA_ARGS__)
	#define                                         LOG_METHOD NSLog(@"%s", __func__)
    #define                                         LOGERROR(...) NSLog(@"%@传入数据有误",__VA_ARGS__)
#else
	#define                                         NSLog(...)
	#define                                         LOG_METHOD
    #define                                         LOGERROR(...) NSLog(@"%@传入数据有误",__VA_ARGS__)
#endif

#define RGBCOLOR(r, g, b) [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : 1]
//16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//释放对象
#define SK_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
//字体
#define FONTSYS(size) ([UIFont systemFontOfSize:(size)])
//图片
#define SY_IMAGE(name) [UIImage imageNamed:(name)]

//判断系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//判断是否大于 IOS7
#define IS_IOS7 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && SYSTEM_VERSION_LESS_THAN(@"8.0"))
#define IS_IOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") 
