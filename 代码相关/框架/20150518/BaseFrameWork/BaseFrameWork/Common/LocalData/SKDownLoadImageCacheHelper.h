//
//  SKDownLoadImageCacheHelper.h
//  BaseFrameWork
//
//  Created by lin on 15/5/20.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SKImageView.h"


@interface SKDownLoadImageCacheHelper : NSObject

+ (SKDownLoadImageCacheHelper *) helper;

+(void)destroyHelper;

-(void)downloadWithUUID:(NSString *)aUniqueId
              container:(SKImageView *)aImageView;

-(void)downloadWithUUID:(NSString *)aUniqueId
             createDate:(NSString *)aCreateTime
         lastModifyDate:(NSString *)aLastModifyDate
           downloadType:(NSInteger)aIconType
              container:(SKImageView *)aImageView
       serverIdentifier:(NSString *)aServerId
              onlyCache:(BOOL)aOnlyCache;
@end
