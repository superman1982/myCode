//
//  BunessIntroductionVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BunessIntroductionVC.h"
#import "SVProgressHUD.h"

@interface BunessIntroductionVC ()

@end

@implementation BunessIntroductionVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
       self = [super initWithNibName:@"BunessIntroductionVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"BunessIntroductionVC" bundle:aBuddle];
    }
    if (self != nil) {
        [self initCommonData];
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {
    [super setLayout: aPortait];
    [self setViewFrame:aPortait];
}

//重载导航条
-(void)initTopNavBar{
    [super initTopNavBar];
    self.title = @"商家简介";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

//初始化数据
-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_introductionWebView release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView: (BOOL) aPortait {
    [self.view addSubview:self.introductionWebView];
    [self initWeb:self.introductionURLStr];
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
    }else{
    }
}

//------------------------------------------------

- (void)viewDidUnload {
    [self setIntroductionWebView:nil];
    [super viewDidUnload];
}

-(void)initWeb:(NSString *)aURLStr{
    NSURL *vURL = [NSURL URLWithString:aURLStr];
    NSURLRequest *vRequest = [[NSURLRequest alloc] initWithURL:vURL];
    [self.introductionWebView loadRequest:vRequest];
    SAFE_ARC_RELEASE(vRequest);
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD showSuccessWithStatus:@""];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

@end
