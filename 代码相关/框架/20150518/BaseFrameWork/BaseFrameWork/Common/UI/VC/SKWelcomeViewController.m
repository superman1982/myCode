//
//  SKWelcomeViewController.m
//  BaseFrameWork
//
//  Created by lin on 15/7/17.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKWelcomeViewController.h"
#import "SKLocalSetting.h"
#import "SKWebParser.h"
#import "SKWebViewBO.h"

@interface SKWelcomeViewController ()<UIWebViewDelegate>
{
    UIWebView          *_webView;
    SKWebViewBO        *_webViewBO;
}

@end

@implementation SKWelcomeViewController

-(void)dealloc{
    _webView.delegate = nil;
    [_webView release],_webView = nil;
    [_webViewBO release],_webViewBO = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SKLocalSetting instanceSkLocalSetting].needShowWelcomePages = NO;
    [SKLocalSetting saveSetting];
    NSDictionary *dic = [SKLocalSetting getDicInKeyChian];
    NSLog(@"钥匙串中数据:%@",dic);
    if (_webViewBO == nil) {
        _webViewBO = [[SKWebViewBO alloc] init];
        _webViewBO.webViewController = self;
    }
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    [self.view addSubview:_webView];
    //welcomePage resource path
    NSString *appPath = [[NSBundle mainBundle] resourcePath];
    NSString *welcomeResourcePath = [appPath stringByAppendingString:@"/WelcomePage/html/load.html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:welcomeResourcePath] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    [_webView loadRequest:request];
    [request release];
}

-(void)removeSelfFromSuperView{
    [UIView animateWithDuration:.4 animations:^{
        self.view.alpha = 0.0;
        self.view.transform = CGAffineTransformMakeScale(2.0, 2.0);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 辅助方法
-(void)dealLink:(NSString *)aUrl{
    SKWebURLType vURLType = [SKWebParser webUrlStr:aUrl];
    switch (vURLType) {
        case SKWebHasMessage:
            [_webView stringByEvaluatingJavaScriptFromString:@"javascript:CWORKJSBridge._fetchQueue()"];
            break;
        case SKWebFetchQueue:{
            NSArray *commondArray = [SKWebParser handleURLParameters:aUrl];
            [_webViewBO dealFetchQueueWithArray:commondArray webView:_webView];
        }
        default:
            break;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.relativeString;
    NSLog(@"urlStr:%@",urlStr);
    [self dealLink:urlStr];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *vJsCode = [SKWebParser readCmpFile:@"cworkjs"];
    [webView stringByEvaluatingJavaScriptFromString:vJsCode];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
