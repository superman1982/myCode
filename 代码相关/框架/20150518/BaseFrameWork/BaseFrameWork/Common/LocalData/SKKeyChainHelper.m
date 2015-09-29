//
//  KeyChainHelper.m
//  BaseFrameWork
//
//  Created by lin on 15-1-5.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKKeyChainHelper.h"
#include <Security/Security.h>

static NSString *serviceName = @"com.mycompany.myAppserviceName";

@implementation SKKeyChainHelper
 + (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
     NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(id)kSecAttrService];
    return [searchDictionary autorelease];
}

+ (NSData *)searchKeychainCopyMatching{
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:serviceName];
    
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    NSData *result = nil;
    SecItemCopyMatching((CFDictionaryRef )searchDictionary, (CFTypeRef *) &result);
    
    return result;
}

+ (BOOL)createKeychainValue:(NSData *)saveData {
    NSMutableDictionary *dic = [self newSearchDictionary:serviceName];
    [dic setObject:saveData forKey:(id)kSecValueData];
    
    OSStatus staus = SecItemAdd((CFDictionaryRef )dic, NULL);
    if (staus == errSecSuccess) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)updateKeychainValue:(NSData *)updateData {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:serviceName];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    [updateDictionary setObject:updateData forKey:(id)kSecValueData];
    
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,(CFDictionaryRef) updateDictionary);
    [updateDictionary release];
    if (status == errSecSuccess) {
        return YES;
    }
    
    return NO;
}

+ (void)deleteKeyChainValue:(NSString *)identify{
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:serviceName];
    SecItemDelete((CFDictionaryRef) searchDictionary);
}
@end
