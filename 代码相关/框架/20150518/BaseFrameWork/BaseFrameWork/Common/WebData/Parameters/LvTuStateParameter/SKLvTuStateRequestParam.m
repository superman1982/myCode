//
//  SKLvTuStateParameter.m
//  BaseFrameWork
//
//  Created by lin on 15/5/27.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKLvTuStateRequestParam.h"

#define NEWABOSULUTEPATH @"http://www.hnqlhr.com"

#define APPURL401 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/listActivity"]

@implementation SKLvTuStateRequestParam

-(id)initWithLoginOb:(SKLvTuStateOb *)aOb{
    self = [super init];
    if(self){
        aOb.classType = @"SKLvTuStateOb";
        self.requestURLStr = APPURL401;
        [self addObAsDicParameter:aOb];
    }
    return self;
}
@end
