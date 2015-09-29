//
//  FileManager.m
//  iPad
//
//  Jackson.He
//

#import "FileManager.h"
#import "ARCMacros.h"
#import "Macros.h"
#import "TerminalData.h"
#import "ConstDef.h"
#include <sys/param.h>     
#include <sys/mount.h>

#pragma mark -
#pragma mark 设备总容量
// 设备总容量 
void GetDiskTotalSpaceSize(long long *aTotalSpace) {
    struct statfs vBuf;
    
    *aTotalSpace = 0;
    if (statfs("/private/var", &vBuf) >= 0) {
        *aTotalSpace = (long long) vBuf.f_bsize * vBuf.f_blocks;
    }    
}

#pragma mark -
#pragma mark 设备可用空间
// 设备可用空间
void GetDiskFreeSpaceSize(long long *aFreespace) {
    struct statfs vBuf;
    *aFreespace = 0;
	if (statfs("/private/var", &vBuf) >= 0) {
        *aFreespace = (long long)vBuf.f_bsize * vBuf.f_bfree;
    }
}

@implementation FileManager

#pragma mark -
#pragma mark 将数据写入到文件中
int writeFileData(const char *aFileName, const char *aSorData, long long aLength, bool aIsAppend) {
	if ((aFileName == NULL) || (aSorData == NULL) || (aLength <= 0)) {
        return -1;
    };
	
	FILE *vFile = NULL;
	if (aIsAppend){
		vFile = fopen(aFileName, "a");
	} else {
		vFile = fopen(aFileName, "w");
	}
	
	if (vFile != NULL) {
		int vLen = ftell(vFile);
		if (vLen > 0) {
            fseek(vFile, vLen, SEEK_END);
        }
        
		fwrite(aSorData, sizeof(char), (size_t) aLength, vFile);
		fseek(vFile, 0,SEEK_END);
		vLen = ftell(vFile);
		fclose(vFile);
		return vLen;
	} 
    return -1;
}

#pragma mark -
#pragma mark 本地文件是否存在
+ (BOOL) fileIsExist: (NSString *) aFilePathOrName {
	// 判断文件是否存在
	return [[NSFileManager defaultManager] fileExistsAtPath: aFilePathOrName];
}

// 删除文件或是文件夹
+ (BOOL) deleteFile: (NSString *) aFilePathOrName {
	NSError *vError = nil;
	return [[NSFileManager defaultManager] removeItemAtPath: aFilePathOrName error: &vError];;    
}

// 强制建立文件夹
+ (void) forceCreateDirectory: (NSString *) aPathName {
    [[NSFileManager defaultManager] createDirectoryAtPath: aPathName
                              withIntermediateDirectories: YES 
                                               attributes: nil
                                                    error: nil];
}

#pragma mark -
#pragma mark 将数据写入到文件中
// 将数据写入到文件中
+ (void) writeFileByFileName: (NSString *) aFileName
              streamFileData: (NSMutableData *) aData
                    isAppend: (BOOL) aIsAppend {
	if ((aFileName == nil) || (aData == nil)) {
		return;
	}
    
    NSString *vFilePath = [self getFilePath: aFileName];
    // 查看文件路径是否存在，如果不存在，则创建
    if (![self fileIsExist: vFilePath]) {
        [self forceCreateDirectory: vFilePath];
    }
    
    writeFileData([aFileName UTF8String], (char *)[aData bytes], (long long) [aData length], aIsAppend);
}

#pragma mark -
#pragma mark 取文件路径
// 取文件路径
+ (NSString *) getFilePath: (NSString *) aFilePathAndName {
	const char *vSorFileName = [aFilePathAndName UTF8String];
	int vCount = [aFilePathAndName length];
    int vBegin = 0;        
    while (--vCount >= 0) {
        if (vSorFileName[vCount] == '/') {
            break;
        }
        
        vBegin++;
    }
    
    vCount = [aFilePathAndName length];
    NSString *vReturnStr = [aFilePathAndName substringToIndex: vCount - vBegin];
    return vReturnStr;
}

#pragma mark -
#pragma mark 取文件名
// 取文件名
+ (NSString *) getFileName: (NSString *) aFilePathAndName {
	const char *vSorFileName = [aFilePathAndName UTF8String];
	int vCount = [aFilePathAndName length];
    int vBegin = 0;        
    while (--vCount >= 0) {
        if (vSorFileName[vCount] == '/') {
            break;
        }
        
        vBegin++;
    }
    
    vCount = [aFilePathAndName length];
    NSString *vReturnStr = [aFilePathAndName substringFromIndex: vCount - vBegin];
    return vReturnStr; 
}

// 文件移动(从一个文件夹移动到另一个文件夹)
+ (BOOL) movePathFrom: (NSString *) aSourcePath toPath: (NSString *) aDestPath {
	// 判断文件是否存在
	if (aSourcePath == nil || ![self fileIsExist: aSourcePath]) {
		return NO;
	}
	
	NSError *vError = nil;
    // 如果文件夹不存在，则创建
	if (![self fileIsExist: aDestPath]) {
        [self forceCreateDirectory: aDestPath];
    }
    
	if ([self fileIsExist: aDestPath]) {
		[[NSFileManager defaultManager] removeItemAtPath: aDestPath error: &vError];
	}
    
	return [[NSFileManager defaultManager] moveItemAtPath: aSourcePath 
                                                   toPath: aDestPath
                                                    error: &vError];
}

// 文件拷贝
+ (BOOL) copyFile: (NSString *) aSourceFileName toFile: (NSString *) aDestFileName {
    if ([FileManager fileIsExist: aDestFileName]) {
        [FileManager deleteFile: aDestFileName];
    }
    
    NSError* vError = nil;
    return [[NSFileManager defaultManager] copyItemAtPath: aSourceFileName 
                                                   toPath: aDestFileName
                                                    error: &vError];
}

// 计算文件夹size
+ (void) fileSizeForDir: (NSString *) aPath pathSize: (long long *) aSize {
    NSFileManager *vFileManager = [[NSFileManager alloc] init];
    @try {
        NSArray *vFiles = [vFileManager contentsOfDirectoryAtPath: aPath error: nil];
        for (int vIndex = 0; vIndex < [vFiles count]; vIndex++) {
            NSString *vFullPath = [aPath stringByAppendingPathComponent: [vFiles objectAtIndex: vIndex]];
            BOOL vIsDir;
            if (!([vFileManager fileExistsAtPath: vFullPath isDirectory: &vIsDir] && vIsDir)) {
                NSDictionary *vFileAttributeDic =[vFileManager attributesOfItemAtPath: vFullPath error: nil];
                *aSize += vFileAttributeDic.fileSize;
            } else {
                [self fileSizeForDir: vFullPath pathSize: aSize];
            }
        }
    } @finally {
        SAFE_ARC_RELEASE(vFileManager);
    }
}

// 将文件的修改时间改成今天
+ (void) modifyFileModifyDateToToday: (NSString *) aFilePath {
	NSDate *vData = [NSDate date];
	[self modifyFileDate: aFilePath attributeKey: NSFileModificationDate attributeValue: vData];
}

// 将文件的修改时间改成某一天
+ (void) modifyFileModifyDate: (NSString *) aFilePath toDate: (NSString *) aModifyDate {
    NSDateFormatter* vDateFormater = [[NSDateFormatter alloc] init];
    @try {
        [vDateFormater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *vDate = [vDateFormater dateFromString: aModifyDate];
        [self modifyFileDate: aFilePath attributeKey: NSFileModificationDate attributeValue: vDate];
    } @finally {
        SAFE_ARC_RELEASE(vDateFormater);
    }    
}

// 将文件的创建时间改成今天
+ (void) modifyFileCreateDateToToday: (NSString *) aFilePath {
	NSDate *vData = [NSDate date];
	[self modifyFileDate: aFilePath attributeKey: NSFileCreationDate attributeValue: vData];    
}

// 修改文件时间
+ (void) modifyFileDate: (NSString *) aFilePath attributeKey: (NSString *) aKey attributeValue: (id) aValue {
    if (aFilePath == nil || aKey == nil || aValue == nil) {
        return;
    }
	
	NSError *vError;
	NSMutableDictionary *vAttributes = [NSMutableDictionary dictionary];
	if (vAttributes != nil) {
		[vAttributes setValue: aValue forKey: aKey];
		[[NSFileManager defaultManager] setAttributes: vAttributes ofItemAtPath: aFilePath error: &vError];
	}
}

// 判断修改时间是否为当天
+ (NSString *) getFileModifyDate: (NSString *) aFilePath {
	if (![self fileIsExist: aFilePath]) {
        return nil;
    }
    
    // 得到文件属性
    NSError *vError;
    NSDictionary *vFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath: aFilePath
                                                                                     error: &vError];
    if (vFileAttributes != nil) {
        NSDate *vFileModifyDate = [vFileAttributes objectForKey: NSFileModificationDate];
        NSDateFormatter *vDateFormater = [[NSDateFormatter alloc] init];
        @try {
            [vDateFormater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            return [vDateFormater stringFromDate: vFileModifyDate];
        } @finally {
            SAFE_ARC_RELEASE(vDateFormater);
        }
    }
    return nil;
}

+ (NSString *)getLibrarayFilePath:(NSString *)aFileName{
    
    NSString *vLibpath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *vFilePath = [vLibpath stringByAppendingPathComponent:aFileName];
    return vFilePath;
}

//获取本目录文件下得所有文件
+(NSArray *)getAllDirectoryInFile:(NSString *)aFilePath
{
    NSArray *vFileDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:aFilePath error:nil];
    
    return vFileDirectory;
}

//获取document目录中的文件
+(NSString *)pathInDocumentDirectory:(NSString *)aFileName{
    //获取沙盒中的文档目录
    NSArray *vDocumentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *vDocumentDirectory=[vDocumentDirectories objectAtIndex:0];
    NSString *vFilePath = [vDocumentDirectory stringByAppendingPathComponent:aFileName];
    
    return vFilePath;
}

//获取缓存目录中的文件
+(NSString *)pathInCacheDirectory:(NSString *)aFileName{
    //获取沙盒中缓存文件目录
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    //将传入的文件名加在目录路径后面并返回
    NSString *vFilePath = [cacheDirectory stringByAppendingPathComponent:aFileName];
    
    return vFilePath;
}

+ (void)createFileAtCacheDirectory:(NSString *)aFileName{
    //获取沙盒中缓存文件目录
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    //将传入的文件名加在目录路径后面并返回
    NSString *vFilePath = [cacheDirectory stringByAppendingPathComponent:aFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:vFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:vFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
