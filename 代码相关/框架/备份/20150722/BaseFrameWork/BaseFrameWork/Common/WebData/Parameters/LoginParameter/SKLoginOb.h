//
//  SkLogoinParam.h
//  BaseFrameWork
//
//  Created by lin on 15-1-7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKLoginOb : NSObject

@property(nonatomic, copy)NSString        *username;
@property(nonatomic, copy)NSString        *password;
@property(nonatomic, assign)NSInteger        loginType;
@property(nonatomic, copy)NSString        *verifyCode;
@property(nonatomic, copy)NSString        *deviceCode;
@property(nonatomic, copy)NSString        *local;
@property(nonatomic, copy)NSString        *timezone;
@property(nonatomic, copy)NSString        *token;
@property(nonatomic, copy)NSString        *protocolType;
@property(nonatomic, copy)NSString        *clientVersion;
@property(nonatomic, retain)NSDictionary        *extAttrs;

@end
