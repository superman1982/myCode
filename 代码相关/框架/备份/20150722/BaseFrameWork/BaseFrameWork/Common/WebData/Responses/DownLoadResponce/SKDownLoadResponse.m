//
//  SKDownLoadResponce.m
//  BaseFrameWork
//
//  Created by lin on 15/5/26.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKDownLoadResponse.h"

@implementation SKDownLoadResponse

-(void)dealloc{
    [_filePath release],_filePath = nil;
    [super dealloc];
}
@end
