//
//  UserInfo.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-4.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(void)setIdImgs:(NSMutableArray *)idImgs{
    if (_idImgs == nil) {
        _idImgs = [[NSMutableArray alloc] init];
    }
    
    [_idImgs removeAllObjects];
    [_idImgs addObjectsFromArray:idImgs];
}

-(void)setMemberCard:(NSMutableArray *)memberCard{
    if (_memberCard == Nil) {
        _memberCard = [[NSMutableArray alloc] init];
    }
    [_memberCard removeAllObjects];
    [_memberCard addObjectsFromArray:memberCard];
}
#if __has_feature(objc_arc)
#else
-(void)dealloc{
    [_memberCard removeAllObjects],[_memberCard release];
    [_idImgs removeAllObjects],[_idImgs release];
    [super dealloc];
}
#endif
@end
