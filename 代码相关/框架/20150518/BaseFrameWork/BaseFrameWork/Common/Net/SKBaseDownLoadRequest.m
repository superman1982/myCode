//
//  SKBaseDownLoadRequest.m
//  BaseFrameWork
//
//  Created by lin on 15/5/22.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseDownLoadRequest.h"
#import "SKNetManager.h"
#import "SkDataUtil.h"
#import "SKDownLoadExtendParam.h"
#import "SKDownLoadResponse.h"

@implementation SKBaseDownLoadRequest

-(void)dealloc{
    [_param release];
    [super dealloc];
}

-(void)downLoadData{
    if ([_downLoadFileDelegate respondsToSelector:@selector(didStartDownLoadFile:)]) {
        [_downLoadFileDelegate didStartDownLoadFile:self];
    }
    //组装图片名字
    SKDownLoadExtendParam *downLoadParam = (SKDownLoadExtendParam *)self.param;
    NSString *imageName = downLoadParam.uuID;
    //----end---
    [SKNetManager downLoadData:self.param.requestURLStr
                      SavePath:((SKDownLoadExtendParam *)self.param).saveFilePathDirectory imageName:imageName Success:^(NSURLResponse *response, NSURL *filePath)
    {
        [self dealSuccess:response FilePath:filePath];
    }
                       Failure:^(NSURLResponse *responseObject, NSError *error)
    {
        [self dealFailure:responseObject Error:error];
    }];
}

#pragma mark 处理下载文件
-(void)dealSuccess:(NSURLResponse *)response  FilePath:(NSURL *)filePath{
    SKDownLoadResponse *vResponce = [[[SKDownLoadResponse alloc] init] autorelease];
    vResponce.filePath = filePath.relativePath;

    if ([_downLoadFileDelegate respondsToSelector:@selector(didDownLoadFileSucess:WithRequest:)]) {
        [_downLoadFileDelegate didDownLoadFileSucess:vResponce WithRequest:self];
    }
}

-(void)dealFailure:(NSURLResponse *)responseObject  Error:( NSError *)error{
    if ([_downLoadFileDelegate respondsToSelector:@selector(didDownLoadFileSucess:WithRequest:)]) {
        [_downLoadFileDelegate didDownLoadFileFailure:responseObject Error:error];
    }
}
@end
