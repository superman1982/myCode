//
//  SKWebViewBO.h
//  Seework
//
//  Created by lin on 15/7/2.
//  Copyright (c) 2015年 seeyon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SK_UserContactDirector     @"Directory"
#define SK_UsersContactsFileName   @"appUsers"
@class IATHelper;

@interface SKWebViewBO : NSObject

@property (nonatomic,assign) UIViewController  *webViewController;

+(NSString *)createPathInDocumentDirectory:(NSString *)aFileName;

-(void)dealFetchQueueWithArray:(NSArray *)aArray webView:(UIWebView *)aWebView;
@end
