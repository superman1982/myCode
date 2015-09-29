//
//  CustomImageView.m
//  iPad
//
//  Jackson.He
//

#import "CustomImageView.h"
#import "FileManager.h"
#import "Function.h"
#import "MainConfig.h"
#import "NetManager.h"

@interface CustomImageView()
// 开始下载等待
- (void) beginWait;
// 结束等待
- (void) endWait;
// 从URL或是文件路径获取图片
- (void) getImageFromURLOrFilePath;
// 刷新图片
- (void) refreshImage: (UIImage*) aImage;
// 设置自定义的图片
- (void) setCustomImage: (UIImage*) aImage;
@end

@implementation CustomImageView
@synthesize CustomImageViewDelegate = mCustomImageViewDelegate;
@synthesize waitType = mWaitType;

#pragma mark -
#pragma mark 系统方法
- (id) init {
    self = [super init];
    if (self != nil) {
		mCustomImageViewDelegate = nil;
    }
    return self;
}

- (id) initWithFrame: (CGRect) aFrame {
    self = [super initWithFrame: aFrame];
    if (self != nil) {
		mCustomImageViewDelegate = nil;
    }
    return self;
}

- (void) dealloc {
	mCustomImageViewDelegate = nil;
    if (mAIParantView != nil) {
        SAFE_ARC_RELEASE(mAIParantView);
        mAIParantView = nil;
    }
    
    if (mAIView != nil) {
        SAFE_ARC_RELEASE(mAIView);
        mAIView = nil;
    }
    
    if (mImageURL != nil) {
        SAFE_ARC_RELEASE(mImageURL);
        mImageURL = nil;
    }
    
    if (mFilePath != nil) {
        SAFE_ARC_RELEASE(mFilePath);
        mFilePath = nil;
    }
    
    SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark -
#pragma mark 自定义类方法
- (void) beginWait {
	if (mAIView == nil) {
		if (mAIParantView == nil) {
			mAIParantView = [[UIView alloc] initWithFrame: self.bounds];
			mAIParantView.backgroundColor = [UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.4f];
			[self addSubview: mAIParantView];
		}
		mAIView = [[UIActivityIndicatorView alloc] init];
        int vWidth = 36;
        switch (mWaitType) {
            case wtBig:
                vWidth = 36;
                break;
            case wtMiddle:
                vWidth = 24;
                break;
            case wtSmall:
                vWidth = 16;
                break;
            default:
                break;
        }
		mAIView.frame = CGRectMake(0.0f, 0.0f, vWidth, vWidth);
		mAIView.center = mAIParantView.center;
		mAIView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		mAIView.hidesWhenStopped = YES;
		
		[mAIParantView addSubview: mAIView];
	}
	[mAIParantView setHidden: NO];
	[mAIView startAnimating];
}

// 结束等待
- (void) endWait {
	// 完成线程 调用回调函数
	[mAIView stopAnimating];
	[mAIParantView setHidden: YES];
}

// 从URL或是文件路径获取图片
- (void) getImageFromURLOrFilePath {
    if (mImageURL == nil || mFilePath == nil) {
        return;
    }
    
	SAFE_ARC_AUTORELEASE_POOL_START();
    @try {
        NSString *vURLEncodedStr = [mImageURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];        
        NSData *vImageData = nil;
		// 获得文件路径
		NSString *vImageFilePath = [mFilePath stringByAppendingPathComponent: [mImageURL lastPathComponent]];
        // 如果文件不存在，则先进行下载
        if(![FileManager fileIsExist: vImageFilePath]){
			vImageData = [NetManager getDataFromURL: vURLEncodedStr timeout: 10];
			if (vImageData != nil) {
				[FileManager writeFileByFileName: vImageFilePath
                                  streamFileData: [NSMutableData dataWithData: vImageData] 
                                        isAppend: NO];
			}
		}
        
        if ([FileManager fileIsExist: vImageFilePath]) {
			vImageData = [NSData dataWithContentsOfFile: vImageFilePath];
            // 刷新图片
            [self refreshImage: [UIImage imageWithData: vImageData]];
		}
    } @finally {
        SAFE_ARC_AUTORELEASE_POOL_END();
    }
}

// 刷新图片
- (void) refreshImage: (UIImage*) aImage {
	[self endWait];
	
	[self performSelectorOnMainThread: @selector(setCustomImage:) withObject: aImage waitUntilDone: YES];
}

// 设置自定义的图片
- (void) setCustomImage: (UIImage*) aImage {
    if (aImage && [aImage isKindOfClass:[UIImage class]]) {
        [self setImage: aImage];
        if (mCustomImageViewDelegate && [mCustomImageViewDelegate respondsToSelector: @selector(customImageViewDidLoadSuccessful:)]) {
            [mCustomImageViewDelegate customImageViewDidLoadSuccessful: self];
        }
    } else {
        if (mDefaultImage && [mDefaultImage isKindOfClass:[UIImage class]] && mDefaultImage.size.width > 0)
        {
            [self setImage: mDefaultImage];
        } else {
            [self setImage:nil];
        }
    }
}

// 根据URL装载图片
- (void) loadImageFormURL: (NSString*) aURL filePath: (NSString*) aFilePath {
    if (aURL == nil || aFilePath == nil) {
        return;
    }
    
	[self beginWait];
    
    if (mImageURL != nil) {
        SAFE_ARC_RELEASE(mImageURL);
        mImageURL = nil;
    }
    
    if (mFilePath != nil) {
        SAFE_ARC_RELEASE(mFilePath);
        mFilePath = nil;
    }
    
    mImageURL = SAFE_ARC_RETAIN(aURL);
    mFilePath = SAFE_ARC_RETAIN(aFilePath);
    // 线程下载图片
	[NSThread detachNewThreadSelector: @selector(getImageFromURLOrFilePath) 
							 toTarget: self 
						   withObject: nil];
}

// 设置默认的图片
- (void) setDefaultImage: (UIImage*) aImage {
    if (mDefaultImage != nil) {
        SAFE_ARC_RELEASE(mDefaultImage);
        mDefaultImage = nil;
    }
    
    mDefaultImage = SAFE_ARC_RETAIN(aImage);
}

// 设置布局
- (void) setFrame: (CGRect) aFrame {
	[super setFrame: aFrame];
	if (mAIParantView != nil) {
		[mAIParantView setFrame: self.bounds];
	}
    
	if (mAIView != nil && mAIParantView != nil) {
		[mAIView setFrame: CGRectMake(0.0f, 0.0f, 36, 36)];
		mAIView.center = mAIParantView.center;
	}
}

@end
