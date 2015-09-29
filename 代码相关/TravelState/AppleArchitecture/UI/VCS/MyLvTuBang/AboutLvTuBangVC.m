//
//  AboutLvTuBangVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AboutLvTuBangVC.h"
#import "NetManager.h"
#import "ConfigFile.h"

@interface AboutLvTuBangVC ()

@end

@implementation AboutLvTuBangVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"AboutLvTuBangVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"AboutLvTuBangVC" bundle:aBuddle];
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
    self.title = @"关于旅途邦";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    //获取本地关于车途邦更改日期
    NSString *vLocalModifyDate = [[ConfigFile readConfigDictionary] objectForKey:@"modifyDateTime"];
    IFISNIL(vLocalModifyDate);
    
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:vLocalModifyDate,@"prevDateTim", nil];
    [NetManager postDataFromWebAsynchronous:APPURL1001 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            NSString *vAboutURLStr = [vDataDic objectForKey:@"aboutLTB"];
            [self initWeb:vAboutURLStr];
            NSString *vmodifyDateTime = [vDataDic objectForKey:@"modifyDateTime"];
            IFISNIL(vmodifyDateTime);
            [ConfigFile saveConfigDictionary:[NSDictionary dictionaryWithObject:vmodifyDateTime forKey:@"modifyDateTime"]];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"请求关于车途邦" Notice:@""];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_aboutLable release];
    [_aboutWebView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self clearWebViewBackgroundWithColor];
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
    [super viewShouldUnLoad];
}
//----------

#pragma mark - 其他辅助功能
-(void)initWeb:(NSString *)aURLStr{
    NSURL *vURL = Nil;
    vURL = [NSURL URLWithString:aURLStr];
    NSURLRequest *vRequest = [[NSURLRequest alloc] initWithURL:vURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    [self.aboutWebView loadRequest:vRequest];
    SAFE_ARC_RELEASE(vRequest);
}

// 去掉UIWebView上下滚动出边界时的黑色阴影
- (void)clearWebViewBackgroundWithColor{
    for (UIView *view in [self.aboutWebView subviews]){
        if ([view isKindOfClass:[UIScrollView class]]){
            for (UIView *shadowView in view.subviews){
                // 上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                if ([shadowView isKindOfClass:[UIImageView class]]){
                    shadowView.backgroundColor = [UIColor whiteColor];
                }
            }
        }
    }
}

- (void)viewDidUnload {
    [self setAboutLable:nil];
    [self setAboutWebView:nil];
    [super viewDidUnload];
}
@end
