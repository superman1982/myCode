//
//  SkLogoinParam.m
//  BaseFrameWork
//
//  Created by lin on 15-1-7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKLoginOb.h"

@implementation SKLoginOb

- (void)dealloc
{
    [_username release];
    [_password release];
    [_deviceCode release];
    [_protocolType release];
    [_extAttrs release];
    
    [super dealloc];
}
@end
