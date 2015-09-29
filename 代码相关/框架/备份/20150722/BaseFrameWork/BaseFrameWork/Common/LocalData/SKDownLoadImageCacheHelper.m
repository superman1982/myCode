//
//  SKDownLoadImageCacheHelper.m
//  BaseFrameWork
//
//  Created by lin on 15/5/20.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKDownLoadImageCacheHelper.h"
#import "SKMacros.h"
#import "SKDownLoadExtendParam.h"
#import "SKDownLoadRequest.h"
#import "SKDownLoadResponse.h"
#import "SKDBHelper.h"

#define kDateFormate_yyyy_mm_dd_HH_mm        @"yyyy-MM-dd HH:mm:ss"   
#define kDateFormate_YYYY_MM_DD              @"yyyy-MM-dd"           // 2013-01-22
#define kDBNeedDelete                        @"needDelete"

static SKDownLoadImageCacheHelper *_shareSKDownLoadImageCaher = nil;

@interface SKDownLoadImageCacheHelper()<SKBaseWebRequestDownLoadFileDelegate>
{
    NSMutableDictionary    *_imageRequestIDDic;
}
@end
@implementation SKDownLoadImageCacheHelper

+ (SKDownLoadImageCacheHelper *) helper {
    @synchronized(self) {
        if (_shareSKDownLoadImageCaher == nil) {
            _shareSKDownLoadImageCaher = [[SKDownLoadImageCacheHelper alloc] init];
        }
        
        return _shareSKDownLoadImageCaher;
    }
}

-(id)init{
    self = [super init];
    if (self) {
        if (_imageRequestIDDic == nil) {
            _imageRequestIDDic = [[NSMutableDictionary alloc] init];
        }
        SKDBHelper *dbHelper = [[SKDBHelper alloc] init];
        [dbHelper createImageTable];
        [dbHelper release];
    }
    return self;
}

+(void)destroyHelper{
    [_shareSKDownLoadImageCaher release];
    _shareSKDownLoadImageCaher = nil;
}

#if __has_feature(objc_arc)
#else
- (void)dealloc{
    SK_RELEASE_SAFELY(_imageRequestIDDic);
    [super dealloc];
}

#endif

+(NSURL *)downloadImageFilePathURL{
   NSURL *vFileURL =  [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    vFileURL = [vFileURL URLByAppendingPathComponent:@"DownLoadImages" isDirectory:YES];
    BOOL vIsExistFilePath = [[NSFileManager defaultManager] fileExistsAtPath:vFileURL.absoluteString];
    if (!vIsExistFilePath) {
        [[NSFileManager defaultManager] createDirectoryAtURL:vFileURL withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return vFileURL;
}


+ (NSString *)stringFromDateStr:(NSString *)dateStr formatter:(NSString *)aFormat toFormatter:(NSString *)aToFormatter
{
    if (dateStr.length == 0) {
        return nil;
    }
    NSString *aReuslt = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:aFormat];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:aToFormatter];
    aReuslt = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return aReuslt;
}

+(NSString *)isExistFileWithUUID:(NSString *)aUniqueID{
    if (aUniqueID == nil) {
        return nil;
    }
    
    NSURL *vDownFileURLPath = [self downloadImageFilePathURL];
    NSString *vFilePath = [vDownFileURLPath relativePath];
    NSArray *vFileDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:vFilePath error:nil];
    NSString *imageName = nil;
    for (NSString *vFileName in vFileDirectory) {
        if ([vFileName rangeOfString:aUniqueID].location != NSNotFound) {
            imageName = vFileName;
            return [vFilePath stringByAppendingPathComponent:imageName];
        }
    }

    return nil;
}

+(NSString *)isExistInDataBaseUUID:(NSString *)aUniqueID lasModifyDate:(NSString *)aModifyDate{
    if (aUniqueID == nil) {
        return nil;
    }
    SKDBHelper *dbHelper = [[SKDBHelper alloc] init];
    FMResultSet *set = [dbHelper selectImageTableUUID:aUniqueID];
    if (set) {
        NSString *dateStr = [set stringForColumn:@"lastModifyTime"];
        NSString *filePath = [set stringForColumn:@"filePath"];
        NSString *baseFilePath = [SKDownLoadImageCacheHelper downloadImageFilePathURL].relativePath;
        filePath = [baseFilePath stringByAppendingPathComponent:[filePath lastPathComponent]];
        if([aModifyDate rangeOfString:dateStr].location == NSNotFound){
            return kDBNeedDelete;
        }
        return filePath;
    }
    return nil;
}

-(void)dealWithLocalFileUUID:(NSString *)aUniqueId
                  createDate:(NSString *)aCreateTime
              lastModifyDate:(NSString *)aLastModifyDate
                downloadType:(NSInteger)aIconType
                   container:(SKImageView *)aImageView
                    filePath:(NSString *)aFilePath
            serverIdentifier:(NSString *)aServerId{
    SKDownLoadResponse *vResponce = [[[SKDownLoadResponse alloc] init] autorelease];
    vResponce.filePath = aFilePath;
    
    SKDownLoadExtendParam *vParameter = [[SKDownLoadExtendParam alloc] init];
    vParameter.uuID = aUniqueId;
    vParameter.lastModifyTime = aLastModifyDate;
    vParameter.type = aIconType;
    [vParameter.imageViewArray addObject:aImageView];
    vParameter.serverID = aServerId;
    vParameter.isAreadyDownLoad = YES;
    vParameter.saveFilePathDirectory = [SKDownLoadImageCacheHelper downloadImageFilePathURL];
    SKDownLoadRequest *vRequest = [[[SKDownLoadRequest alloc] init] autorelease];
    vRequest.param = vParameter;
    
    [self didDownLoadFileSucess:vResponce WithRequest:vRequest];
}

-(void)dealWithLocalFileUUID:(NSString *)aUniqueId
                   container:(SKImageView *)aImageView
                    filePath:(NSString *)aFilePath{
    SKDownLoadResponse *vResponce = [[[SKDownLoadResponse alloc] init] autorelease];
    vResponce.filePath = aFilePath;
    
    SKDownLoadExtendParam *vParameter = [[SKDownLoadExtendParam alloc] init];
    vParameter.uuID = aUniqueId;
    vParameter.isAreadyDownLoad = YES;
    [vParameter.imageViewArray addObject:aImageView];
    vParameter.saveFilePathDirectory = [SKDownLoadImageCacheHelper downloadImageFilePathURL];
    SKDownLoadRequest *vRequest = [[[SKDownLoadRequest alloc] init] autorelease];
    vRequest.param = vParameter;
    
    [self didDownLoadFileSucess:vResponce WithRequest:vRequest];
}


-(void)downloadWithUUID:(NSString *)aUniqueId
             createDate:(NSString *)aCreateTime
         lastModifyDate:(NSString *)aLastModifyDate
           downloadType:(NSInteger)aIconType
              container:(SKImageView *)aImageView
       serverIdentifier:(NSString *)aServerId
              onlyCache:(BOOL)aOnlyCache
 {
     aImageView.uuID = aUniqueId;
     if (aUniqueId == nil || aUniqueId.length == 0 ) {
         return;
     }
     
     BOOL  neeedDeleteLocalFile = NO;
     
     //检查本地有文件
     NSString *vFilePath = [SKDownLoadImageCacheHelper isExistInDataBaseUUID:aUniqueId lasModifyDate:aLastModifyDate];
     if ([vFilePath pathExtension].length > 0) {
         [self dealWithLocalFileUUID:aUniqueId createDate:aCreateTime lastModifyDate:aLastModifyDate downloadType:aIconType container:aImageView  filePath:vFilePath serverIdentifier:aServerId];
         return;
     }
     
     if ([vFilePath isEqualToString:kDBNeedDelete]){
         neeedDeleteLocalFile = YES;
     }
     
     //检查是否已经下载过了
    if([_imageRequestIDDic objectForKey:aUniqueId] != nil){
         SKDownLoadRequest *vRequest = [_imageRequestIDDic objectForKey:aUniqueId];
         SKDownLoadExtendParam *vDownloadParameter = (SKDownLoadExtendParam *)vRequest.param;
         if (![vDownloadParameter.imageViewArray containsObject:aImageView]) {
             [vDownloadParameter.imageViewArray addObject:aImageView];
         }
         return;
     }
     
     // download
     NSString *requestTime =  [SKDownLoadImageCacheHelper stringFromDateStr:aLastModifyDate formatter:kDateFormate_yyyy_mm_dd_HH_mm toFormatter:kDateFormate_YYYY_MM_DD];
     SKDownLoadExtendParam *vParameter = [[SKDownLoadExtendParam alloc] init];
     vParameter.uuID = aUniqueId;
     vParameter.createDate = requestTime;
     vParameter.lastModifyTime = aLastModifyDate;
     vParameter.type = aIconType;
     vParameter.isNeedDeleteDataBase = neeedDeleteLocalFile;
     [vParameter.imageViewArray addObject:aImageView];
     vParameter.serverID = aServerId;
     vParameter.saveFilePathDirectory = [SKDownLoadImageCacheHelper downloadImageFilePathURL];
    SKDownLoadRequest *vRequest = [[SKDownLoadRequest alloc] init];
    vRequest.downLoadFileDelegate =  self;
    vRequest.param = vParameter;
    [vRequest downLoadData];
    
    [_imageRequestIDDic setObject:vRequest forKey:vParameter.uuID];
    [vParameter release];
}

-(void)downloadWithUUID:(NSString *)aUniqueId
              container:(SKImageView *)aImageView
{
    aImageView.uuID = aUniqueId;
    if (aUniqueId == nil || aUniqueId.length == 0 ) {
        return;
    }
    
    //本地有文件
    NSString *vFilePath = [SKDownLoadImageCacheHelper isExistFileWithUUID:aUniqueId];
    if (vFilePath != nil) {
        [self dealWithLocalFileUUID:aUniqueId container:aImageView filePath:vFilePath];
        return;
    }
    
    // download
    //检查是否已经下载过了
    if([_imageRequestIDDic objectForKey:aUniqueId] != nil){
        SKDownLoadRequest *vRequest = [_imageRequestIDDic objectForKey:aUniqueId];
        SKDownLoadExtendParam *vDownloadParameter = (SKDownLoadExtendParam *)vRequest.param;
        if (![vDownloadParameter.imageViewArray containsObject:aImageView]) {
            [vDownloadParameter.imageViewArray addObject:aImageView];
        }
        return;
    }
    SKDownLoadExtendParam *vParameter = [[SKDownLoadExtendParam alloc] init];
    vParameter.uuID = aUniqueId;
    vParameter.requestURLStr = [NSString stringWithFormat:@"http://www.hnqlhr.com/services/fileRoot/activity/%@/activity.jpg",aUniqueId];
    [vParameter.imageViewArray addObject:aImageView];
    vParameter.saveFilePathDirectory = [SKDownLoadImageCacheHelper downloadImageFilePathURL];
    SKDownLoadRequest *vRequest = [[SKDownLoadRequest alloc] init];
    vRequest.downLoadFileDelegate =  self;
    vRequest.param = vParameter;
    [vRequest downLoadData];
    
    [_imageRequestIDDic setObject:vRequest forKey:vParameter.uuID];
    [vParameter release];
}

#pragma mark DownLoadDeleaget
-(void)didStartDownLoadFile:(id)sender{
    
}

-(void)didDownLoadFileSucess:(SKDownLoadResponse *)aReponse WithRequest:(SKBaseDownLoadRequest *)aRequest{
    
    SKDownLoadExtendParam *vParameter = (SKDownLoadExtendParam *)aRequest.param;
    
    for (UIImageView *vImageView  in vParameter.imageViewArray) {
        if ([(SKImageView *)(vImageView) uuID] == vParameter.uuID) {
            vImageView.image = [UIImage imageWithContentsOfFile:aReponse.filePath];
        }
    }
    
    if (vParameter.isAreadyDownLoad) {
        return;
    }
    
    SKDBHelper *vDBHelper = [[SKDBHelper alloc] init];
    if (vParameter.isNeedDeleteDataBase) {
        [vDBHelper deleteItemInImageTableWithUUID:vParameter.uuID];
        NSString *baseFilePath = [SKDownLoadImageCacheHelper downloadImageFilePathURL].relativePath;
        NSString *filePath = [baseFilePath stringByAppendingPathComponent:aReponse.filePath.lastPathComponent];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [vDBHelper insertToImageTableUUID:vParameter.uuID modifyTime:vParameter.lastModifyTime type:[NSNumber numberWithInteger:vParameter.type ] serverId:vParameter.serverID filePath:aReponse.filePath];
    [vDBHelper release];
}

-(void)didDownLoadFileFailure:(id)sender Error:(NSError *)aError{
}
@end
