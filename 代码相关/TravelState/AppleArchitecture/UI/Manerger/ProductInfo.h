//
//  ProductInfo.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfo : NSObject
//价格
@property (nonatomic, assign) float price;
//产品名字
@property (nonatomic, retain) NSString *subject;
//描述
@property (nonatomic, retain) NSString *body;
//订单ID
@property (nonatomic, retain) NSString *orderId;

@property (nonatomic,retain)  id userID;

@end
