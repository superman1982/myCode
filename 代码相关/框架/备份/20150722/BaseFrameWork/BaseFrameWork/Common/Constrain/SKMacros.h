//
//  SKMacros.h
//  iPad
//
//  
//

#import "SKAppDelegate.h"

// 应用程序托管
#define AppDelegateInstance	                        ((SKAppDelegate *)([UIApplication sharedApplication].delegate))

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

//判断是否是iphone5
#define IS_WIDESCREEN                              ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - (double)568 ) < __DBL_EPSILON__ )
#define IS_IPHONE                                  ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] || [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone Simulator" ])
#define IS_IPOD                                    ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5                                ( IS_IPHONE && IS_WIDESCREEN )

//判断字符串是否为空
#define IFISNIL(v)                                 (v = (v != nil) ? v : @"")
//判断NSNumber是否为空
#define IFISNILFORNUMBER(v)                        (v = (v != nil) ? v : [NSNumber numberWithInt:0])
//判断是否是字符串
#define IFISSTR(v)                                 (v = ([v isKindOfClass:[NSString class]]) ? v : [NSString stringWithFormat:@"%@",v])
