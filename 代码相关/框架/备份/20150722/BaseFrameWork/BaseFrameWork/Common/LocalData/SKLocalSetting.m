//
//  SkLocalSetting.m
//  BaseFrameWork
//
//  Created by lin on 14-12-30.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "SKLocalSetting.h"
#import "UIDevice-Hardware.h"
#import "SKKeyChainHelper.h"

#define Local_SettingKey  @"localSettingKey"

static SKLocalSetting  *shareLocalSeting = nil;

@implementation SKLocalSetting

+(SKLocalSetting *)instanceSkLocalSetting{
    //保证此时没有其它线程对self对象进行修改
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void){
        shareLocalSeting = [[SKLocalSetting alloc] init];
    });
    return shareLocalSeting;
}

-(id)init{
    NSData *vData = [SKLocalSetting getLocalData];
    if (vData != nil) {
        NSDictionary *vDic = [NSKeyedUnarchiver unarchiveObjectWithData:vData];
        self = [self initWithDictionaryRepresentation:vDic];
    }else{
        self = [super init];
    }
    if (self) {
    }
    return self;
}

- (id) retain
{
    return self;
}

- (oneway void) release
{
    // Does nothing here.
}

- (id) autorelease
{
    return self;
}

- (NSUInteger) retainCount
{
    return INT32_MAX;
}
//--------end--------

-(void)setNeedShowWelcomePages:(BOOL)needShowWelcomePages{
    _needShowWelcomePages = needShowWelcomePages;
}
+(NSData *)getLocalData{
    NSData *vData = [SKKeyChainHelper searchKeychainCopyMatching];
    return vData;
}

+(void)saveSetting{
    NSDictionary *vDic = [[SKLocalSetting instanceSkLocalSetting] dictionaryRepresentation];
    NSData *vData = [NSKeyedArchiver archivedDataWithRootObject:vDic];
    [SKKeyChainHelper updateKeychainValue:vData];
}

@end
