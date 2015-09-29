//
//  Function.h
//  iPhone
//
//  Jackson.He
//

#import "ARCMacros.h"
#import "ConstDef.h"

@interface Function : NSObject {	
	
}

#pragma mark -
#pragma mark 自定义函数
// 从字符数组中取得字符串
+ (NSString *) getStrFromCharArr: (const char *) aCharArray;
// 显示提示信息
+ (void) showMessage: (NSString *) aMessage delegate: (id) aDelegate;
// 显示提示信息
+ (void) showMessage: (NSString *) aTitle message: (NSString *) aMessage delegate: (id) aDelegate;
// URL解码
+ (NSString *) decodeFromPercentEscapeString: (NSString *) aSorStr;

// 字符串是否为空
+ (BOOL) stringIsEmpty: (NSString *) aString;

// 将文件aSorFileName解压至目录aDestPath中
+ (void) unZipFile: (NSString *) aSorFileName toDestFilePath: (NSString *) aDestPath;
// 输入数据获取对应的格式化的空间数据
+ (NSString *) formateSpaceSizeString: (long long) aValue;

// 根据下载的aDownloadState，返回对应的提示字符串
+ (NSString *) getHintStr: (DownloadState) aDownloadState;

// 根据下载的aDownloadState，弹出相应的提示框
+ (void) dialogHintStr: (DownloadState) aDownloadState;

// 从aDate起，总共过去了好多毫秒
+ (NSTimeInterval) intervalSinceDate: (NSString *) aDate;

// 返回现在的时间串
+ (NSString *) nowInterval;
// 返回作文件名用的时间串
+ (NSString *) nowIntervalForFileName;
// 获取某个View的screenshot
+ (UIImage *) ScreenShot: (UIView *) aView;

@end
