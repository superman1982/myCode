//
//  BaiDuNaviManeger.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNCoreServices.h"
#import <CoreLocation/CoreLocation.h>


@interface BaiDuNaviManeger : NSObject<BNNaviRoutePlanDelegate, BNNaviUIManagerDelegate>

- (void)startNavi:(CLLocationCoordinate2D )aStart EndLocation:(CLLocationCoordinate2D)aEnd;

@end
