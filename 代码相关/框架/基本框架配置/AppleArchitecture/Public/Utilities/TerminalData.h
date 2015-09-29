//
//  TerminalData.h
//  iPhone
//
//  Jackson.He
//  本文件定义终端的一些常用参数，单例类

#import "ARCMacros.h"
#import "ConstDef.h"

#define NAVIGATIONBAR_HEIGHT 44

@interface TerminalData : NSObject

@property (nonatomic,retain) NSDictionary *applicationInitDic;

+ (TerminalData *) instanceTerminalData;

// 根目录和文件, 目录结构
+ (NSString *) rootDirectory;
// 设备ID
+ (NSString *) deviceID;
// 设备系统名称
+ (NSString *) deviceSys;
// 设备型号
+ (NSString *) deviceModel;
// SDK
+ (NSString *) deviceSDK;
// iOS系统版本信息，例如：3.1.3, 3.1.4, 3.2.5等等
+ (NSString *) deviceVersion;
// 设备的宽度
+ (int) deviceWidth;
// 设备的高度
+ (int) deviceHeight;
// 设备的Scale，Scale分别剩以宽度及高度就是分辨率
+ (float) deviceScale;
// 状态栏的高度
+ (int) statusBarHeight;

// 判断当前设备类型是否是iPad
+ (BOOL) isPad;

// 设备是否是竖屏
+ (BOOL) isPortait;
// 设备设置是否是竖屏
- (void) setIsPortait: (BOOL) aIsPortait;

// 是否是高清屏 
+ (BOOL) isRetina;
// 是否模拟器
- (BOOL) isSimulator;
//打电话
+(void)phoneCall:(UIView *)aView PhoneNumber:(NSString *)aNumberStr;
#pragma mark 获取当前版本信息
+(NSString *)getApplicationVersion;
//判断版本
- (void)checkVersion:(BOOL)isAutoCheck;
- (void)applicationInit;
@end