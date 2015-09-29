//
//  PurchaseCarInfo.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-23.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseCarInfo : NSObject

@property (nonatomic,retain) NSString *businessId;
@property (nonatomic,retain) NSString *businessPhoto;
@property (nonatomic,retain) NSString *businessName;
@property (nonatomic,retain) NSNumber *serviceType;
@property (nonatomic,retain) NSNumber *standardServiceType;
@property (nonatomic,retain) NSString *serviceId;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *photo;
@property (nonatomic,retain) NSNumber *count;
@property (nonatomic,retain) NSNumber *price;
@property (nonatomic,retain) NSNumber *vipPrice;
@property (nonatomic,retain) NSNumber *returnMoney;
@property (nonatomic,assign) BOOL   isChecked;
@end
