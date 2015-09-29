//
//  SKCollListResult.m
//  BaseFrameWork
//
//  Created by lin on 15/5/19.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKCollListResult.h"

@implementation SKCollListResult
-(void)dealloc{
    [_dataList release],_dataList = nil;
    [_extend release],_extend = nil;
    [super dealloc];
}
@end
