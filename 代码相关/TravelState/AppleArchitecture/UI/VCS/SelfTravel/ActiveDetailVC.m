//
//  ActiveDetailVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ActiveDetailVC.h"
#import "StringHelper.h"
#import "ActiveBookVC.h"
#import "ActivityRouteManeger.h"
#import "SVProgressHUD.h"
#import "ConfigFile.h"
#import "ElectronicBookManeger.h"
#import "UserManager.h"
#import "ActiveCommentVC.h"
#import "SelfTravelVC.h"
#import "ElectronicRouteBookVC.h"
#import "SelfTravelVC.h"

@interface ActiveDetailVC ()

@end

@implementation ActiveDetailVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
              self = [super initWithNibName:@"ActiveDetailVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ActiveDetailVC" bundle:aBuddle];
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
    self.title = @"活动详情";
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
    [_detailWebView release];
    [_donwLoadOrCheckButton release];
    [_customButton release];
    [_zanLable release];
    [_shareLable release];
    [_commentLable release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    //查看配置文件，
    NSDictionary *vConfigDic = [ConfigFile readConfigDictionary];
    NSString *vKey = [NSString stringWithFormat:@"%@",self.acticeInfo.ActivityId];
    //获取路书是否被下载状态
    NSDictionary *vIfIsDownLoadDic = [vConfigDic objectForKey:vKey];
    NSString *mainHtmlStr = Nil;
    //如果已下载load本地html
    if (vIfIsDownLoadDic != nil) {
       NSDictionary *vElecDic =[ElectronicBookManeger getElectronicBookInfo:self.acticeInfo.rouadBookURL];
        mainHtmlStr = [vElecDic objectForKey:MAINHTMLKEY];
        IFISNIL(mainHtmlStr);
        [self initWeb:mainHtmlStr IsLocal:YES];
    }else {
        mainHtmlStr = [_detailDic objectForKey:@"hrefLocation"];
        IFISNIL(mainHtmlStr);
        [self initWeb:mainHtmlStr IsLocal:NO];
    }
    
    //清除webview的黑色背景
    [self clearWebViewBackgroundWithColor];
    //重新设置webView的content
    [self.detailWebView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height-60)];
    [self.contentView addSubview:self.detailWebView];
    
    //----设置button状态---------
    if (self.acticeInfo.type == atActiveRoutes) {
        //如果没有报名，显示报名
        if (([self.acticeInfo.isSignup intValue]==0)) {
            self.cellButtonType = btBook;
        }
        
        //查看路数是否过期，过期直接为活动结束
        if (mDateFormatter == Nil) {
            mDateFormatter = [[NSDateFormatter alloc] init];
            [mDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        NSDate *vActiveEndDate = [mDateFormatter dateFromString:self.acticeInfo.signupEndDate];
        NSDate *vEarlyDate = [vActiveEndDate earlierDate:[NSDate date]];
        if ([vEarlyDate isEqualToDate:vActiveEndDate]) {
            self.cellButtonType = btActiveEnd;
        }

        //如果已经报名了，仍然可以下载
        if ([self.acticeInfo.isSignup intValue]==1) {
            self.cellButtonType = btDownload;
        }
        //没有登录显示为报名
        if (![UserManager isLogin]) {
            self.cellButtonType = btBook;
        }
    }else{
        self.cellButtonType = btDownload;
    }
    
    //查看配置文件，检查路书是否被下载，如果已下载显示查看路书
    if (vIfIsDownLoadDic != nil) {
        self.cellButtonType = btCheckRoutes;
        NSString *vModefyDate = [vIfIsDownLoadDic objectForKey:MODIFYDATE];
        IFISNIL(vModefyDate);
        //如果修改时间不一致就改变为下载状态
        if (self.acticeInfo.roadBookModifyTime != Nil &&![vModefyDate isEqualToString:self.acticeInfo.roadBookModifyTime] ) {
            self.cellButtonType = btDownload;
        }
    }
    
    //赞的数量
    self.zanLable.text = [NSString stringWithFormat:@"%@",self.acticeInfo.praiseCount ];
    //分享的数量
    self.shareLable.text = [NSString stringWithFormat:@"%@",self.acticeInfo.shareCount];
    //评论的数量
    self.commentLable.text = [NSString stringWithFormat:@"%@",self.acticeInfo.comentCount];
    
    [self.contentView bringSubviewToFront:self.customButton];
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

-(void)back{
    [super back];
}


-(void)setDetailDic:(NSDictionary *)detailDic{
    if (![detailDic isKindOfClass:[NSDictionary class]]) {
        LOGERROR(@"setDetailDic");
        return;
    }
    if (_detailDic == Nil) {
        _detailDic = [[NSDictionary alloc] initWithDictionary:detailDic];
    }
}


-(void)setCellButtonType:(ButtonType)cellButtonType{
    _cellButtonType = cellButtonType;
    if (_cellButtonType == btBook) {
        [self.donwLoadOrCheckButton setTitle:@"" forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@"eventDetail_singUp_btn_default"] forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@"eventDetail_singUp_btn_select"] forState:UIControlStateHighlighted];
    }else if (_cellButtonType == btCheckRoutes){
        [self.donwLoadOrCheckButton setTitle:@"" forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@"eventDetail_checkRoad_btn_default"] forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@"eventDetail_checkRoad_btn_select"] forState:UIControlStateHighlighted];
    }else if (_cellButtonType == btDownload)
    {
        [self.donwLoadOrCheckButton setTitle:@"" forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@"eventDetail_download_btn_default"] forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@"eventDetail_download_btn_select"] forState:UIControlStateHighlighted];
    }else if (_cellButtonType == btDownloading){
        [self.donwLoadOrCheckButton setTitle:@"下载中..." forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }else if (_cellButtonType == btActiveEnd){
        [self.donwLoadOrCheckButton setTitle:@"活动结束" forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.donwLoadOrCheckButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
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
-(void)initWeb:(NSString *)aURLStr IsLocal:(BOOL)aIslocal{
    if (aURLStr.length == 0) {
        return;
    }
    NSURL *vURL = Nil;
    if (aIslocal) {
        vURL = [NSURL fileURLWithPath:aURLStr];
    }else{
        vURL = [NSURL URLWithString:aURLStr];
    }
    NSURLRequest *vRequest = [[NSURLRequest alloc] initWithURL:vURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    [self.detailWebView loadRequest:vRequest];
    SAFE_ARC_RELEASE(vRequest);
    [self performSelector:@selector(dismissSVProgress) withObject:Nil afterDelay:2];
}

// 去掉UIWebView上下滚动出边界时的黑色阴影
- (void)clearWebViewBackgroundWithColor{
    for (UIView *view in [self.detailWebView subviews]){
        if ([view isKindOfClass:[UIScrollView class]]){
            for (UIView *shadowView in view.subviews){
                // 上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                if ([shadowView isKindOfClass:[UIImageView class]]){
                    shadowView.hidden = YES;
                }
            }
        }
    }
}

-(void)dismissSVProgress{
    [SVProgressHUD dismiss];
}

-(void)setLableCount:(ActiveInfo *)aInfo{
    self.acticeInfo = aInfo;
    //赞的数量
    self.zanLable.text = [NSString stringWithFormat:@"%@",aInfo.praiseCount ];
    //分享的数量
    self.shareLable.text = [NSString stringWithFormat:@"%@",aInfo.shareCount];
    //评论的数量
    self.commentLable.text = [NSString stringWithFormat:@"%@",aInfo.comentCount];
}

#pragma mark - 其他业务点击事件
#pragma mark 点击赞
- (IBAction)praseButtonClicked:(id)sender {
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vPagemeter = [NSDictionary dictionaryWithObjectsAndKeys:vUserID,@"userId",self.acticeInfo.ActivityId,@"activityId", nil];
    [ActivityRouteManeger postSharePraseCommentData:APPURL403 Paremeter:vPagemeter Prompt:@"" RequestName:@"赞！" ];
}

#pragma mark 点击分享
- (IBAction)shareButtonClicked:(id)sender {
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:self.acticeInfo.ActivityId,@"activityId", nil];
    NSString *vContentStr = [NSString stringWithFormat:@"旅途邦：%@ %@",self.acticeInfo.activeTitle,self.acticeInfo.activityURL];
    [ActivityRouteManeger showShare:@"旅途邦" Content:vContentStr Paremeter:vParemeter ShareType:stActivity];
}

#pragma mark 点击评价
- (IBAction)commentButtonClicked:(id)sender {
    if (self.acticeInfo.isSignup) {
        [ViewControllerManager createViewController:@"ActiveCommentVC"];
        ActiveCommentVC *vVC = (ActiveCommentVC *)[ViewControllerManager getBaseViewController:@"ActiveCommentVC"];
        vVC.activeInfo = self.acticeInfo;
        [ViewControllerManager showBaseViewController:@"ActiveCommentVC" AnimationType:vaDefaultAnimation SubType:0];
    }
}

#pragma mark 点击报名
- (IBAction)bookButtonClicked:(id)sender {
    if (_cellButtonType == btBook) {
        //检查是否登录
        if (![ActivityRouteManeger checkIfIsLogin]) {
            return;
        }
        
        [ViewControllerManager createViewController:@"ActiveBookVC"];
        ActiveBookVC *vVC = (ActiveBookVC *)[ViewControllerManager getBaseViewController:@"ActiveBookVC"];
        vVC.activinfo = self.acticeInfo;
        [ViewControllerManager showBaseViewController:@"ActiveBookVC" AnimationType:vaDefaultAnimation SubType:0];
        //设置代理，以便报名成功后更新列表，变报名为下载按钮
        SelfTravelVC *vSelfTVC = (SelfTravelVC *)[ViewControllerManager getBaseViewController:@"SelfTravelVC"];
        vVC.delegate = vSelfTVC;
        
        //获取单次报名总人数
        NSNumber *vActiviID = self.acticeInfo.ActivityId;
        NSString *vActiviIDStr = [NSString stringWithFormat:@"%@",vActiviID];
        id vtotalSignup = self.acticeInfo.totalSignup;
        IFISNIL(vtotalSignup);
        //储存单次报名总人数
        NSDictionary *vSingnupDic = [NSDictionary dictionaryWithObjectsAndKeys:vtotalSignup,BOOKEDPEOPLEKEY, nil];
        //根据不同活动ID储存相应报名人数信息
        [[ActivityRouteManeger shareActivityManeger].bookPeopleDic setObject:vSingnupDic forKey:vActiviIDStr];
        LOG(@"本次报名房差:%@,允许的最大报名人数:%@,保单价:%@",self.acticeInfo.lodingMoney,vtotalSignup,self.acticeInfo.insuranceMone);
        
    }else if (_cellButtonType == btCheckRoutes){
        //获得电子路书路线信息
        NSDictionary *vElectronicDic = [ElectronicBookManeger getElectronicBookInfo:self.acticeInfo.rouadBookURL];
        NSDictionary *vRouteDic = [vElectronicDic objectForKey:ROUTEDICKEY];
        if (vRouteDic.count != 0) {
            [ViewControllerManager createViewController:@"ElectronicRouteBookVC"];
            ElectronicRouteBookVC *vVC = (ElectronicRouteBookVC *)[ViewControllerManager getBaseViewController:@"ElectronicRouteBookVC"];
            //设置电子路书路线
            vVC.electronicDic = vElectronicDic;
            vVC.routesType = self.acticeInfo.type;
            [ViewControllerManager showBaseViewController:@"ElectronicRouteBookVC" AnimationType:vaDefaultAnimation SubType:0];
        }else{
            [SVProgressHUD showErrorWithStatus:@"电子路书路径Json解析失败！"];
        }
    }else if (_cellButtonType == btDownload){
        [ElectronicBookManeger downLoadElectroniBook:self.acticeInfo.rouadBookURL IsSynchronous:NO ModifyTime:self.acticeInfo.roadBookModifyTime];
    }
}

- (IBAction)customButtonClicked:(id)sender {
    [TerminalData phoneCall:self.view PhoneNumber:CUSTOMRSERVICEPHONENUMBER];
}

- (void)viewDidUnload {
    [self setBookButton:nil];
    [self setContentView:nil];
    [self setDetailWebView:nil];
    [self setDonwLoadOrCheckButton:nil];
    [self setCustomButton:nil];
    [self setZanLable:nil];
    [self setShareLable:nil];
    [self setCommentLable:nil];
[super viewDidUnload];
}
@end
