//
//  InsuranceInfo.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-5.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "InsuranceInfo.h"

@implementation InsuranceInfo

-(void)setPolicyImg:(NSMutableArray *)policyImg{
    if (_policyImg == Nil) {
        _policyImg = [[NSMutableArray alloc] init];
    }
    [_policyImg addObjectsFromArray:policyImg];
}


#if __has_feature(objc_arc)
#else
-(void)dealloc{
    [_policyImg removeAllObjects],[_policyImg release];
    [super dealloc];
}
#endif
@end
