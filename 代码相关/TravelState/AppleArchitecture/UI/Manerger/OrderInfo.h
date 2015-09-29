//
//  OrderInfo.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

// 订单状态
typedef enum {
    otCancle = 0,           // 订单取消
    otDealing,         // 订单正在处理
    otConfirm,      // 订单确认
    otPayed,        // 订单已付款
    otCommented,   //订单已评价
    otNotCommented, //订单未评价
} OrderState;

@interface OrderInfo : NSObject
@property (nonatomic,retain) NSString *businessId;

@property (nonatomic,retain) NSString *businessPhoto;

@property (nonatomic,retain) NSString *businessName;

@property (nonatomic,retain) NSString *orderId;

@property (nonatomic,retain) NSNumber *orderType;

@property (nonatomic,retain) NSNumber *totalServices;

@property (nonatomic,retain) NSNumber *totalprice;

@property (nonatomic,retain) NSNumber *totalreturnMoney;

@property (nonatomic,retain) NSString *orderTime;

@property (nonatomic,retain) NSString *exchangeTime;

@property (nonatomic,assign) OrderState orderState;

@property (nonatomic,retain) NSNumber *isEvaluate;

@property (nonatomic,retain) NSString *userComment;

@property (nonatomic,retain) NSString *sellerComment;

//services
@property (nonatomic,retain) NSString *serviceName;

@property (nonatomic,retain) NSString *serviceDesc;

@property (nonatomic,retain) NSNumber *orderCount;

@property (nonatomic,retain) NSString *servicePhtoto;

@property (nonatomic,retain) NSNumber *price;

@property (nonatomic,retain) NSNumber *vipPrice;

@property (nonatomic,retain) NSNumber *returnMoney;

//--

@property (nonatomic,assign) BOOL isShowedOtherItem;
@end
