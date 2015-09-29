//
//  SKLvTuStateOb.m
//  BaseFrameWork
//
//  Created by lin on 15/5/27.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKLvTuStateOb.h"
@implementation SKLvTuStateOb

-(void)dealloc{
    SK_RELEASE_SAFELY(_userId);
    SK_RELEASE_SAFELY(_provinceId);
    SK_RELEASE_SAFELY(_cityId);
    SK_RELEASE_SAFELY(_districtId);
    SK_RELEASE_SAFELY(_type);
    SK_RELEASE_SAFELY(_pageIndex);
    SK_RELEASE_SAFELY(_pageSize);
    [super dealloc];
}

//- (NSDictionary *)proxyForJson {
//    return [NSDictionary dictionaryWithObjectsAndKeys:
//            _userId?_userId:@"",@"userId",
//            _provinceId?_provinceId:@"", @"provinceId",
//            _cityId?_cityId:@"", @"cityId",
//            _districtId?_districtId :@"", @"districtId",
//            _type?_type:@"",@"type",
//            _pageIndex?_pageIndex:@"",@"pageIndex",
//            _pageSize?_pageSize:@"",@"pageSize",
//            nil];
//    
//}
@end
