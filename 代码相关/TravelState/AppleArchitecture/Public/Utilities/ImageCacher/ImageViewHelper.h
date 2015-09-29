//
//  ImageViewHelper.h
//  TestImageCache
//
//  Created by klbest1 on 13-12-10.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface   UIImageView (ImageViewHelper)

-(void)setImageWithURL:(NSURL *)aURL PlaceHolder:(UIImage *)aPlaceHolder;
//是否进行压缩
-(void)setIsCacheWithRepesentationRation:(BOOL)aIsCachePresentation;
//是否进行缓存
-(void)setIsDontNeedCache:(BOOL)aIsDontCahce;
//移除某图片缓存
-(void)removeImageWithURLStr:(NSString *)aURLStr;
@end
