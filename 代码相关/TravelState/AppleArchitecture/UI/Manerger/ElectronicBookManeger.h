//
//  ElectronicBookManeger.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAINHTMLKEY  @"mainactivity"
#define ROUTEDICKEY  @"routedic"
#define UNZIPFILEPATHKEY @"unzipfilepath"
#define VERSIONKEY   @"version"
#define SITEHTMLKEY  @"site"
#define MODIFYDATE   @"modifyDate"

@interface ElectronicBookManeger : NSObject

+ (void)downLoadElectroniBook:(NSString *)aURLStr IsSynchronous:(BOOL)aIsSync ModifyTime:(NSString *)aTimeStr;

+ (NSDictionary *)getElectronicBookInfo:(NSString *)aURLStr;
@end
