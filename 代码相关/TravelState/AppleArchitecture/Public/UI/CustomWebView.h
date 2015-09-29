//
//  CustomWebView.h
//  iPad
//
//  Jackson.He
//

#import <Foundation/Foundation.h>
#import "UITouchesWebView.h"
#import "WaitingView.h"
#import "ARCMacros.h"
#import "Macros.h"

// 在dealloc要把delegate至为nil，delegate设置属性的时候要用assign，不要用retain。
@protocol CustomWebViewDelegate;
@interface CustomWebView : UIView <UIWebViewDelegate> {
	UIWebView *mWebView;
	WaitingView *mWaitingView;
//	id<CustomWebViewDelegate> mCWVDelegate;
    BOOL mIsScrollEnabled;
    // 加载的时候是否显示进度条
    BOOL mIsShowWait;
@private
	BOOL mIsClick;
}
@property (nonatomic, assign) id<CustomWebViewDelegate> CWVDelegate;
@property (nonatomic, assign) BOOL IsShowWait;
@property (nonatomic, readonly, SAFE_ARC_PROP_RETAIN) UIWebView* WebView;
// 开始等待状态
- (void) startWaitingAnimation: (NSString *) aHintStr;
// 结束等待状态
- (void) stopWaitingAnimation;
// 运行JS函数
- (void) runJSFun: (NSString *) aJSFunName;
// 获取运行JS函数后的字符串值
- (NSString*) runJSFunAndGetValue: (NSString *) aJSFunName;
// 从本地路径加载Html文件
- (void) loadHtmlFileFromFullPath: (NSString *) aFilePathAndName;
// 加载空白页
- (void) loadBlankPage;
// 从URL加载Request
- (void) loadRequestFromURL: (NSString*) aURL;

// 重新加载页面
- (void) reloadPage;
// 设置页面是否可以滑动
- (void) setScrollEnabled: (BOOL) aIsScrollEnable;
// 设置Frame
- (void) setFrame: (CGRect) aFrame;

@end

@protocol CustomWebViewDelegate <NSObject>
- (void) customWebViewDidFinishLoad: (CustomWebView*) CustomWebView;
- (void) customWebViewDidClick;
@end
