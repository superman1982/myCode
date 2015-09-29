//
//  SkBaseResponse.m
//  BaseFrameWork
//
//  Created by lin on 15-1-7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseResponse.h"
#import "NSObject+AutoMagicCoding.h"

// 一个字典，相当于一个对象，键值相当于属性，类名要在ClassType中指名

@implementation SKBaseResponse

-(void)setResult:(NSDictionary *)result{
    if (result == nil) {
        return;
    }
    if (_result == nil) {
        NSString *vClassName = NSStringFromClass([self class]);
        NSString *vReallClassName = [vClassName stringByReplacingOccurrencesOfString:@"Response" withString:@"Result"];
        id vClass =  NSClassFromString(vReallClassName);
        if (vClassName !=nil) {
            _result = [[vClass alloc] initWithDictionaryRepresentation:result];
        }
    }
}
@end
