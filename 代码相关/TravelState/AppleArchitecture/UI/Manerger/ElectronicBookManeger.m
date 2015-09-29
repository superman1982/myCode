//
//  ElectronicBookManeger.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ElectronicBookManeger.h"
#import "FileManager.h"
#import "NetManager.h"
#import "ZipArchive.h"
#import "StringHelper.h"
#import "ConfigFile.h"
#import "JSONKit.h"

@implementation ElectronicBookManeger

+ (void)downLoadElectroniBook:(NSString *)aURLStr IsSynchronous:(BOOL)aIsSync ModifyTime:(NSString *)aTimeStr{
    if (![aURLStr isKindOfClass:[NSString class]]) {
        LOGERROR(@"downLoadElectroniBook");
        return;
    }
    //检查文件是否存在并创建
    NSString *vBookZipedPath = [FileManager pathInCacheDirectory:ELETRONICZIPEDFILENAME];
    NSString *vBookUNZipedPath = [FileManager pathInCacheDirectory:ELETRONICUNZIPEDFILENAME];
    if (![FileManager fileIsExist:vBookZipedPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:vBookZipedPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![FileManager fileIsExist:vBookUNZipedPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:vBookUNZipedPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (aIsSync) {
        [self downLoadDataSynchronous:aURLStr ZipedPath:vBookZipedPath UNZipedPath:vBookUNZipedPath ModifyTime:aTimeStr];
    }else{
        [self downLoadData:aURLStr ZipedPath:vBookZipedPath UNZipedPath:vBookUNZipedPath ModifyTime:aTimeStr];
    }
}

+ (void)downLoadData:(NSString *)aURLStr ZipedPath:(NSString *)aZipedPath UNZipedPath:(NSString *)aUNZipedPath ModifyTime:(NSString *)aTimeStr{
    if (![aURLStr isKindOfClass:[NSString class]]) {
        LOGERROR(@"downLoadElectroniBook");
        return;
    }

    //获取下载的zip文件名
    NSString *vItemZipFileName = [StringHelper getFileNameFromURL:aURLStr MiddleStr:@"/" Suffix:@".zip"];
    //组织zip文件名路径
    NSString *vItemZipFilePath = [NSString stringWithFormat:@"%@/%@",aZipedPath,vItemZipFileName];
    //组织解压后的文件路径,就是活动id
    NSString *vUNItemZipFilName = [StringHelper getUNZipedFileName:vItemZipFileName MiddleStr:@"."];
    NSString *vUNItemZipedFilePath = [NSString stringWithFormat:@"%@/%@",aUNZipedPath,vUNItemZipFilName];
    if (![FileManager fileIsExist:vUNItemZipedFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:vUNItemZipedFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //网络请求下载zip包
    [NetManager postDataFromWebAsynchronous:aURLStr Paremeter:Nil Success:^(NSURLResponse *response, NSData *responseObject) {
        if (responseObject != Nil) {
            //储存文件
            [responseObject writeToFile:vItemZipFilePath atomically:YES];
            //解压文件
            [ElectronicBookManeger UNZipFile:vItemZipFilePath ToPath:vUNItemZipedFilePath];
            [FileManager deleteFile:vItemZipFilePath];
            //保存为已经下载，以便每次进入列表时设置Cell为查看电子路书
            NSDictionary *vZipStateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"alreadDownLoad",@"downLoadState",aTimeStr,MODIFYDATE ,nil];
            //vUNItemZipFilName为活动id
            [ConfigFile saveConfigDictionary:[NSDictionary dictionaryWithObject:vZipStateDic forKey:vUNItemZipFilName]];
            //发布通知到Cell更新列表“下载”button为“查看”
            [[NSNotificationCenter defaultCenter] postNotificationName:@"electronicBookDidDownloadSucces" object:vUNItemZipFilName];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"electronicBookDidDownloadFailure" object:vUNItemZipFilName];
    } RequestName:@"下载路书" Notice:@""];
}

+ (void)downLoadDataSynchronous:(NSString *)aURLStr ZipedPath:(NSString *)aZipedPath UNZipedPath:(NSString *)aUNZipedPath ModifyTime:(NSString *)aTimeStr{
    if (![aURLStr isKindOfClass:[NSString class]]) {
        LOGERROR(@"downLoadElectroniBook");
        return;
    }
    
    //获取下载的zip文件名
    NSString *vItemZipFileName = [StringHelper getFileNameFromURL:aURLStr MiddleStr:@"/" Suffix:@".zip"];
    //组织zip文件名路径
    NSString *vItemZipFilePath = [NSString stringWithFormat:@"%@/%@",aZipedPath,vItemZipFileName];
    //组织解压后的文件路径
    NSString *vUNItemZipFilName = [StringHelper getUNZipedFileName:vItemZipFileName MiddleStr:@"."];
    NSString *vUNItemZipedFilePath = [NSString stringWithFormat:@"%@/%@",aUNZipedPath,vUNItemZipFilName];
    if (![FileManager fileIsExist:vUNItemZipedFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:vUNItemZipedFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //网络请求下载zip包
    NSData *vReturnData = [NetManager postToURLSynchronous:aURLStr Paremeter:nil timeout:30 RequestName:@"电子路书同步下载"];
    if (vReturnData != Nil) {
        //储存文件
        [vReturnData writeToFile:vItemZipFilePath atomically:YES];
        //解压文件
        [ElectronicBookManeger UNZipFile:vItemZipFilePath ToPath:vUNItemZipedFilePath];
        [FileManager deleteFile:vItemZipFilePath];
        //保存为已经下载，以便设置Cell为查看电子路书
        NSDictionary *vZipStateDic = [NSDictionary dictionaryWithObjectsAndKeys:@"alreadDownLoad",@"downLoadState",aTimeStr,MODIFYDATE ,nil];
        [ConfigFile saveConfigDictionary:[NSDictionary dictionaryWithObject:vZipStateDic forKey:vUNItemZipFilName]];
    }
}

+ (NSDictionary *)getElectronicBookInfo:(NSString *)aURLStr{
    NSString *vBookUNZipedPath = [FileManager pathInCacheDirectory:ELETRONICUNZIPEDFILENAME];
    //获取下载的zip文件名
    NSString *vZipFileName = [StringHelper getFileNameFromURL:aURLStr MiddleStr:@"/" Suffix:@".zip"];
    //组织解压后的文件路径
    NSString *vUNZipFilName = [StringHelper getUNZipedFileName:vZipFileName MiddleStr:@"."];
    //检查是否下载了电子路书
    NSDictionary *vConfigDic = [ConfigFile readConfigDictionary];
    NSString *vIfHasInfoStr = [vConfigDic objectForKey:vUNZipFilName];
    if (vIfHasInfoStr == nil) {
        LOG(@"%@getElectronicBookInfo电子路书文件没有储存",vUNZipFilName);
        return nil;
    }
    //如果文件不存在则重新下载
    NSString *vUNZipedFilePath = [NSString stringWithFormat:@"%@/%@",vBookUNZipedPath,vUNZipFilName];
    if (![FileManager fileIsExist:vUNZipedFilePath]) {
        [ElectronicBookManeger downLoadElectroniBook:aURLStr IsSynchronous:YES ModifyTime:Nil];
    }
    //拼接活动html路径
    NSMutableDictionary *vElectronicDic = [NSMutableDictionary dictionary];
    NSString *vMainActiviHTMLPath = [NSString stringWithFormat:@"%@/%@_Introduction.html",vUNZipedFilePath,vUNZipFilName];
    [vElectronicDic setObject:vMainActiviHTMLPath forKey:MAINHTMLKEY];
    
    //获取个站点json数据
    NSString *vRouteDataPath = [NSString stringWithFormat:@"%@/%@_JSNON",vUNZipedFilePath,vUNZipFilName];
    NSString *vJsonStr = [[NSString alloc] initWithContentsOfFile:vRouteDataPath encoding:NSUTF8StringEncoding error:nil];
    id vRouteDic = [[vJsonStr objectFromJSONString] mutableCopy];
    if (vRouteDic == Nil) {
        LOG(@"JSON文件:%@无法打开",vRouteDataPath);
        vRouteDic = [NSDictionary dictionary];
    }else{
         //设置文件路径
        [vRouteDic setObject:vUNZipedFilePath forKey:UNZIPFILEPATHKEY];
    }
    //保存站点json数据到新的字典
    [vElectronicDic setObject:vRouteDic forKey:ROUTEDICKEY];
    ////设置版本信息
    NSString *vVersionDataPath = [NSString stringWithFormat:@"%@/%@_Version",vUNZipedFilePath,vUNZipFilName];
    NSString *vStr = [[NSString alloc] initWithContentsOfFile:vVersionDataPath encoding:NSUTF8StringEncoding error:nil];
    IFISNIL(vStr);
    [vElectronicDic setObject:vStr forKey:VERSIONKEY];
    LOG(@"zip解析后的文件：%@",vElectronicDic);
    return vElectronicDic;
}

+(void)UNZipFile:(NSString *)aZipPath ToPath:(NSString *)aUNZipPath{
    ZipArchive *vZipArcive = [[ZipArchive alloc] init];
    [vZipArcive UnzipOpenFile:aZipPath];
    [vZipArcive UnzipFileTo:aUNZipPath overWrite:NO];
    [vZipArcive UnzipCloseFile];
    SAFE_ARC_RELEASE(vZipArcive);
}

@end
