//
//  SkLogindata.h
//  BaseFrameWork
//
//  Created by lin on 15-1-6.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseRequstParam.h"
#import "SKBaseResponse.h"

@class SKBaseWebRequest;
@protocol SkBaseWebRequestDelegate <NSObject>

-(void)didStartLoadData:(id)sender;
-(void)didLoadDataSucess:(SKBaseResponse *)aReponse WithRequest:(SKBaseWebRequest *)aRequest;
-(void)didLoadDataFailure:(id)sender Error:(NSError *)aError;
@end

@interface SKBaseWebRequest : NSObject

@property (nonatomic,retain) SKBaseRequstParam *param;
@property (nonatomic,assign) id<SkBaseWebRequestDelegate> delegate;
@property (nonatomic,retain) NSOperation    *requestOperation;

-(void)requestData;

-(void)dealFailure:(id)responseObject Error:(NSError *)error;

-(void)dealSuccess:(id)reponseObjct Error:(NSError *)error;

@end
