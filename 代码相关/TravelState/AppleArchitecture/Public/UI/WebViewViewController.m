//
//  WebViewViewController.m
//  iPad
//

#import "WebViewViewController.h"
#import "Function.h"
#import "ConstDef.h"
#import "Macros.h"
#import "TerminalData.h"

@interface WebViewViewController()
// 初始化Frame
- (void) initFrame;
@end

@implementation WebViewViewController

#pragma mark -
#pragma mark 系统方法
- (id) init {
    self = [super init];
    if (self != nil) {
		// 初始化Frame
		[self initFrame];
    }
	return self;
}

- (void) dealloc {      
    if (mWebView != nil) {
        SAFE_ARC_RELEASE(mWebView);
		mWebView = nil;
    }
    SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark -
#pragma mark 自定义类方法
- (void) initFrame {
    mWidth = [TerminalData deviceWidth];
    mHeight = [TerminalData deviceHeight];
    
    [self initTopNavBar];
    
	// WebView的Frame   
	CGRect vFrame = CGRectMake(0, 50, mWidth, mHeight - 50);

	if (mWebView == nil) {
		mWebView = [[CustomWebView alloc] initWithFrame: vFrame];
        
        mWebView.WebView.delegate = self;
		[mWebView setScrollEnabled: YES];
        [mWebView setIsShowWait: YES];
		[self.view addSubview: mWebView];
	} else {
		[mWebView setFrame: vFrame];
	}
}

// 加载URL
- (void) loadURL: (NSString*) aURL isPushMessage: (BOOL) aIsPushMessage {
    mIsPushStart = aIsPushMessage;
	if (aURL != nil) {
        [self startWaitingAnimation: @""];
		[mWebView loadRequestFromURL: aURL];
	}
}

// 根据横竖屏设置当前的布局状态
- (void) setLayout: (BOOL) aPortait { 
    mIsPortait = aPortait; 
	[self initFrame];
    
    // 主要是用来设置mWaitingView的大小及布局
    [super setLayout: aPortait];
}

#pragma mark -
#pragma mark WebView delegate
// 当网页视图被指示载入内容而得到通知。应当返回YES，这样会进行加载。通过导航类型参数可以得到请求发起的原因，可以是以下任意值： 
// UIWebViewNavigationTypeLinkClicked 
// UIWebViewNavigationTypeFormSubmitted
// UIWebViewNavigationTypeBackForward  
// UIWebViewNavigationTypeReload  
// UIWebViewNavigationTypeFormResubmitted 
// UIWebViewNavigationTypeOther  
- (BOOL) webView: (UIWebView*) aWebView shouldStartLoadWithRequest: (NSURLRequest*) aRequest navigationType: (UIWebViewNavigationType) aNavigationType { 
    return YES;
} 

// 当网页视图结束加载一个请求之后，得到通知
- (void) webViewDidFinishLoad: (UIWebView *) aWebVeiw {	
    [self stopWaitingAnimation];
} 

@end
