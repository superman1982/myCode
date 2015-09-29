//
//  SkBaseRequstParam.h
//  BaseFrameWork
//
//  Created by lin on 15-1-7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseObject.h"

@interface SKBaseRequstParam : NSObject
{
     NSString   *_requestURLStr;
}
@property (nonatomic,retain) NSString   *requestURLStr;
@property (nonatomic, copy) NSString    *managerName;
@property (nonatomic, copy) NSString    *managerMethod;

@property (nonatomic,retain) NSDictionary *requestDic;

-(void)addIntergerValue:(NSInteger) aValue;
-(void)addLongLongValue:(long long) aValue;
-(void)addObToParameter:(id)aOb;
-(void)addObAsDicParameter:(id)aOb;
@end
