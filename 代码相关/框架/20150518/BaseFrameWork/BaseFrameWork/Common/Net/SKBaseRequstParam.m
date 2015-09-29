//
//  SkBaseRequstParam.m
//  BaseFrameWork
//
//  Created by lin on 15-1-7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseRequstParam.h"
#import "NSObject+JSON.h"

@interface SKBaseRequstParam()
{
    NSMutableArray *parameters;
}
@end

@implementation SKBaseRequstParam
@synthesize requestURLStr = _requestURLStr;

-(void)dealloc{
    [_requestURLStr release],_requestURLStr = nil;
    [parameters removeAllObjects];
    [parameters release];
    parameters = nil;
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if(self){
        parameters = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addIntergerValue:(NSInteger) aValue{
    NSNumber *vNumber = [NSNumber numberWithUnsignedInteger:aValue];
    [parameters addObject:vNumber];
}

-(void)addLongLongValue:(long long) aValue{
    NSNumber *vNumber = [NSNumber numberWithLongLong:aValue];
    [parameters addObject:vNumber];
}

-(void)addObToParameter:(id)aOb{
    if(aOb == nil){
        return;
    }
    [parameters addObject:aOb];
}

-(void)addObAsDicParameter:(id)aOb{
    NSDictionary *vDic = [aOb proxyForJson];
    self.requestDic = vDic;
}

-(NSDictionary *)requestDic{
    NSString *vJsonStr = @"";
    if (_requestDic == nil) {
        
        if(parameters.count > 0){
            vJsonStr = [parameters JSONRepresentation];
        }
        NSDictionary *vDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              _managerMethod,@"managerMethod",
                              _managerName,@"managerName",
                              vJsonStr,@"arguments",nil];
        return vDic;
    }
    
    return _requestDic;
}
@end
