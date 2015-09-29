//
//  SKLvTuStateRequest.m
//  BaseFrameWork
//
//  Created by lin on 15/5/27.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKLvTuStateRequest.h"
#import "SKNetManager.h"

@implementation SKLvTuStateRequest

-(void)requestData{
    if ([self.delegate respondsToSelector:@selector(didStartLoadData:)]) {
        [self.delegate didStartLoadData:self];
    }
   self.requestOperation = [SKNetManager postURLJsonData:self.param.requestURLStr Parameter:self.param.requestDic Success:^(id responseObject, NSError *error) {
        [self dealSuccess:responseObject Error:error];
    } Failure:^(id responseObject, NSError *error) {
        [self dealFailure:responseObject Error:error];
    }];
}

-(void)dealSuccess:(id)reponseObjct Error:(NSError *)error{
    if (reponseObjct == nil) {
        return;
    }

    NSDictionary *vReponseDic = [NSJSONSerialization JSONObjectWithData:reponseObjct options:kNilOptions error:nil];
    //处理下json直接转换
    NSMutableDictionary *vResponseMutableDic = [NSMutableDictionary dictionary];
    [vResponseMutableDic setObject:@"SKLvTuStateResult" forKey:@"classType"];
    
    NSMutableDictionary *vDataDic = [NSMutableDictionary dictionary];
    [vDataDic setObject:@"SKDataContent" forKey:@"classType"];
    
    NSArray *vNormalArray = [[vReponseDic objectForKey:@"data"] objectForKey:@"normal"];
    NSMutableArray *dealedNormalArray = [NSMutableArray array];
    for (NSDictionary *dic in vNormalArray) {
        NSMutableDictionary *vDic = [[dic mutableCopy] autorelease];
        [vDic setObject:@"SKSelfTravelItem" forKey:@"classType"];
        [dealedNormalArray addObject:vDic];
    }
    [vDataDic setObject:dealedNormalArray forKey:@"normal"];
    
    NSArray *vTopArray = [[vReponseDic objectForKey:@"data"] objectForKey:@"top"];
    NSMutableArray *dealedTopArray = [NSMutableArray array];
    for (NSDictionary *dic in vTopArray) {
        NSMutableDictionary *vDic = [[dic mutableCopy] autorelease];
        [vDic setObject:@"SKSelfTravelItem" forKey:@"classType"];
        [dealedTopArray addObject:vDic];
    }
    [vDataDic setObject:dealedTopArray forKey:@"top"];
    
    [vResponseMutableDic setObject:vDataDic forKey:@"data"];
    NSLog(@"vResponseMutableDic:%@",vResponseMutableDic);
    
    //字典转为相应接口对象
    NSString *vClassName = [self.param className];
    vClassName  = [vClassName stringByReplacingOccurrencesOfString:@"RequestParam" withString:@"Response"];
    Class responseClass = NSClassFromString(vClassName);
    
    SKBaseResponse *vResponce = [[[responseClass alloc] init] autorelease];
    [vResponce setResult:vResponseMutableDic];
    NSString *vStateMessage = [vReponseDic objectForKey:@"stateMessage"];
    NSLog(@"vStateMessage:%@",vStateMessage);
    //end
    
    if ([self.delegate respondsToSelector:@selector(didLoadDataSucess:WithRequest:)]) {
        [self.delegate didLoadDataSucess:vResponce WithRequest:self];
    }
}
@end
