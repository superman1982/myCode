//
//  SKBaseDownLoadRequest.h
//  BaseFrameWork
//
//  Created by lin on 15/5/22.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseRequstParam.h"
#import "SKBaseResponse.h"

@class SKBaseDownLoadRequest;
@protocol SKBaseWebRequestDownLoadFileDelegate <NSObject>

-(void)didStartDownLoadFile:(id)sender;
-(void)didDownLoadFileSucess:(SKBaseResponse *)aReponse WithRequest:(SKBaseDownLoadRequest *)aRequest;
-(void)didDownLoadFileFailure:(id)sender Error:(NSError *)aError;

@end
@interface SKBaseDownLoadRequest : NSObject

@property (nonatomic,retain) SKBaseRequstParam *param;
@property (nonatomic,assign) id<SKBaseWebRequestDownLoadFileDelegate> downLoadFileDelegate;

-(void)downLoadData;
@end
