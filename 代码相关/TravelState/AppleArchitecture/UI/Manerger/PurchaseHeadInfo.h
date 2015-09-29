//
//  PurchaseHeadInfo.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-3.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseHeadInfo : NSObject

@property (nonatomic,retain) NSString *bunessName;

@property (nonatomic,retain) NSNumber *summPriceMoney;

@property (nonatomic,retain) NSNumber *summVipPriceMoney;
@property (nonatomic,retain) NSNumber *serviceType;
@property (nonatomic,retain) NSNumber *summReturnMoney;

@property (nonatomic,assign) BOOL isCheck;

@end
