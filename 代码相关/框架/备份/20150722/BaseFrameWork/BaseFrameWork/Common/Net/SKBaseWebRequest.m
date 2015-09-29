//
//  SkLogindata.m
//  BaseFrameWork
//
//  Created by lin on 15-1-6.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseWebRequest.h"
#import "SKNetManager.h"
#import "SkDataUtil.h"

@implementation SKBaseWebRequest

-(void)dealloc{
    [_param release];
    [super dealloc];
}

-(void)requestData{
    if ([_delegate respondsToSelector:@selector(didStartLoadData:)]) {
        [_delegate didStartLoadData:self];
    }
    _requestOperation = [SKNetManager postURLData:@"http://211.157.139.215:9999/seeyon/servlet/SeeyonMobileBrokerServlet?serviceProcess=A6A8_Common&responseCompress=gzip" Parameter:self.param.requestDic Success:^(id responseObject, NSError *error) {
        [self dealSuccess:responseObject Error:error];
    } Failure:^(id responseObject, NSError *error) {
        [self dealFailure:responseObject Error:error];
    }];
}

#pragma mark  处理一般网络请求数据
-(void)dealSuccess:(id)reponseObjct Error:(NSError *)error{
    if (reponseObjct == nil) {
        return;
    }
    //解压数据
    NSString *vDataStr = [[[NSString alloc] initWithData:reponseObjct encoding:NSUTF8StringEncoding] autorelease];
    NSData *vData = [vDataStr dataUsingEncoding:NSISOLatin1StringEncoding];
    if (vData == nil) {
        return;
    }
    NSData *vDecompressData = [SkDataUtil uncompressZippedData:(NSMutableData *)vData];
    //end
    
    NSDictionary *vReponseDic = [NSJSONSerialization JSONObjectWithData:vDecompressData options:kNilOptions error:nil];
    NSLog(@"vReponseDic:%@",vReponseDic);

    //end
    
    //字典转为相应接口对象
    NSString *vClassName = [self.param className];
    vClassName  = [vClassName stringByReplacingOccurrencesOfString:@"RequestParam" withString:@"Response"];
    Class responseClass = NSClassFromString(vClassName);
    
    SKBaseResponse *vResponce = [[[responseClass alloc] init] autorelease];
    [vResponce setResult:vReponseDic];
    //end
    
    if ([_delegate respondsToSelector:@selector(didLoadDataSucess:WithRequest:)]) {
        [_delegate didLoadDataSucess:vResponce WithRequest:self];
    }
}

-(void)dealFailure:(id)responseObject Error:(NSError *)error{
    if (error != nil) {
        [self dealError:error];
    }
    NSString *reponseObjceStr = [error.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
    NSData *vData = [reponseObjceStr dataUsingEncoding:NSISOLatin1StringEncoding];
    if (vData == nil) {
        return;
    }
    NSData *vDecompressData = [SkDataUtil uncompressZippedData:(NSMutableData *)vData];
    
    NSDictionary *vErrorDic = [NSJSONSerialization JSONObjectWithData:vDecompressData options:kNilOptions error:nil];

    NSLog(@"errorDic:%@",vErrorDic);
    NSError *vError = nil;
    if (vErrorDic.count > 0) {
        NSString *vErrorMessage = [vErrorDic objectForKey:@"message"];
        vErrorMessage = [self stringFromHtmlStr:vErrorMessage];
        
        vError = [NSError errorWithDomain:vErrorMessage code:[[vErrorDic objectForKey:@"code"] integerValue] userInfo:nil];
    }
    
    if ([_delegate respondsToSelector:@selector(didLoadDataFailure:Error:)]) {
        [_delegate didLoadDataFailure:responseObject Error:vError];
    }
}


-(void)dealError:(NSError *)aError{
    NSInteger vErrorCode = aError.code;
    NSString *vErrorMessage = [aError localizedDescription];
    switch (vErrorCode) {
        case 1004:
            
            break;
            
        default:
            break;
    }
    
    UIAlertView *vAlert = [[UIAlertView alloc] initWithTitle:@"注意" message:vErrorMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [vAlert show];
    [vAlert release];
}

- (NSString *)stringFromHtmlStr:(NSString *)str
{
    if (!str) {
        return nil;
    }
    NSMutableString *htmlStr = [[NSMutableString alloc] initWithString:str];
    [htmlStr replaceOccurrencesOfString:@"<br/>" withString:@"\n"
                                options:NSBackwardsSearch range:NSMakeRange(0, [htmlStr length])];
    [htmlStr replaceOccurrencesOfString:@"<br>" withString:@"\n"
                                options:NSBackwardsSearch range:NSMakeRange(0, [htmlStr length])];
    return [htmlStr autorelease];
}


@end
