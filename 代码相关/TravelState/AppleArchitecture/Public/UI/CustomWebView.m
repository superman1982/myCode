//
//  CustomWebView.m
//  iPad
//
//  Jackson.He
//

#import "CustomWebView.h"
#import "Function.h"
#import "ConstDef.h"
#import "ViewControllerManager.h"
#import "WebViewViewController.h"
#import "NetManager.h"

// 类中定义的一个私有方法initWebView
@interface CustomWebView()
- (void) initWebView: (CGRect) aFrame;
@end

// 类的实现
@implementation CustomWebView

@synthesize CWVDelegate = mCWVDelegate;
@synthesize IsShowWait = mIsShowWait;
@synthesize WebView = mWebView;

#pragma mark -
#pragma mark 开始等待状态
- (void) startWaitingAnimation: (NSString*) aHintStr {
	if (mWaitingView == nil)	{
		mWaitingView = [[WaitingView alloc] initWithFrame: self.bounds];
		[self addSubview: mWaitingView];
		mWaitingView.backgroundColor = [UIColor blackColor];
        [mWaitingView setAlpha: 0.6];
	}
	[self bringSubviewToFront: mWaitingView];
	[mWaitingView setHidden: NO];
	[mWaitingView startAnimating];	
	[mWaitingView setHintStr: aHintStr]; 
	[mWaitingView setFrame: self.bounds];
}

#pragma mark -
#pragma mark 结束等待状态
- (void) stopWaitingAnimation {
	if (mWaitingView != nil) {
		[mWaitingView setHintStr: nil];
		[mWaitingView stopAnimating];
		[self sendSubviewToBack:mWaitingView];
		[mWaitingView setHidden:YES];
	}
}

#pragma mark -
#pragma mark 运行JS函数
- (void) runJSFun: (NSString*) aJSFunName {
    if (mWebView == nil) {
        return;
    }
    [mWebView stringByEvaluatingJavaScriptFromString: aJSFunName];
}

#pragma mark -
#pragma mark 获取运行JS函数后的字符串值
- (NSString*) runJSFunAndGetValue: (NSString*) aJSFunName {
    if (mWebView == nil) {
        return nil;
    }
    return [mWebView stringByEvaluatingJavaScriptFromString: aJSFunName];
}

#pragma mark -
#pragma mark 从本地路径加载Html文件
- (void) loadHtmlFileFromFullPath: (NSString *) aFilePathAndName {
    NSURL* vFileURL = [[NSURL alloc] initFileURLWithPath: aFilePathAndName];
    @try {
        NSURLRequest * vRequest = [NSURLRequest requestWithURL: vFileURL];
        [mWebView loadRequest: vRequest];
    } @finally {
        SAFE_ARC_RELEASE(vFileURL);
    }    
}

#pragma mark -
#pragma mark 加载空白页
- (void) loadBlankPage {
    [mWebView stringByEvaluatingJavaScriptFromString: @"document.open();document.close()"];
}

#pragma mark -
#pragma mark 从URL加载Request
- (void) loadRequestFromURL: (NSString*) aURL {
	if ((aURL == nil) || ([aURL length] <= 0)) {
        return;
    }
	// 如果正在加载，则停止加载
	if ([mWebView isLoading]) { 
        [mWebView stopLoading];
    }
	
	NSString * vURLEncodedStr = [aURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	NSURL *vURL = [NSURL URLWithString: vURLEncodedStr];    
	// 增加一个Request
	NSMutableURLRequest *vRequest = [NSMutableURLRequest requestWithURL: vURL 
									 // 缓存策略：验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据
															cachePolicy: NSURLRequestReloadIgnoringCacheData 	
														timeoutInterval: 60.0f];
	[mWebView loadRequest: vRequest];
}

#pragma mark -
#pragma mark 重新加载页面
- (void) reloadPage {
	if (mWebView != nil) {
		[mWebView reload];
	}
}

#pragma mark -
#pragma mark 设置页面是否可以滑动
- (void) setScrollEnabled: (BOOL) aIsScrollEnable {
	// 锁定UIScrollView，不让其滚动
	for (UIView *vSubview in mWebView.subviews)	{
		if ([[vSubview class] isSubclassOfClass: [UIScrollView class]]) {
			((UIScrollView *) vSubview).bounces = aIsScrollEnable;
			((UIScrollView *) vSubview).scrollEnabled = aIsScrollEnable;
		}
	}	
}

#pragma mark -
#pragma mark 设置Frame
- (void) setFrame: (CGRect) aFrame {
	[super setFrame: aFrame];
    // 初始化WebView
    [self initWebView: aFrame];
    
    // 这里注意，要用vTmpRect来设置mWebView以及mWaitingView的Frame
    CGRect vTmpRect = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height); ;    
    [mWebView setFrame: vTmpRect];
    // 需要重新设置一下等待view的Frame
	if (mWaitingView != nil)	{
		[mWaitingView setFrame: vTmpRect];
	}
}

- (void) initWebView: (CGRect) aFrame {
	if (mWebView != nil) {
        return;
    }
#ifdef __IPHONE_4_0
    mWebView = [[UITouchesWebView alloc] initWithFrame: aFrame];
    [mWebView setDelegate: self];
#else
    mWebView = [[UIWebView alloc] initWithFrame: aFrame];
    [mWebView setDelegate: nil];
#endif
    [mWebView setBackgroundColor: [UIColor clearColor]];
    [mWebView setDataDetectorTypes: UIDataDetectorTypeNone];
    [mWebView setScalesPageToFit: YES];
	// 透明
    [mWebView setOpaque: YES];
	// 是否支持交互
	[mWebView setUserInteractionEnabled: YES];
    [mWebView setAutoresizesSubviews: YES];
    [self addSubview: mWebView];
}

#pragma mark -
#pragma mark 系统方法
- (id) initWithFrame: (CGRect) aFrame {
	self = [super initWithFrame: aFrame];
	if (self != nil) {
        mIsScrollEnabled = YES;
        mIsShowWait = NO;
		mCWVDelegate = nil;
        
        [self initWebView: aFrame];
        // 设置WebView是否可移动
        [self setScrollEnabled: mIsScrollEnabled];	
	}
	return self;
}

- (id) init {
	self = [super init];
	if (self != nil) {        
        mIsScrollEnabled = YES;
        mIsShowWait = NO;
		mCWVDelegate = nil;	
	}
	return self;
}

- (void) dealloc {
    [mWebView setDelegate: nil];
    mCWVDelegate = nil;
    
    if (mWebView != nil) {
        SAFE_ARC_RELEASE(mWebView);
        mWebView = nil;
    }
    
    if (mWaitingView != nil) {
        SAFE_ARC_RELEASE(mWaitingView);
        mWaitingView = nil;
    }
    SAFE_ARC_SUPER_DEALLOC();
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
    //获取要转向的URL
    NSURL *vURL = [aRequest URL];
    NSString* vTmpURL = [Function decodeFromPercentEscapeString: [vURL absoluteString]];
    // 加载URL
    if ([[vTmpURL lowercaseString] hasPrefix: @"loadurl://"]) {
        // 如果网络没有连接，并且是网络加载的，直接弹出对应的网络没有连接的信息
        if (![NetManager isConnectNet]) {
            [Function showMessage: START_NETWORKERROR delegate: nil];
            return NO;
        }
    }
    
    // isKindOfClass用来判断是否是某个类或是期子类的实例
    // isMemberOfClass用来判断是否是某个类的实例
    // respondsToSelector用来判断是否有以某个名字命名的方法
    // instancesRespondToSelector用来判断实例是否有以某个名字命名的方法. 和上面一个不同之处在于, 前面这个方法可以用在实例和类上，而此方法只能用在类上.
    // respondsToSelector既可以检查类（是否响应指定类方法），也可以检查实例（是否响应指定实例方法）
    // instancesRespondToSelector只能写在类名后面，但检测的是实例（是否响应指定实例方法）可以认为[Test instancesRespondToSelector:sel]等价于[obj respondsToSelector: sel]
    // 如果存在file:///，由表示是由本地加载的html文件，直接返回YES;
    if ([[vTmpURL lowercaseString] hasPrefix: @"file:///"]) {
        return YES;
    }
    
    // vTmpURL等于about:blank，直接返回NO
    if ([[vTmpURL lowercaseString] isEqualToString: @"about:blank"]) {
        return NO;
    }
    
    // 如果网络没有连接，并且是网络加载的，直接弹出对应的网络没有连接的信息
    if (![NetManager isConnectNet]) {
        [Function showMessage: START_NETWORKERROR delegate: nil];
        return NO;
    } 
    
    // 其它的链接都需要用另一个界面加载 
    [ViewControllerManager createViewController: @"WebViewViewController"];
    WebViewViewController* vWebViewVC = (WebViewViewController*) [ViewControllerManager getBaseViewController: @"WebViewViewController"];
    if (vWebViewVC != nil) {
        // 每次都必须加载URL
        [vWebViewVC loadURL: vTmpURL isPushMessage: NO];
        // 显示当前的弹出窗口
        [ViewControllerManager showBaseViewController: @"WebViewViewController" AnimationType:vaPush SubType:vsFromRight];
        
        return NO;
    }  
    return YES;
}

// 当网页视图已经开始加载一个请求后，得到通知
- (void) webViewDidStartLoad: (UIWebView *) aWebVeiw { 
    if (mIsShowWait) {
        [self startWaitingAnimation: @"正在加载，请稍候......"];
    }
} 

// 当网页视图结束加载一个请求之后，得到通知
- (void) webViewDidFinishLoad: (UIWebView *) aWebVeiw {	
    if (mIsShowWait) {
        [self stopWaitingAnimation];
    }
    
    if (mCWVDelegate != nil && [mCWVDelegate respondsToSelector: @selector(customWebViewDidFinishLoad:)]) {
        [mCWVDelegate customWebViewDidFinishLoad: self];
    }
    // 修正WebView的内存泄漏
    // 导致此泄漏的关键属性是的 WebKitCacheModelPreferenceKey。
    // 当你在一个UIWebView打开一个链接，这个属性被自动设置为“1”值 。因此，解决的办法是每当你打开一个链接时把它设回0：
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey: @"WebKitCacheModelPreferenceKey"];
} 

// 当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型
- (void) webView: (UIWebView *) aWebView didFailLoadWithError: (NSError *) aError { 
	LOG(@"didFailLoadWithError=%@", [aError localizedDescription]);
	[self stopWaitingAnimation];
}

#pragma mark -
#pragma mark touches
- (void) touchesBegan: (NSSet*) aTouches inWebView: (UIWebView*) sender withEvent: (UIEvent*) aEvent {
	if([aTouches count]  == 1) {
		mIsClick = YES;
	}
}

- (void) touchesMoved: (NSSet*) aTouches inWebView: (UIWebView*) sender withEvent:(UIEvent*) aEvent {
	mIsClick = NO;
}

- (void) touchesEnded: (NSSet*) aTouches inWebView: (UIWebView*) sender withEvent:(UIEvent*) aEvent {
	if([aTouches count] == 1 && mIsClick && mCWVDelegate != nil && [mCWVDelegate respondsToSelector: @selector(customWebViewDidClick)]) {
		[mCWVDelegate customWebViewDidClick];
    }
}

- (void) touchesCancelled: (NSSet*) aTouches inWebView: (UIWebView*) sender withEvent: (UIEvent*)aEvent {
	mIsClick = NO;
}

- (void) zoomWebViewFrame {
	if (mWebView != nil) {
		CGRect vRect = self.bounds;
		vRect.size.height -= 10.0f;
		vRect.size.width  -= 40.0f;
		vRect.origin.x += 20.0f;
		vRect.origin.y += 5.0f;
		[mWebView setFrame: vRect];
	}
}
@end
