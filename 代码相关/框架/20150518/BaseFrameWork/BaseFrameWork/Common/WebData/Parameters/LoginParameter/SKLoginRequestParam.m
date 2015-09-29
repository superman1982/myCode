//
//  SkLoginRequestParam.m
//  BaseFrameWork
//
//  Created by lin on 15-1-7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKLoginRequestParam.h"

@implementation SKLoginRequestParam

-(id)initWithLoginOb:(SKLoginOb *)aOb{
    self = [super init];
    if(self){
        self.managerMethod = @"transLogin";
        self.managerName = @"mLoginManager";
        [self addObToParameter:aOb];
    }
    return self;
}
@end
