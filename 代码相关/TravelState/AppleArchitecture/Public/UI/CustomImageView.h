//
//  CustomImageView.h
//  iPad
//
//  Jackson.He
//

#import <UIKit/UIKit.h>
#import "ARCMacros.h"



// 自定义模板类型
typedef enum {
    wtBig = 0,          // 大的等待标志
    wtMiddle,           // 中的
    wtSmall,            // 小的
} WaitType;

@protocol CustomImageViewDelegate;
@interface CustomImageView : UIImageView {
    UIView* mAIParantView;
	UIActivityIndicatorView* mAIView;
	UIImage* mDefaultImage;
//	id<CustomImageViewDelegate> mCustomImageViewDelegate;
    
    // 网络图片的URL
    NSString* mImageURL;
    // 图片的路径
    NSString* mFilePath;
    // 等待图标的大小
    WaitType mWaitType;
}

@property (nonatomic, assign) id<CustomImageViewDelegate> CustomImageViewDelegate;
@property (nonatomic, assign) WaitType waitType;

// 根据URL装载图片
- (void) loadImageFormURL: (NSString*) aURL filePath: (NSString*) aFilePath;
// 设置默认的图片
- (void) setDefaultImage: (UIImage*) aImage;
// 设置布局
- (void) setFrame: (CGRect) aFrame;
@end


@protocol CustomImageViewDelegate<NSObject>
@optional
// 图片加载成功
- (void) customImageViewDidLoadSuccessful: (CustomImageView*) aCustomImageView;
// 图片加载失败
- (void) customImageViewDidLoadFail: (CustomImageView*) aCustomImageView;
@end
