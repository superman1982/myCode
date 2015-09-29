//
//  ImageViewHelper.m
//  TestImageCache
//
//  Created by klbest1 on 13-12-10.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import "ImageViewHelper.h"
#import "ImageCacher.h"

@implementation UIImageView (ImageViewHelper)

-(void)setImageWithURL:(NSURL *)aURL PlaceHolder:(UIImage *)aPlaceHolder{

    if ([ImageCacher hasCachedImage:aURL]) {
        [self setImage:[UIImage imageWithContentsOfFile:[ImageCacher pathForURL:aURL]]];
    }else{
        [self setImage:aPlaceHolder];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:aURL,@"url",self,@"imageView",nil];
        //当列表滑动反复上下迅速滑动时
        //这里不断开辟线程下载同一张图片，有问题
        [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher shareImageCache] withObject:dic];
    }
}

-(void)setIsCacheWithRepesentationRation:(BOOL)aIsCachePresentation{
    [ImageCacher shareImageCache].isPresentationWithRatio = aIsCachePresentation;
}

-(void)setIsDontNeedCache:(BOOL)aIsDontCahce{
    [ImageCacher shareImageCache].isDontNeedToCache = aIsDontCahce;
}

-(void)removeImageWithURLStr:(NSString *)aURLStr{
    [ImageCacher removeImageCacheWithURL:[NSURL URLWithString:aURLStr]];
}

@end
