//
//  ElectronicSiteInfo.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-3.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ElectronicSiteInfo : NSObject
//保留字段
@property (nonatomic,assign) ActiveType routesType;

@property (nonatomic,retain) id dayname;

@property (nonatomic,retain) id realDate;

@property (nonatomic,retain) id siteId;

@property (nonatomic,retain) id name;

@property (nonatomic,retain) id siteNo;

@property (nonatomic,retain) id roadBookType;

@property (nonatomic,retain) id markType;

@property (nonatomic,retain) id arrivalTime;

@property (nonatomic,retain) id gatherTime;

@property (nonatomic,retain) id stayTime;

@property (nonatomic,retain) NSString *backgroundImageUrl;

@property (nonatomic,retain) id description;

@property (nonatomic,retain) NSNumber *latitude;

@property (nonatomic,retain) NSNumber *longitude;

@property (nonatomic,retain) id viewpointLevel;

@property (nonatomic,retain) NSString *detailFilePath;

@property (nonatomic,retain) id activityId;
@end
