//
//  SKImageView.m
//  BaseFrameWork
//
//  Created by lin on 15/5/26.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKImageView.h"

@implementation SKImageView

-(void)dealloc{
    [_uuID release],_uuID = nil;
    [super dealloc];
}
@end
