//
//  KeyChainHelper.h
//  BaseFrameWork
//
//  Created by lin on 15-1-5.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKKeyChainHelper : NSObject

+ (NSData *)searchKeychainCopyMatching;
+ (BOOL)createKeychainValue:(NSData *)saveData ;
+ (BOOL)updateKeychainValue:(NSData *)updateData;
@end
