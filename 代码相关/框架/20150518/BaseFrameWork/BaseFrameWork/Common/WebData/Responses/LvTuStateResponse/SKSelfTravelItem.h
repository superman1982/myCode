//
//  SKSelfTravelItem.h
//  BaseFrameWork
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseObject.h"

@interface SKSelfTravelItem : SKBaseObject

@property (nonatomic,retain) NSNumber *activityId;

@property (nonatomic,retain) NSNumber *type;

@property (nonatomic,retain) NSNumber *isOfficial;

@property (nonatomic,retain) NSNumber *shareCount;

@property (nonatomic,retain) NSNumber *praiseCount;

@property (nonatomic,retain) NSNumber *commentCount;

@property (nonatomic,retain) NSString *activityTitle;

@property (nonatomic,retain) NSString *activityImage;

@property (nonatomic,retain) NSString *activityURL;

@property (nonatomic,retain) NSString *activityTime;

@property (nonatomic,retain) NSString *signupEndDate;

@property (nonatomic,retain) NSNumber *listingPrice;

@property (nonatomic,retain) NSNumber *price;

@property (nonatomic,retain) NSNumber *returnMoney;

@property (nonatomic,retain) NSNumber *signupNumber;

@property (nonatomic,retain) NSString *roadBookUrl;

@property (nonatomic,retain) NSNumber *isSignup;

@property (nonatomic,retain) NSNumber *leaderPhone;

@property (nonatomic,retain) NSNumber *isIncludeSelf;

@property (nonatomic,retain) NSNumber *totalSignup;

@property (nonatomic,retain) NSNumber *allowNoMember;

@property (nonatomic,retain) NSNumber *lodgingMoney;

@property (nonatomic,retain) NSNumber *insuranceMoney;

@property (nonatomic,retain) NSNumber *isIncludeInsurance;

@property (nonatomic,retain) NSString *roadBookModifyTime;

@end
