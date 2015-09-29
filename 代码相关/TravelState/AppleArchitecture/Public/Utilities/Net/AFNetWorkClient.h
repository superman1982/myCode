//
//  AFNetWorkClient.h
//  TestAFnetworkAndTableCell
//
//  Created by klbest1 on 13-10-10.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
@interface AFNetWorkClient : AFHTTPClient

+ (AFNetWorkClient *)sharedClient;

@end
