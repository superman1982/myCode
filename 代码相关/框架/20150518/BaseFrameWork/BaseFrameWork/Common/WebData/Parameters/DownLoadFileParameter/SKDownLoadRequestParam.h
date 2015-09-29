//
//  SKDownLoadRequestParameter.h
//  BaseFrameWork
//
//  Created by lin on 15/5/22.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseRequstParam.h"

@interface SKDownLoadRequestParam : SKBaseRequstParam

@property(nonatomic, copy)NSString *fileDownloadRequestID; // 文件下载请求id，随机生成
@property(nonatomic, assign)id delegate; // 每一个下载请求都有自己的delegate，考虑到多个附件一起下载
@property(nonatomic, assign)id downloadProgressDelegate;
@property(nonatomic, copy)NSString *uuID;
@property(nonatomic, copy)NSString *createDate;
@property(nonatomic, copy)NSString *lastModifyTime;
@property(nonatomic, copy)NSString *fileName;
@property(nonatomic, copy)NSString *suffix;
@property (nonatomic, assign)long long size;
@property(nonatomic, assign)BOOL allowCompressed;
@property(nonatomic, assign)NSInteger type;
@property(nonatomic, copy)NSString *downloadUrl;
@property(nonatomic, copy)NSString *vCode;
@property(nonatomic, assign)BOOL disableEncrypted;  // 禁用加密

@property(nonatomic, copy)NSString *serverID;
@property(nonatomic, copy)NSString *ownerID;

@property(nonatomic, copy)NSURL *saveFilePathDirectory; // 存储文件路径


@property (nonatomic, assign)NSInteger sourceType; // 来源类型 0=协同, 1=uc
@end
