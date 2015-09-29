//
//  SKDownLoadResponce.h
//  BaseFrameWork
//
//  Created by lin on 15/5/26.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseResponse.h"

@interface SKDownLoadResponse : SKBaseResponse

@property (nonatomic,retain) NSString *filePath;
@property (nonatomic,retain) NSString *fileSize;

@end
