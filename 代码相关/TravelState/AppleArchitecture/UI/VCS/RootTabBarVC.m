//
//  RootViewController.m
//  CarServices
//
//  Created by klbest1 on 14-1-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RootTabBarVC.h"
#import "MyLvTuBangVC.h"
#import "AgentBunessVC.h"
#import "ShoppingCartVC.h"
#import "MyLvTuBangVC.h"
#import "ARCMacros.h"
#import "UserManager.h"
#import "NetManager.h"
#import "HttpDefine.h"
#import "ActivityRouteManeger.h"
#import "AnimationTransition.h"
#import "LvTuBangSettingVC.h"

@interface RootTabBarVC (){
    CustomTabBarController *mCustomTabBarVC;
    DefaultHomeVC  *mDefaultHomeVC;  //首页
    SelfTravelVC  *mSelfTravelVC;  //自驾
    ShoppingCartVC     *mShoppingCartVC;  //购物车
    MyLvTuBangVC     *mMyLvTangVC;   //我的旅途邦
    AgentBunessVC  *mAgentBunessVC; //车务代理
    UIImageView *mArrowDownImageView;  //向下箭头 imageView
    UIImageView *mPhoneImageView;   //客服电话imageView
    UIButton *mSelfDriveMiddleButton;  //自驾选择城市button
    UIButton *mHomeCityButton;        //首页选择城市button
    ChoseProvinceVC *mChosePlaceVC;
}
@end

@implementation RootTabBarVC
@synthesize selfDriveVC = mSelfTravelVC;
@synthesize myLvTuBang = mMyLvTangVC;

- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
        [self initCommonData];
    }
    return self;
}
// 主要是用来方向改变后，重新布局
- (void) setLayout: (BOOL) aPortait {
    [super setLayout: aPortait];
}

-(void)initTopNavBar{
    [super initTopNavBar];
}

-(void)loadView{
    [self initView: mIsPortait];
}

-(void)initCommonData{

}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mShoppingCartVC release];
    [mSelfTravelVC release];
    [mSelfDriveMiddleButton release];
    [mHomeCityButton release];
    [mCustomTabBarVC release];
    [mArrowDownImageView release];
    [mPhoneImageView release];
    [mSelfTravelVC release];
    [mDefaultHomeVC release];
    [super dealloc];
}
#endif

-(void)viewShouldUnLoad{
//    mDefaultHomeVC.view = Nil; //首页
//    mSelfTravelVC =Nil;  //自驾
//    mShoppingCartVC = Nil;  //购物车
//    mMyLvTangVC.view = Nil;   //我的旅途邦
//    mAgentBunessVC = Nil; //车务代理
    mSelfTravelVC.view = Nil;
    mDefaultHomeVC.view = Nil;
    [super viewShouldUnLoad];
}

// 初始经Frame
- (void) initView: (BOOL) aPortait {
  if (IS_IOS7)
     self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    //contentView大小设置
    CGRect vViewRect = CGRectMake(0, 0, mWidth, mHeight);
    UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
	// Do any additional setup after loading the view.
    if (mDefaultHomeVC == nil) {
        mDefaultHomeVC = [[DefaultHomeVC alloc] init];
        mDefaultHomeVC.delegate = self;

    }
    if (mSelfTravelVC == nil) {
        mSelfTravelVC = [[SelfTravelVC alloc] init];
    }
    if (mAgentBunessVC == nil) {
        mAgentBunessVC = [[AgentBunessVC alloc] init];
        mAgentBunessVC.isSearchType = YES;
    }
    if (mShoppingCartVC == nil) {
        mShoppingCartVC = [[ShoppingCartVC alloc] init];
    }
    
    if (mMyLvTangVC == nil) {
        mMyLvTangVC = [[MyLvTuBangVC alloc] init];
    }
    NSArray *vVCArray = [NSArray arrayWithObjects:mDefaultHomeVC,mSelfTravelVC,mAgentBunessVC,mShoppingCartVC,mMyLvTangVC, nil];

    
    //构造tabbar的按钮图片array
    NSMutableDictionary *imgDict1 = [NSMutableDictionary dictionaryWithCapacity:3];
    //首页
    [imgDict1 setObject:[UIImage imageNamed:@"index_footIndex_btn_default"] forKey:@"Default"];
    [imgDict1 setObject:[UIImage imageNamed:@"index_footIndex_btn_select"] forKey:@"Highlighted"];
    [imgDict1 setObject:[UIImage imageNamed:@"index_footIndex_btn_select"] forKey:@"Selected"];
    //电子领队
    NSMutableDictionary *imgDict2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDict2 setObject:[UIImage imageNamed:@"index_footLeader_btn_default"] forKey:@"Default"];
    [imgDict2 setObject:[UIImage imageNamed:@"index_footLeader_btn_select"] forKey:@"Highlighted"];
    [imgDict2 setObject:[UIImage imageNamed:@"index_footLeader_btn_select"] forKey:@"Selected"];
    //保险车务
    NSMutableDictionary *imgDict3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDict3 setObject:[UIImage imageNamed:@"index_search_btn_default"] forKey:@"Default"];
    [imgDict3 setObject:[UIImage imageNamed:@"index_search_btn_select"] forKey:@"Highlighted"];
    [imgDict3 setObject:[UIImage imageNamed:@"index_search_btn_select"] forKey:@"Selected"];
    //购物车
    NSMutableDictionary *imgDict4 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDict4 setObject:[UIImage imageNamed:@"index_footCart_btn_default"] forKey:@"Default"];
    [imgDict4 setObject:[UIImage imageNamed:@"index_footCart_btn_select"] forKey:@"Highlighted"];
    [imgDict4 setObject:[UIImage imageNamed:@"index_footCart_btn_select"] forKey:@"Selected"];
    //我的
    NSMutableDictionary *imgDict5 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDict5 setObject:[UIImage imageNamed:@"index_footMy_btn_default"] forKey:@"Default"];
    [imgDict5 setObject:[UIImage imageNamed:@"index_footMy_btn_select"] forKey:@"Highlighted"];
    [imgDict5 setObject:[UIImage imageNamed:@"index_footMy_btn_select"] forKey:@"Selected"];
    
    NSArray *barImgsArr = [NSArray arrayWithObjects:imgDict1, imgDict2, imgDict3, imgDict4, imgDict5, nil];
    
    if (mCustomTabBarVC == Nil) {
        mCustomTabBarVC = [[CustomTabBarController alloc] initWithViewControllers:vVCArray imageArray:barImgsArr];
        mCustomTabBarVC.delegate = self;
        [mCustomTabBarVC.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_bg.png"]];
        [mCustomTabBarVC setTabBarTransparent:NO];
        [mCustomTabBarVC.view setFrame:CGRectMake(0, 0, mWidth, mHeight)];
    }
    [mCustomTabBarVC changeViewControllerAtIndex:mCustomTabBarVC.selectedIndex];
    [vContentView addSubview:mCustomTabBarVC.view];
    
    self.view = vContentView;
    
    SAFE_ARC_RELEASE(vContentView);
    vContentView = nil;
    SAFE_ARC_RELEASE(vTraficAgentVC);
    SAFE_ARC_RELEASE(vMyLvTangVC);
    
    BOOL vIsEverLanched = [[NSUserDefaults standardUserDefaults] boolForKey:@"isEverLanched"];
    if (!vIsEverLanched) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isEverLanched"];
        WelcomeVC *vWelcomeVC = [[WelcomeVC alloc] init];
        vWelcomeVC.delegate = self;
        [self presentModalViewController:vWelcomeVC animated:YES];
        SAFE_ARC_AUTORELEASE(vWelcomeVC);
    }else{
        [self runThings];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (mCustomTabBarVC.selectedIndex == 4) {
        [mMyLvTangVC viewWillAppear:animated];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark CustomTabBarControllerDelegate
- (BOOL)tabBarController:(CustomTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
     if (![viewController isKindOfClass:[DefaultHomeVC class]]) {
         [self removeChosePlaceVC];
     }
    return YES;
}
- (void)tabBarController:(CustomTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    self.navigationItem.rightBarButtonItem = Nil;
    self.navigationItem.leftBarButtonItem = Nil;
    if ([viewController isKindOfClass:[DefaultHomeVC class]]) {
        [self setHomeNaviBar];
    }else if([viewController isKindOfClass:[SelfTravelVC class]]){
        [self setSelfDriveNavi];
    }else if([viewController isKindOfClass:[AgentBunessVC class]]){
        self.title = @"商家搜索";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.titleView = Nil;
    }else if([viewController isKindOfClass:[ShoppingCartVC class]]){
        self.title = @"购物车";
        self.navigationItem.titleView = Nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }else if([viewController isKindOfClass:[MyLvTuBangVC class]]){
        [self reSetMylvTuBangNaviBar];
    }
}

#pragma mark WelcomeVCDelegate
#pragma mark 欢迎页面使用完毕
-(void)didWelcomeVCDismissed:(id)sender{
    [self runThings];
}

#pragma mark - BaiDuMapViewDelegate
//百度地图定位成功
-(void)baiDuMapDidUpdateUserLocationSucces:(BMKMapView *)mapView UserLocation:(BMKUserLocation *)userLocation{
    //关闭百度定位
    [self startWaitingAnimation:@"正在初始化数据..."];
    //初始化网络数据
    [self initApplicationWebDatas];
    //关闭提示信息
    [self stopWaitingAnimation];
}
//百度地图定位失败
-(void)baiDuMapDidFailToLocateUserLocation:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [self startWaitingAnimation:@"正在初始化数据..."];
    //初始化网络数据
    [self initApplicationWebDatas];
    [self stopWaitingAnimation];
}

#pragma mark - 其他功能函数

-(void)runThings{
    //定位用户位置
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [BaiDuMapView shareBaiDuMapView];
        [BaiDuMapView shareBaiDuMapView].delegate = self;
    });
    [self startWaitingAnimation:@"正在定位您的位置,请稍等..."];
}

#pragma mark 获取购物车，活动路书等网络数据
-(void)initApplicationWebDatas{
    //程序初始化
    [[TerminalData instanceTerminalData] applicationInit];
    //初始化首页导航条中得地址
    [self setHomeNaviBar];
    //获取首页轮播图片广告
    [self getAdImagesFromWeb:1];
    //获取首页轮播通告告
    [self getAdImagesFromWeb:2];
}

-(void)reSetMylvTuBangNaviBar{
    if (mCustomTabBarVC.selectedViewController == mMyLvTangVC) {
        
        if ([UserManager isLogin]) {
            self.title = @"我的";
            self.navigationItem.titleView = Nil;
            
            UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vRightButton setTitle:@"退出" forState:UIControlStateNormal];
            
            [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
            [vRightButton addTarget:self action:@selector(resignButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
            if ([UserManager isLogin]) {
                [vRightButton setTitle:@"注销" forState:UIControlStateNormal];
            }
            self.navigationItem.rightBarButtonItem = vBarButtonItem;
            
            UIButton *vCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vCancleButton setBackgroundImage:[UIImage imageNamed:@"myLTB_menu_btn_default"] forState:UIControlStateNormal];
            [vCancleButton setBackgroundImage:[UIImage imageNamed:@"myLTB_menu_btn_select"] forState:UIControlStateHighlighted];
            [vCancleButton setFrame:CGRectMake(0, 0, 22, 18)];
            [vCancleButton addTarget:self action:@selector(lvtuBangSettingButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
            vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vCancleButton];
            self.navigationItem.leftBarButtonItem = vBarButtonItem;
            
            SAFE_ARC_RELEASE(vBarButtonItem);
        }else{
            UIButton *vCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vCancleButton setBackgroundImage:[UIImage imageNamed:@"myLTB_menu_btn_default"] forState:UIControlStateNormal];
            [vCancleButton setBackgroundImage:[UIImage imageNamed:@"myLTB_menu_btn_select"] forState:UIControlStateHighlighted];
            [vCancleButton setFrame:CGRectMake(0, 0, 22, 18)];
            [vCancleButton addTarget:self action:@selector(lvtuBangSettingButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vCancleButton];
            self.navigationItem.leftBarButtonItem = vBarButtonItem;
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.titleView = Nil;
            self.title = @"我的旅途邦";
        }
    }
}

-(void)setHomeNaviBar{
    if (mCustomTabBarVC.selectedViewController == mDefaultHomeVC) {
        
        //设置title
        self.title = @"旅途邦";
        self.navigationItem.titleView = Nil;
        //左边选择城市按钮
        //获取省名
        NSString *vProvinceStr = [[[ActivityRouteManeger shareActivityManeger].chosedPlaceDic objectForKey:@"province"] objectForKey:@"name"];
        if (vProvinceStr.length== 0) {
            vProvinceStr = [ActivityRouteManeger getProvinceName];
        }
        IFISNIL(vProvinceStr);
        //初始化左边省市按钮，使其全局以便更改title
        mHomeCityButton = [[UIButton alloc] init];
        [mHomeCityButton setBackgroundColor:[UIColor clearColor]];
        [mHomeCityButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [mHomeCityButton setTitle:vProvinceStr forState:UIControlStateNormal];
        [mHomeCityButton setFrame:CGRectMake(0, 0, 40, 44)];
        [mHomeCityButton addTarget:self action:@selector(changePlaceButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mHomeCityButton];
        self.navigationItem.leftBarButtonItem = vBarButtonItem;
        //右边客服按钮
        UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vRightButton setTitle:@"客服" forState:UIControlStateNormal];
        [vRightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
        [vRightButton addTarget:self action:@selector(custormSeriviceButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
        self.navigationItem.rightBarButtonItem = vBarButtonItem;
        //添加向下箭头图片
        if (mArrowDownImageView == Nil) {
            mArrowDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 14, 17, 17)];
            [mArrowDownImageView setImage:[UIImage imageNamed:@"index_arrowDown_btn.png"]];
        }
        [mHomeCityButton addSubview:mArrowDownImageView];
        //添加客服电话图片
        if (mPhoneImageView == Nil) {
            mPhoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-17, 14, 17, 17)];
            [mPhoneImageView setImage:[UIImage imageNamed:@"index_phone_btn.png"]];
        }
        [vRightButton addSubview:mPhoneImageView];
    }
}

-(void)setSelfDriveNavi{
    if (mCustomTabBarVC.selectedViewController == mSelfTravelVC) {
        
        //设置自驾title
        //获取省名
        NSString *vProvinceStr = [[[ActivityRouteManeger shareActivityManeger].chosedPlaceDic objectForKey:@"province"] objectForKey:@"name"];
        if (vProvinceStr.length == 0) {
            vProvinceStr = [ActivityRouteManeger getProvinceName];
        }
        IFISNIL(vProvinceStr);
        //设置中间的title为当前选择省名
        mSelfDriveMiddleButton = [[UIButton alloc] init];
        [mSelfDriveMiddleButton setBackgroundColor:[UIColor clearColor]];
        [mSelfDriveMiddleButton setTitle:vProvinceStr forState:UIControlStateNormal];
        [mSelfDriveMiddleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        mSelfDriveMiddleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0];
        [mSelfDriveMiddleButton setFrame:CGRectMake(0, 0, 40, 44)];
        [mSelfDriveMiddleButton addTarget:self action:@selector(selfDriveTitleButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = mSelfDriveMiddleButton;
        //添加向下的箭头
        if (mArrowDownImageView == Nil) {
            mArrowDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 14, 17, 17)];
            [mArrowDownImageView setImage:[UIImage imageNamed:@"index_arrowDown_btn.png"]];
        }
        [mSelfDriveMiddleButton addSubview:mArrowDownImageView];
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = Nil;
    }
}

#pragma mark 隐藏购物车导航条部分设置
-(void)hideShopingCarNavi{
    if (mCustomTabBarVC.selectedViewController == mShoppingCartVC) {
        self.title = @"购物车";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.titleView = nil;
    }
}
#pragma mark 设置购物车导航条
-(void)setShoppingCarNavi{
    if (mCustomTabBarVC.selectedViewController == mShoppingCartVC) {
        
        self.title= @"购物车";
        self.navigationItem.titleView = Nil;
        
        UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vRightButton setTitle:@"确认订单" forState:UIControlStateNormal];
        [vRightButton setFrame:CGRectMake(0, 0, 80, 44)];
        [vRightButton addTarget:self action:@selector(payMentButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
        self.navigationItem.rightBarButtonItem = vBarButtonItem;
        
        UIButton *vEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vEditButton setTitle:@"编辑" forState:UIControlStateNormal];
        [vEditButton setFrame:CGRectMake(0, 0, 40, 44)];
        [vEditButton addTarget:self action:@selector(shoppingCartEditButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vEditButton];
        self.navigationItem.leftBarButtonItem = vBarButtonItem;
        
        SAFE_ARC_RELEASE(vBarButtonItem);
    }
}

#pragma mark 选择省

-(void)setPlaceUI{
    [mChosePlaceVC.view setFrame:CGRectMake(0, 0, 320, 480-64-49)];
    if (IS_IPHONE_5) {
        [mChosePlaceVC.view setFrame:CGRectMake(0, 0, 320, 480-30)];
    }
    [mChosePlaceVC.view setTag:1111];
    //显示地区
    [self.view addSubview:mChosePlaceVC.view];
    //设置动画
    [UIView animateChangeView:mChosePlaceVC.view AnimationType:vaMoveIn SubType:vsFromBottom Duration:.2 CompletionBlock:Nil];
}

-(void)goToChosePlaceVC{
    UIView *vView = [self.view viewWithTag:1111];
    if (vView == Nil) {
        //添加页面
        if (mChosePlaceVC == Nil) {
            mChosePlaceVC = [[ChoseProvinceVC alloc] init];
            mChosePlaceVC.delegate = self;
            
            //拼接地区请求参数
            NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"type",[NSNumber numberWithInt:0],@"id",nil];
            //请求数据
            [NetManager postDataFromWebAsynchronous:APPURL103 Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
                NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
                NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
                //解析数据
                NSMutableArray *vDataArray = [NSMutableArray array];
                for (NSDictionary *vDic in vDataDic) {
                    [vDataArray addObject:vDic];
                }
                if (vDataArray.count >0) {
                    mChosePlaceVC.placeArray = vDataArray;
                    [self setPlaceUI];
                }

        } Failure:^(NSURLResponse *response, NSError *error) {
            
        } RequestName:@"获取省" Notice:@""];
    }else{
        [self setPlaceUI];
    }
    }else{
        //设置动画
        [UIView moveToView:vView DestRect:CGRectMake(0, -200, 320, 300) OriginRect:vView.frame duration:.2 IsRemove:YES Completion:Nil];
    }
}


#pragma mark 获取广告图片或公告
-(void )getAdImagesFromWeb:(NSInteger)aType{
    //获取省市区ID
    //获取省ID
    NSNumber *vProvinceID = [[[ActivityRouteManeger shareActivityManeger ].chosedPlaceDic objectForKey:@"province"] objectForKey:@"id"];
    LOG(@"选择的省是:%@",[[[ActivityRouteManeger shareActivityManeger ].chosedPlaceDic objectForKey:@"province"] objectForKey:@"name"]);
    vProvinceID = vProvinceID != Nil? vProvinceID : [NSNumber numberWithInt:0];
    //获取市ID
    NSNumber *vCityID = [[[ActivityRouteManeger shareActivityManeger ].chosedPlaceDic objectForKey:@"city"] objectForKey:@"id"];
    vCityID = vCityID != Nil ? vCityID :[NSNumber numberWithInt:0];
    //获取区域id
    NSNumber *vDistrictID = [[[ActivityRouteManeger shareActivityManeger ].chosedPlaceDic objectForKey:@"district"] objectForKey:@"id"];
    vDistrictID = vDistrictID != Nil ? vDistrictID : [NSNumber numberWithInt:0];
    //拼接图片请求参数
    NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   vProvinceID,@"provinceId",
                                   vCityID,@"cityId",
                                   vDistrictID,@"districtId",nil];
    NSString *vWebURL = @"";
    NSString *vRequestName = @"";
    //aType = 1，请求广告图片， aType = 2，请求通告
    if (aType == 1) {
        vWebURL = APPURL301 ;
        vRequestName = @"请求广告图片";
    }else{
        vWebURL = APPURL499;
        vRequestName = @"请求通告";
    }
    //请求网络数据
    [NetManager postDataFromWebAsynchronous:vWebURL Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vDataArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDataDic) {
            [vDataArray addObject:vDic];
        }
        if (aType == 1) {
            mDefaultHomeVC.adInfoArray = vDataArray;
        }else{
            mDefaultHomeVC.noticeArray = vDataArray;
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:vRequestName Notice:Nil];
}

#pragma mark 移除选择地区页面
-(void)removeChosePlaceVC{
    UIView *vView = [self.view viewWithTag:1111];
    if (vView != Nil) {
        [vView removeFromSuperview];
    }
}

#pragma mark - 其他业务点击事件
-(void)resignButtonTouchDown:(id)sender{
    //注销
    if ([UserManager isLogin]) {
        [UserManager unLogin];
        //添加未登录页面
        [mMyLvTangVC addUnLoginVC];
        //刷新自驾数据
        [mSelfTravelVC initSelfDriveData];
    }
}

#pragma mark DefaultHomeDelegate
#pragma mark 选择则我的旅途邦
-(void)didChosedMyLvtuBang:(id)sender{
    [mCustomTabBarVC changeViewControllerAtIndex:4];
}
#pragma mark 选择自驾
-(void)didChosedSelfDrive:(id)sender{
    [mCustomTabBarVC changeViewControllerAtIndex:1];
}
#pragma mark 车务代理
-(void)didChosedInsureAndAgent:(id)sender{
    [mCustomTabBarVC changeViewControllerAtIndex:2];
}

#pragma mark 点击选择地区
-(void)changePlaceButtonTouchDown:(id)sender{
    [self goToChosePlaceVC];
}

#pragma mark 点击客服
-(void)custormSeriviceButtonTouchDown:(id)sender{
    [TerminalData phoneCall:self.view PhoneNumber:CUSTOMRSERVICEPHONENUMBER];
}

#pragma mark 自驾选择省
-(void)selfDriveTitleButtonTouchDown:(id)sender{
    [self goToChosePlaceVC];
}

#pragma mark 省选择完毕
-(void)didChoseProvinceFinished:(id)sender{
    //重新组装选择的地区字典省的key:province 市的key:city
    NSDictionary *vPlaceDic = [NSDictionary dictionaryWithObjectsAndKeys:sender,@"province", nil];
    //尝试获取新的字典中能否获取选择的省名
    NSString *vProvinceName = [[vPlaceDic objectForKey:@"province"] objectForKey:@"name"];
    //改变home左边地区按钮当前省
    [mHomeCityButton setTitle:vProvinceName forState:UIControlStateNormal];
    //改变自驾title当前的省名
    [mSelfDriveMiddleButton setTitle:vProvinceName forState:UIControlStateNormal];
    //保存选择好的省信息
    [ActivityRouteManeger shareActivityManeger].chosedPlaceDic = vPlaceDic;
    UIView *vView = [self.view viewWithTag:1111];
    //移除掉加载的选择省得列表
    [UIView animateChangeView:vView AnimationType:vaMoveIn SubType:vsFromTop Duration:.2 CompletionBlock:^{
        [vView removeFromSuperview];
        //重新初始化自驾数据
        [mSelfTravelVC initSelfDriveData];
        //获取首页轮播图片广告
        [self getAdImagesFromWeb:1];
        //获取首页轮播通告告
        [self getAdImagesFromWeb:2];
    }];
}

#pragma mark 选择旅途邦设置
-(void)lvtuBangSettingButtonTouchDown:(id)sender{
    [ViewControllerManager createViewController:@"LvTuBangSettingVC"];
    [ViewControllerManager showBaseViewController:@"LvTuBangSettingVC" AnimationType:vaPush SubType:vsFromTop];
}

#pragma mark 购物车编辑
-(void)shoppingCartEditButtonTouchDown:(UIButton *)sender{
    BOOL isEdit = [mShoppingCartVC editButtonTouchDown];
    if (isEdit) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

#pragma mark 购物车去结算
-(void)payMentButtonTouchDown:(UIButton *)sender{
    [mShoppingCartVC closeAcountTouchDown];
}

@end
