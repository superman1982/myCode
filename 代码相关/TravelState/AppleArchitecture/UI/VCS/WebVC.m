//
//  WebVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-16.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "WebVC.h"
#import "SVProgressHUD.h"

@interface WebVC ()

@end

@implementation WebVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"WebVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"WebVC" bundle:aBuddle];
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
    self.title =  @"旅途邦";
    self.navigationItem.leftBarButtonItem = Nil;

    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"取消" forState:UIControlStateNormal];
    [vRightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(webCancleButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;

}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    if (![self.URLStr hasPrefix:@"http://"]) {
        self.URLStr = [NSString stringWithFormat:@"http://%@",self.URLStr];
    }
    NSURL *vURL = [NSURL URLWithString:self.URLStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:vURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10]];
    [self performSelector:@selector(disMissSVHUD:) withObject:Nil afterDelay:10];
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{
        }
    }else{
    }
}

#pragma mark 内存处理
- (void)viewShouldUnLoad{
      self.webView = Nil;
    [super viewShouldUnLoad];
}

-(void)webCancleButtonTouchDown:(id)sener{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

-(void)disMissSVHUD:(id)sender{
    [SVProgressHUD dismiss];
}

@end
