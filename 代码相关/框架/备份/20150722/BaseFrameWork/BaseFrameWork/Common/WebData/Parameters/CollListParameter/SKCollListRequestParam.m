//
//  SKCollListRequestParam.m
//  BaseFrameWork
//
//  Created by lin on 15/5/19.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKCollListRequestParam.h"

@implementation SKCollListRequestParam
-(id)initWithSKCollListOb:(SKCollListOb *)aParameter{
    self = [super init];
    if(self){
        self.managerMethod = @"loadMoreColList";
        self.managerName = @"mCollaborationManager";
        [self addIntergerValue:aParameter.affairState];
        [self addLongLongValue:aParameter.lastID];
        [self addIntergerValue:aParameter.startIndex];
        [self addIntergerValue:aParameter.size];
    }
    return self;
}
@end
