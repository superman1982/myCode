//
//  InsuranceInfo.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-5.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceInfo : NSObject

@property (nonatomic,retain)  NSString *insuranceId;

@property (nonatomic,retain) NSString *policyNumber;

@property (nonatomic,retain) NSString *insuranceCompany;

@property (nonatomic,retain) NSString *reportPhone;

@property (nonatomic,retain) NSString *insuranceArea;

@property (nonatomic,retain) NSString *effectiveDate;

@property (nonatomic,retain) NSString *expirationDate;

@property (nonatomic,retain) NSMutableArray *policyImg;

@property (nonatomic,retain) NSNumber *isAudit;

@end
