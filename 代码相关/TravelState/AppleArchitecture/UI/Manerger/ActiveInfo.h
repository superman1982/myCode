//
//  ActiveInfo.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-28.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveInfo : NSObject

@property (nonatomic,retain) NSNumber *ActivityId;

@property (nonatomic,assign) ActiveType type;

@property (nonatomic,retain) NSNumber *isOfficial;

@property (nonatomic,retain) NSNumber *shareCount;

@property (nonatomic,retain) NSNumber *praiseCount;

@property (nonatomic,retain) NSNumber *comentCount;

@property (nonatomic,retain) NSString *activeTitle;

@property (nonatomic,retain) NSString *activeImages;

@property (nonatomic,retain) NSString *activityURL;

@property (nonatomic,retain) NSString *activeTime;

@property (nonatomic,retain) NSString *signupEndDate;

@property (nonatomic,retain) NSNumber *listingPrice;

@property (nonatomic,retain) NSNumber *memberPrice;

@property (nonatomic,retain) NSNumber *returnMoney;

@property (nonatomic,retain) NSNumber *singupNumber;

@property (nonatomic,retain) NSString *rouadBookURL;

@property (nonatomic,retain) NSNumber *isSignup;

@property (nonatomic,retain) NSNumber *leaderPhone;

@property (nonatomic,retain) NSNumber *isIncludeSelf;

@property (nonatomic,retain) NSNumber *totalSignup;

@property (nonatomic,retain) NSNumber *allowNoMember;

@property (nonatomic,retain) NSNumber *lodingMoney;

@property (nonatomic,retain) NSNumber *insuranceMone;

@property (nonatomic,retain) NSNumber *isIncludeInsurance;

@property (nonatomic,retain) NSString *roadBookModifyTime;

@end
