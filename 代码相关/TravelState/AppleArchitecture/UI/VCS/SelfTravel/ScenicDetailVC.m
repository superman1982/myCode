//
//  ScenicDetailVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-24.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ScenicDetailVC.h"
#import "StringHelper.h"
#import "RoutesMapVC.h"
#import "SVProgressHUD.h"
#import "CleanCarVC.h"
#import "UserManager.h"
#import "ActivityRouteManeger.h"


@interface ScenicDetailVC ()

@property (nonatomic,assign) BOOL isAddedMap;

@end

@implementation ScenicDetailVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ScenicDetailVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ScenicDetailVC" bundle:aBuddle];
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
    self.title = @"杜甫草堂";
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
    [_comeToThePlaceButton release];
    [_nearByBunessButton release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.title = self.electronicInfo.name;
    NSString *vFileStr = self.electronicInfo.detailFilePath;
    id vSiteId = self.electronicInfo.siteId;
    id vActiviID = self.electronicInfo.activityId;
    NSString *vHtmlStr =[NSString stringWithFormat:@"%@/%@_%@_Introduction.html",vFileStr,vActiviID,vSiteId];
    [self initWeb:vHtmlStr];
    [self clearWebViewBackgroundWithColor];
    [self.detailWebView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:self.detailWebView];
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


-(void)setIsAddedMap:(BOOL)isAddedMap{
    _isAddedMap = isAddedMap;
    if (isAddedMap) {
        self.title = @"行程地图";
    }else{
        self.title = @"杜甫草堂";
    }
}

-(void)back{
    if (self.isAddedMap) {
        UIView *vMapView = [self.view viewWithTag:1001];
        [vMapView removeFromSuperview];
        [(UIScrollView *)self.view setScrollEnabled:YES];
        self.isAddedMap = NO;
        //打开到这里去button
        self.comeToThePlaceButton.userInteractionEnabled = YES;
    }else{
        [super back];
        if ([_delegate respondsToSelector:@selector(didBackToVCClicked:)]) {
            [_delegate didBackToVCClicked:self.isAddedMap];
        }
    }
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

#pragma mark - 其他辅助功能
// 去掉UIWebView上下滚动出边界时的黑色阴影
- (void)clearWebViewBackgroundWithColor{
    for (UIView *view in [self.detailWebView subviews]){
        if ([view isKindOfClass:[UIScrollView class]]){
            for (UIView *shadowView in view.subviews){
                // 上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                if ([shadowView isKindOfClass:[UIImageView class]]){
                    shadowView.backgroundColor = [UIColor clearColor];
                }
            }
        }
    }
}

-(void)initWeb:(NSString *)aURLStr{
    NSURL *vURL = [NSURL fileURLWithPath:aURLStr];
    NSURLRequest *vRequest = [[NSURLRequest alloc] initWithURL:vURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    [self.detailWebView loadRequest:vRequest];
    SAFE_ARC_RELEASE(vRequest);
    
    [self performSelector:@selector(dismissSVProgress) withObject:Nil afterDelay:2];
}

-(void)dismissSVProgress{
    [SVProgressHUD dismiss];
}
-(void)clearButtons{
    [self.comeToThePlaceButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.comeToThePlaceButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    [self.nearByBunessButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.nearByBunessButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
}
#pragma mark - 其他业务点击事件
#pragma mark 点击到这里去
- (IBAction)comeToThePlaceButtonClicked:(id)sender {
//    //关闭到这里去Button
//    self.comeToThePlaceButton.userInteractionEnabled = NO;
//    self.isAddedMap = YES;
//    //实例化地图
//    RoutesMapVC *vRoutesVC = [[RoutesMapVC alloc] init];
//    [vRoutesVC.view setTag:1001];
//    //设置地图为大地图
//    [vRoutesVC.view setFrame:self.view.frame];
//    //添加地图到全屏
//    [self.view addSubview:vRoutesVC.view];
    
    CLLocationCoordinate2D vDestinaCoord = CLLocationCoordinate2DMake([self.electronicInfo.latitude doubleValue], [self.electronicInfo.longitude doubleValue]);
    CLLocationCoordinate2D vUserCoord = [UserManager instanceUserManager].userCoord;
    [ActivityRouteManeger gotoBaiMapApp:vUserCoord EndLocation:vDestinaCoord];
    
    [self clearButtons];
    [self.comeToThePlaceButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
    [self.comeToThePlaceButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
}

#pragma mark 点击附近商家
- (IBAction)nearByBunessButtonClicked:(id)sender {
    //更新用户选择的坐标，百度云搜索附近商家时以用户选择的坐标为最新坐标
    [ActivityRouteManeger shareActivityManeger].userChosedBunessCoord = CLLocationCoordinate2DMake([self.electronicInfo.latitude doubleValue], [self.electronicInfo.longitude doubleValue]);
    LOG(@"用户点击商家坐标:%f,%f",[self.electronicInfo.latitude doubleValue], [self.electronicInfo.longitude doubleValue]);
    //显示商家
    [ViewControllerManager createViewController:@"CleanCarVC"];
    [ViewControllerManager showBaseViewController:@"CleanCarVC" AnimationType:vaDefaultAnimation SubType:0];
    CleanCarVC *vVC = (CleanCarVC *)[ViewControllerManager getBaseViewController:@"CleanCarVC"];
    [vVC typeSelected:stViewPoint BunessName:Nil];
    
    [self clearButtons];
    [self.nearByBunessButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
    [self.nearByBunessButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
}

- (void)viewDidUnload {
    [self setComeToThePlaceButton:nil];
    [self setNearByBunessButton:nil];
[super viewDidUnload];
}
@end
