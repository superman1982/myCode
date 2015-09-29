//
//  ImageCacher.m
//  AAPinChe
//
//  Created by Reese on 13-4-3.

#import "ImageCacher.h"
#import "FileManager.h"
#import "ConstDef.h"

@implementation ImageCacher

static ImageCacher *sShareImageCacher = nil;

+ (ImageCacher *) shareImageCache {
	@synchronized(self) {
		if (sShareImageCacher == nil) {
#if __has_feature(objc_arc)
            sShareImageCacher = [[ImageCacher alloc] init];
#else
            sShareImageCacher = [NSAllocateObject([self class], 0 , NULL) init];
#endif
		}
		return sShareImageCacher;
	}
}

#if __has_feature(objc_arc)
#else
// 每一次alloc都必须经过allocWithZone方法，覆盖allWithZone方法，
// 每次alloc都必须经过Instance方法，这样能够保证肯定只有一个实例化的对象
+ (id) allocWithZone: (NSZone *)zone {
    return [[ImageCacher shareImageCache] SAFE_ARC_PROP_RETAIN];
}

// 覆盖copyWithZone方法可以保证克隆时还是同一个实例化的对象广告
+ (id) copyWithZone: (NSZone *)zone {
    return self;
}

- (id) retain {
    return self;
}

// 以下三个函数retainCount，release，autorelease保证了实例不被释放
- (NSUInteger) retainCount {
    return NSUIntegerMax;
}

- (oneway void) release {
    
}

- (id) autorelease {
    return self;
}

#endif

- (id) init {
	self = [super init];
	if (self != nil) {
        [self commonInit];
        [self creatCacheFile];
        [self setAnnatation:waFip];
	}
	return self;
}

-(void)commonInit{
    if (_imageDownloadDic == nil) {
        _imageDownloadDic = [[NSMutableDictionary alloc] init];
    }
}
-(void)creatCacheFile{
    [FileManager createFileAtCacheDirectory:CACHEFILEPATH];
}

-(void)setAnnatation:(WebImageViewAnnation)aType{

    switch (aType) {
        case waFade:
            _type=kCATransitionFade;
            break;
        case waCube:
            _type=@"cube";
            break;
        case waFip:
             _type= @"oglFlip";
            break;
        default:
             _type= @"oglFlip";
            break;
    }
}

//根据URL的hash码为图片文件命名
+ (NSString *)pathForURL:(NSURL *)aURL{
    NSString *vURLHash = [NSString stringWithFormat:@"%@/cachedImage-%u",CACHEFILEPATH,[[aURL description] hash]];
    NSString *vURLPathStr = [FileManager pathInCacheDirectory:vURLHash];
   
    return vURLPathStr;
}


//判断是否已经缓存过这个URL
+(BOOL) hasCachedImage:(NSURL *)aURL{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *vFilePath = [self pathForURL:aURL];
    if ([fileManager fileExistsAtPath:vFilePath]) {
        return YES;
    }
    else return NO;
}

-(void)cacheImage:(NSDictionary*)aDic
{
    @autoreleasepool {
        
        UIView *view=[aDic objectForKey:@"imageView"];
        NSURL *aURL=[aDic objectForKey:@"url"];
        //已加入下载，无需再加入
        if ([_imageDownloadDic objectForKey:aURL.absoluteString]) {
            return;
        }
        [_imageDownloadDic setObject:@"true" forKey:aURL.absoluteString];
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSData *data=[NSData dataWithContentsOfURL:aURL] ;
        UIImage *image=[UIImage imageWithData:data];
        if (image==nil) {
            return;
        }
        CGSize origImageSize= [image size];
        CGRect newRect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        //找最小缩放倍数,让图片缩放到最小
        float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
        
        UIGraphicsBeginImageContext(newRect.size);
        CGRect projectRect;
        //用最小比例同等缩放，算出新的长和宽
        projectRect.size.width =ratio * origImageSize.width;
        projectRect.size.height=ratio * origImageSize.height;
        projectRect.origin.x= 0;
        projectRect.origin.y= 0;
        //若按原比例同等缩放，请将下面的newRect更改为projectRect
        [image drawInRect:newRect];
      
        //默认原比例图片
        UIImage *vShowImage = image;
        //是否进行压缩
        if (_isPresentationWithRatio) {
            vShowImage = UIGraphicsGetImageFromCurrentImageContext();
            _isPresentationWithRatio = NO;
        }
        //展示最好的图片像素位
        NSData *smallData= UIImagePNGRepresentation(vShowImage);
        if (smallData) {
            //不需要进行缓存
            if (_isDontNeedToCache) {
                _isDontNeedToCache = NO;
            }else{
                //缓存
                [fileManager createFileAtPath:[ImageCacher pathForURL:aURL] contents:smallData attributes:nil];
            }

        }

        //View会一直存在，因为它是重用的，妈的
        if (view!=nil) {
//            CATransition *transtion = [CATransition animation];
//            transtion.duration = 0.5;
//            [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//            [transtion setType:_type];
//            [transtion setSubtype:kCATransitionFromRight];
//            [view.layer addAnimation:transtion forKey:@"transtionKey"];
            [(UIImageView*)view setImage:vShowImage];  //设置图片
        }
        
        LOG(@"currentImageURL:%@",aURL);
        UIGraphicsEndImageContext();
    }
}

+ (void)removeImageCache{
    NSString *vImageFilePath = [FileManager pathInCacheDirectory:CACHEFILEPATH];
    [FileManager deleteFile:vImageFilePath];
}

+(void)removeImageCacheWithURL:(NSURL *)aURL{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *vFilePath = [self pathForURL:aURL];
    if ([fileManager fileExistsAtPath:vFilePath]) {
        [FileManager deleteFile:vFilePath];
    }
}
@end
