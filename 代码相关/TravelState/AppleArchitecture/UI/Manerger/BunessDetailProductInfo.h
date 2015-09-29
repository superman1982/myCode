//
//  BunessDetailProductInfo.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-17.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BunessDetailProductInfo : NSObject

@property (nonatomic,retain) id businessId;

@property (nonatomic,retain) NSNumber *serviceType;

@property (nonatomic,retain) NSNumber *standardServiceType;

@property (nonatomic,retain) NSString *serviceId;

@property (nonatomic,retain) NSString *servicePhoto;

@property (nonatomic,retain) NSString *serviceName;

@property (nonatomic,retain) NSString *serviceDesc;

@property (nonatomic,retain) NSNumber *price;

@property (nonatomic,retain) NSNumber *vipPrice;

@property (nonatomic,retain) NSNumber *returnMoney;

@property (nonatomic,retain) NSNumber *isDiscount;

@property (nonatomic,retain) NSString *beginDateTime;

@property (nonatomic,retain) NSString *endDateTime;

@property (nonatomic,retain) NSNumber *orderNumber;

@end
