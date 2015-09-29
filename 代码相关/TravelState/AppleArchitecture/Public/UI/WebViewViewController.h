//
//  WebViewViewController.h
//  iPad
//
//  Jackson.He
//  带WebView+一个关闭按钮的ViewController，布局采用全局布局的方式
//

#import <UIKit/UIKit.h>
#import "CustomWebView.h"
#import "ARCMacros.h"
#import "TerminalData.h"
#import "BaseViewController.h"

@interface WebViewViewController : BaseViewController<UIWebViewDelegate> {
    @private 
    // 当前的WebView
	CustomWebView *mWebView;
    
    BOOL mIsPushStart;
}

// 加载URL
- (void) loadURL: (NSString*) aURL isPushMessage: (BOOL) aIsPushMessage;
// 根据横竖屏设置当前的布局状态
- (void) setLayout:(BOOL) aPortait;

@end