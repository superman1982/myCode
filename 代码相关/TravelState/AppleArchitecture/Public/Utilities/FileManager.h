//
//  FileManager.h
//  iPad
//
//  Jackson.He
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

// 本地文件或是路径是否存在
+ (BOOL) fileIsExist: (NSString *) aFilePathOrName;
// 删除文件或是文件夹
+ (BOOL) deleteFile: (NSString *) aFilePathOrName;
// 强制建立文件夹
+ (void) forceCreateDirectory: (NSString *) aPathName;

// 将数据写入到文件中
+ (void) writeFileByFileName: (NSString *) aFileName
              streamFileData: (NSMutableData *) aData
                    isAppend: (BOOL) aIsAppend;

// 取文件路径
+ (NSString *) getFilePath: (NSString *) aFilePathAndName;

// 取文件名
+ (NSString *) getFileName: (NSString *) aFilePathAndName;

// 文件移动(从一个文件夹移动到另一个文件夹)
+ (BOOL) movePathFrom: (NSString *) aSourcePath toPath: (NSString *) aDestPath;

// 文件拷贝
+ (BOOL) copyFile: (NSString *) aSourceFileName toFile: (NSString *) aDestFileName;

// 计算文件夹size
+ (void) fileSizeForDir: (NSString *) aPath pathSize: (long long *) aSize;

// 将文件的修改时间改成今天
+ (void) modifyFileModifyDateToToday: (NSString *) aFilePath;
// 将文件的修改时间改成某一天
+ (void) modifyFileModifyDate: (NSString *) aFilePath toDate: (NSString *) aModifyDate;
// 将文件的创建时间改成今天
+ (void) modifyFileCreateDateToToday: (NSString*) aFilePath;
// 修改文件时间
+ (void) modifyFileDate: (NSString *) aFilePath attributeKey: (NSString *) aKey attributeValue: (id) aValue;
// 判断修改时间是否为当天
+ (NSString *) getFileModifyDate: (NSString*) aFilePath;

//获取本目录文件下得所有文件
+(NSArray *)getAllDirectoryInFile:(NSString *)aFilePath;

//获取document目录中的文件名
+(NSString *)pathInDocumentDirectory:(NSString *)aFileName;

//获取缓存目录中的文件
+(NSString *)pathInCacheDirectory:(NSString *)aFileName;
//在缓存目录中创建文件
+ (void)createFileAtCacheDirectory:(NSString *)aFileName;
// 文件写入
extern int writeFileData(const char *aFileName, const char *aSorData, long long aLength, bool aIsAppend);
// 设备总容量
extern void GetDiskTotalSpaceSize(long long *aTotalSpace);
// 设备可用空间
extern void GetDiskFreeSpaceSize(long long *aFreeSpace); 




@end
