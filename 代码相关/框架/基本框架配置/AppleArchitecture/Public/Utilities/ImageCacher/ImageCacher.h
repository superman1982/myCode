

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    waFade = 0,
    waFip,
    waCube,
}WebImageViewAnnation;

@interface ImageCacher : NSObject

@property (retain,nonatomic) NSString *type;

@property (nonatomic,assign) BOOL isPresentationWithRatio;

@property (nonatomic,assign) BOOL isDontNeedToCache;

+ (ImageCacher *) shareImageCache;
+ (BOOL) hasCachedImage:(NSURL *)aURL;
+ (NSString *)pathForURL:(NSURL *)aURL;
//移除整个缓存
+ (void)removeImageCache;
//移除某张图片的缓存
+(void)removeImageCacheWithURL:(NSURL *)aURL;

- (void)cacheImage:(NSDictionary*)aDic;
- (void)setAnnatation:(WebImageViewAnnation)aType;

@end
