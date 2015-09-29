//
//  Function.m
//  iPhone
//
//  Jackson.He
//

#import <QuartzCore/QuartzCore.h>
#import "Function.h"
#import "FileManager.h"
#import "ZipArchive.h"
#import "TerminalData.h"

@implementation Function

#pragma mark -
#pragma mark 从字符数组中取得字符串
// 从字符数组中取得字符串
+ (NSString *) getStrFromCharArr: (const char *) aCharArray {
	return [NSString stringWithUTF8String: aCharArray];
}

#pragma mark -
#pragma mark 显示提示信息
// 显示提示信息
+ (void) showMessage: (NSString *) aMessage delegate: (id) aDelegate {
	UIAlertView *vAlartView = [[UIAlertView alloc] initWithTitle: @"提示" 
                                                         message: aMessage 
                                                        delegate: aDelegate 
                                               cancelButtonTitle: @"确定" 
                                               otherButtonTitles: nil];
	[vAlartView show];
    SAFE_ARC_RELEASE(vAlartView);
}
// 显示提示信息
+ (void) showMessage: (NSString *) aTitle message: (NSString *) aMessage delegate: (id) aDelegate {
	UIAlertView *vAlartView = [[UIAlertView alloc] initWithTitle: aTitle
                                                         message: aMessage
                                                        delegate: aDelegate
                                               cancelButtonTitle: @"确定"
                                               otherButtonTitles: nil];
	[vAlartView show];
    SAFE_ARC_RELEASE(vAlartView);
}

// URL解码
+ (NSString *) decodeFromPercentEscapeString: (NSString *) aSorStr {
    NSMutableString *vOutputStr = [NSMutableString stringWithString: aSorStr];
    [vOutputStr replaceOccurrencesOfString: @"+"  
                                withString: @" "  
                                   options: NSLiteralSearch  
                                     range: NSMakeRange(0, [vOutputStr length])];  
    
    return [vOutputStr stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];  
}

// 字符串是否为空
+ (BOOL) stringIsEmpty: (NSString *) aString {
    return (aString == nil) || [aString isEqualToString: @""];
}

// 将文件aSorFileName解压至目录aDestPath中
+ (void) unZipFile: (NSString *) aSorFileName toDestFilePath: (NSString *) aDestPath {
	if ((aSorFileName == nil) || (aDestPath == nil)) {
		return;
	}
    
    // 如果目录不存在，需要强制建立
    if (![FileManager fileIsExist: aDestPath]) {
        [FileManager forceCreateDirectory: aDestPath];
    }
	
	if ([FileManager fileIsExist: aSorFileName]) {	
		ZipArchive *vZip = [[ZipArchive alloc] init];
        @try {
            if ([vZip UnzipOpenFile: aSorFileName]) {
                [vZip UnzipFileTo: aDestPath overWrite: YES];
                [vZip UnzipCloseFile];
            }
        } @finally {
            SAFE_ARC_RELEASE(vZip);
        }
	}
}

// 输入数据获取对应的格式化的空间数据
+ (NSString *) formateSpaceSizeString: (long long) aValue {
    float vValueF = 0.0f;
    long long vTotalCount = aValue;
    NSString * vValueStr = nil;
    
    if (vTotalCount / (1024.0f * 1024.0f * 1024.0f) > 1 ) {
        vValueF = vTotalCount / (1024.0f * 1024.0f * 1024.0f);
        vValueStr = [NSString stringWithFormat: @"%.2fGB", vValueF];
    } else if (vTotalCount / (1024.0f * 1024.0f) > 1) {
        vValueF = vTotalCount / (1024.0f * 1024.0f);
        vValueStr = [NSString stringWithFormat: @"%.2fMB", vValueF];
    } else if (vTotalCount / 1024.0f > 1) {
        vValueF = vTotalCount / 1024.0f;
        vValueStr = [NSString stringWithFormat: @"%.2fKB", vValueF];
    } else {
        vValueStr = [NSString stringWithFormat: @"%dByte", (NSInteger)vTotalCount];
    }	
    return vValueStr;
}

// 根据下载的aDownloadState，返回对应的提示字符串
+ (NSString *) getHintStr: (DownloadState) aDownloadState {
    switch (aDownloadState) {
    case dsNetError:
        return START_NETWORKERROR;
        break;
    case dsDataError:
    case dsServerError:
        return START_SERVERERROR; 
        break;
    default:
        return @"";
        break;
    }
}

// 根据下载的aDownloadState，弹出相应的提示框
+ (void) dialogHintStr: (DownloadState) aDownloadState {
    if (aDownloadState == dsOK) {
        return;
    }
    
    // 弹出相应的提示
    UIAlertView* vAlertView = [[UIAlertView alloc] initWithTitle: @"提示"
														 message: [self getHintStr: aDownloadState]
														delegate: nil 
											   cancelButtonTitle: @"确认" 
											   otherButtonTitles: nil];
    @try {
        [vAlertView show];
    } @finally {
        SAFE_ARC_RELEASE(vAlertView);
    }
}

// 从aDate起，总共过去了好多秒
+ (NSTimeInterval) intervalSinceDate: (NSString *) aDate {
    if ([self stringIsEmpty: aDate]) {
        return 0;
    }
    NSDateFormatter *vDateFormate = [[NSDateFormatter alloc] init];
    @try {
        [vDateFormate setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *vDate = [vDateFormate dateFromString: aDate];
        
        NSTimeInterval vLateTimeInterval = [vDate timeIntervalSince1970] * 1;
        
        NSDate *vNowDate = [NSDate date];
        NSTimeInterval vNowTimeInterVal = [vNowDate timeIntervalSince1970] * 1;
        
        
        return vNowTimeInterVal - vLateTimeInterval;
    } @finally {
        SAFE_ARC_RELEASE(vDateFormate);
    }
}

// 返回现在的时间串
+ (NSString *) nowInterval {
    NSDateFormatter *vDateFormater = [[NSDateFormatter alloc] init];
    @try {
        [vDateFormater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        return [vDateFormater stringFromDate: [NSDate date]];
    } @finally {
        SAFE_ARC_RELEASE(vDateFormater);
    }
}

// 返回现在的时间串
+ (NSString *) nowIntervalForFileName {
    NSDateFormatter *vDateFormater = [[NSDateFormatter alloc] init];
    @try {
        [vDateFormater setDateFormat: @"yyyyMMddHHmmss"];
        return [vDateFormater stringFromDate: [NSDate date]];
    } @finally {
        SAFE_ARC_RELEASE(vDateFormater);
    }
}

// 获取某个View的screenshot
+ (UIImage *) ScreenShot: (UIView *) aView {
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, NO, [TerminalData deviceScale]);
    [aView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *vImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return vImage;
}

@end

