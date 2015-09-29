//
//  KzPhoto.m
//  测试ShowPhoto
//
//  Created by lin on 14-10-10.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "KzPhoto.h"

@implementation KzPhoto

-(void)dealloc{
    [_bigImageURLStr release];
    [_smallImageURLStr release];
    [super dealloc];
}
@end
