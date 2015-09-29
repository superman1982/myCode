//
//  SkLocalSetting.h
//  BaseFrameWork
//
//  Created by lin on 14-12-30.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "SKBaseObject.h"

@interface SKLocalSetting : SKBaseObject

//用户名
@property (nonatomic,copy) NSString *loginName;
//密码
@property (nonatomic,copy) NSString *loginPassword;
//是否自动登录
@property (nonatomic,assign) BOOL  isAutoLogin;
//是否注销程序
@property (nonatomic,assign) BOOL  isLogOut;
//是否显示欢迎页
@property (nonatomic,assign) BOOL  needShowWelcomePages;
//是否首次安装
@property (nonatomic,assign) BOOL  isInstalledApplicaiton;

@property (nonatomic,retain) NSString *preLoginName;
@property (nonatomic,retain) NSString *domain;
@property (nonatomic,retain) NSString *port;
@property (nonatomic,assign) BOOL     isSSLEnable;
@property (nonatomic,retain) NSString *domainSSL;
@property (nonatomic,retain) NSString *portSSL;
@property (nonatomic,retain) NSString *verifyCode;

@property (nonatomic,assign) BOOL  isRememberPassWord;
@property (nonatomic,assign) BOOL hasVerifyCode;

@property (nonatomic,retain)  NSString *concurrentNumber;
@property (nonatomic,retain)  NSString *companyName;
@property (nonatomic,retain)  NSString *producVersion;
@property (nonatomic,retain)  NSString *productTags;
@property (nonatomic,retain)  NSString *serverIdentifier;
@property (nonatomic,assign)  NSInteger proFileType;
@property (nonatomic,retain)  NSString *serverVersion;

@property (nonatomic,retain) NSString *userMainCompanyID;
@property (nonatomic,retain) NSString *userCurrentCompanyID;

@property (nonatomic,retain) NSDictionary *loginExtAttrs;
@property (nonatomic,copy)   NSString    *fromurl;
@property (nonatomic,assign) NSInteger   connectType;

+(SKLocalSetting *)instanceSkLocalSetting;
+(NSDictionary *)getDicInKeyChian;
+(void)saveSetting;
@end
