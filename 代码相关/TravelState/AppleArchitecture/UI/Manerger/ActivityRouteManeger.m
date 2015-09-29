//
//  ActivityRouteManeger.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-2.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ActivityRouteManeger.h"
#import <ShareSDK/ShareSDK.h>
#import "UserManager.h"
#import "SelfTravelVC.h"
#import "ActiveDetailVC.h"
#import "RootTabBarVC.h"
#import "ActiveCommentVC.h"
#import "Macros.h"
#import "MyRoutesVC.h"
#import "OrderCommentVC.h"

static ActivityRouteManeger *sShareActivityRouteManeger = Nil;

@implementation ActivityRouteManeger
@synthesize chosedPlaceDic = _chosedPlaceDic;

+ (ActivityRouteManeger *) shareActivityManeger {
	@synchronized(self) {
		if (sShareActivityRouteManeger == nil) {
#if __has_feature(objc_arc)
            sShareActivityRouteManeger = [[ActivityRouteManeger alloc] init];
#else
            sShareActivityRouteManeger = [NSAllocateObject([self class], 0 , NULL) init];
#endif
		}
		return sShareActivityRouteManeger;
	}
}

#if __has_feature(objc_arc)
#else
// 每一次alloc都必须经过allocWithZone方法，覆盖allWithZone方法，
// 每次alloc都必须经过Instance方法，这样能够保证肯定只有一个实例化的对象
+ (id) allocWithZone: (NSZone *)zone {
    return [[self shareActivityManeger] SAFE_ARC_PROP_RETAIN];
}

// 覆盖copyWithZone方法可以保证克隆时还是同一个实例化的对象广告
+ (id) copyWithZone: (NSZone *)zone {
    return self;
}

- (id) retain {
    return self;
}

// 以下三个函数retainCount，release，autorelease保证了实例不被释放
- (NSUInteger) retainCount {
    return NSUIntegerMax;
}

- (oneway void) release {
    
}

- (id) autorelease {
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_chosedPlaceDic release];
    [_bookPeopleDic removeAllObjects];[_bookPeopleDic release];
    [super dealloc];
}

#endif

- (id) init {
	self = [super init];
	if (self != nil) {
        self.BookPeopleDic = [[NSMutableDictionary alloc] init];
        self.naviManeger = [[BaiDuNaviManeger alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPaysuccess:) name:@"didPaysuccess" object:nil];

	}
	return self;
}
//用户选择好地区后调用此方法
- (void)setChosedPlaceDic:(NSDictionary *)chosedPlaceDic{
    _chosedPlaceDic = [[NSDictionary alloc] initWithDictionary:chosedPlaceDic];
}

-(NSDictionary *)chosedPlaceDic{
    //用户没选择地区时，默认为初始化服务器传来的省市区ID
    if (_chosedPlaceDic == Nil) {
    }
    return _chosedPlaceDic;
}

-(CLLocationCoordinate2D )userChosedBunessCoord{
    //用户选择的商家坐标初始化为用户本人所在坐标,当用户选择了商家后为商家坐标
    if (_userChosedBunessCoord.latitude <= 0) {
        _userChosedBunessCoord = [UserManager instanceUserManager].userCoord;
    }
    return _userChosedBunessCoord;
}

#pragma mark 获取初始化时的省名
+ (NSString *)getProvinceName{
    NSDictionary *vProvinceDic = [[TerminalData instanceTerminalData].applicationInitDic objectForKey:@"agentProvince"];
    NSString *vProvinceStr = Nil;
    for (NSDictionary *vDic in vProvinceDic) {
        vProvinceStr = [vDic objectForKey:@"name"];
        break;
    }
    return vProvinceStr;
}

+ (void)postSharePraseCommentData:(NSString *)aURL Paremeter:(NSDictionary *)aDic Prompt:(NSString *)aPrompt RequestName:(NSString *)aName{
    [NetManager postDataFromWebAsynchronous:aURL Paremeter:aDic Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        NSString *vReturnMessage = [vReturnDic objectForKey:@"stateMessage"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                id vActivityID = [aDic objectForKey:@"activityId"];
                //刷新活动数据显示
                [ActivityRouteManeger refreshActiveData:vActivityID];
                [SVProgressHUD showSuccessWithStatus:vReturnMessage];
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:vReturnMessage];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:aName Notice:@""] ;
}

#pragma mark 显示分享
+ (void)showShare:(NSString *)aTitle Content:(NSString *)aContent Paremeter:(NSMutableDictionary *)aParemeter ShareType:(ShareContentType)aType{
    id vUserID = [UserManager instanceUserManager].userID;
    aParemeter = [aParemeter mutableCopy];
    [aParemeter setObject:vUserID forKey:@"userId"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:aContent
                                       defaultContent:@"邦"
                                                image:Nil
                                                title:aTitle
                                                  url:@"www.hnqlhr.com"
                                          description:@"分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                            {
                                    LOG(@"分享成功");
                                    if (aType == stActivity) {
                                        [ActivityRouteManeger postSharePraseCommentData:APPURL404 Paremeter:aParemeter Prompt:@"" RequestName:@"请求分享"];
                                    }
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    LOG(@"分享失败");
                                    LOG(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){
                                    LOG(@"分享取消");
                                }
                                //界面有bug设置个通知调整下
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"shareDidCancle" object:Nil];
                            }];
}

#pragma mark 添加星级
+ (void)addStarsToView:(UIView *)aView StarNumber:(NSInteger)aStarNumber{
    for (NSInteger i = 0 ; i < aStarNumber; i++) {
        UIImageView *vStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((13+2.5)*i, 0, 13, 13)];
        [vStarImageView setImage:[UIImage imageNamed:@"saler_star_btn_select"]];
        [aView addSubview:vStarImageView];
        SAFE_ARC_RELEASE(vStarImageView);
    }
    
    for (NSInteger j = aStarNumber; j < 5; j++) {
        UIImageView *vStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((13+2.5)*j, 0, 13, 13)];
        [vStarImageView setImage:[UIImage imageNamed:@"saler_star_btn_default"]];
        [aView addSubview:vStarImageView];
        SAFE_ARC_RELEASE(vStarImageView);
    }
}
#pragma mark 调用百度地图
+(void)gotoBaiMapApp:(CLLocationCoordinate2D )aStart EndLocation:(CLLocationCoordinate2D)aEnd{
//    NSString *baiDuAppURLStr =[NSString stringWithFormat:@"baidumap://map/direction?origin=%lf,%lf&destination=%lf,%lf&mode=driving&src=lvtubang",aStart.latitude,aStart.longitude,aEnd.latitude,aEnd.longitude];
//    LOG(@"调用百度地图应用URL:%@",baiDuAppURLStr);
//    NSURL *myURL = [NSURL URLWithString:baiDuAppURLStr];
//    BOOL vIsOpenSucces = [[UIApplication sharedApplication] openURL:myURL];
//    if (!vIsOpenSucces) {
//        UIAlertView *vAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请安装百度地图!" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
//        [vAlertView show];
//        vAlertView = Nil;
//        SAFE_ARC_RELEASE(vAlertView);
//    }
    
    [[ActivityRouteManeger shareActivityManeger].naviManeger startNavi:aStart EndLocation:aEnd ];
}

#pragma mark 检查用户是否登录
+(BOOL)checkIfIsLogin{
    id vUserInfo = [UserManager instanceUserManager].userInfo;
    if (vUserInfo == Nil) {
        LOG(@"没有登录，调用登录界面！");
        [ViewControllerManager createViewController:@"LoginVC"];
        [ViewControllerManager showBaseViewController:@"LoginVC" AnimationType:vaDefaultAnimation SubType:0];
        //设置LoginVC代理，登录成功后改变我的旅途邦为登录后页面
        LoginVC *vLoginVC = (LoginVC *)[ViewControllerManager getBaseViewController:@"LoginVC"];
        vLoginVC.isSelectedView = NO;
        RootTabBarVC *vRootTabBarVC = (RootTabBarVC *)[ViewControllerManager getBaseViewController:@"RootTabBarVC"];
        vLoginVC.delegate =  vRootTabBarVC.myLvTuBang;
        return NO;
    }
    return YES;
}

#pragma mark 更新赞，分享，评价的数量显示
+ (void)refreshActiveData:(id)aActivityID{
    id userId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:aActivityID,@"activityId",userId,@"userId", nil];
    [NetManager postDataFromWebAsynchronous:APPURL402 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            SelfTravelVC *vVC = [[SelfTravelVC alloc] init];
            ActiveInfo *vInfo = [vVC analyzeActivityDic:vDataDic];
            //通知刷新该项活动评论等数量的显示
            [self changeSharePraseCommentUI:vInfo];
            SAFE_ARC_RELEASE(vVC);
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求活动详情" Notice:Nil];
}

#pragma mark 刷新和赞分享，评论相关的UI页面
+(void)changeSharePraseCommentUI:(ActiveInfo *)aInfo{
    //获取根SelfDriveVC
    RootTabBarVC *vRootVC= (RootTabBarVC *)[ViewControllerManager getBaseViewController:@"RootTabBarVC"];
    //刷新活动路书界面
    [vRootVC.selfDriveVC reloadActiveDataOnRow:aInfo];
    //刷新活动详情界面
    ActiveDetailVC *vDetailVC = (ActiveDetailVC *)[ViewControllerManager getBaseViewController:@"ActiveDetailVC"];
    [vDetailVC setLableCount:aInfo];
    //刷新评论数据
    ActiveCommentVC *vCommentVC = (ActiveCommentVC *)[ViewControllerManager getBaseViewController:@"ActiveCommentVC"];
    [vCommentVC refreshUI];
    //我的行程
    MyRoutesVC *vMyRoutesVC =(MyRoutesVC *)[ViewControllerManager getBaseViewController:@"MyRoutesVC"];
    [vMyRoutesVC refreshWebData];
    
}

#pragma mark 刷新和订单相关的页面
+(void)refreshPayRelatedUI{
    OrderCommentVC *vVC = [[OrderCommentVC alloc] init];
    [vVC refreshOderStuff];
    vVC = nil;
    [ActivityRouteManeger refreshPersonalInfoRelateUI:NO];
}

#pragma mark 刷新和个人资料相关的东西，如途币
+(void)refreshPersonalInfoRelateUI:(BOOL)aIsNeedBack{
    [UserManager checkIfIsAutoLoginWithCompletionBlock:^{
        RootTabBarVC *vVC = (RootTabBarVC *)[ViewControllerManager getBaseViewController:@"RootTabBarVC"];
        if (aIsNeedBack) {
            [ViewControllerManager backViewController:vaDefaultAnimation SubType:0];
        }
        [vVC.myLvTuBang setUI];
    }];
}

#pragma mark 支付成功的通知
-(void)didPaysuccess:(NSNotification *)aNoti{
    [ActivityRouteManeger refreshPersonalInfoRelateUI:YES];
}

@end
