//
//  SKDownLoadExtendParameter.m
//  BaseFrameWork
//
//  Created by lin on 15/5/26.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKDownLoadExtendParam.h"

@implementation SKDownLoadExtendParam
@synthesize isNeedDeleteDataBase = _isNeedDeleteDataBase;

-(NSMutableArray *)imageViewArray{
    if (_imageViewArray == nil) {
        _imageViewArray = [[NSMutableArray alloc] init];
    }
    return _imageViewArray;
}

-(void)dealloc{
    [_downLoadFilePath release],_downLoadFilePath = nil;
    [_imageViewArray removeAllObjects],_imageViewArray = nil;
    [super dealloc];
}
@end
