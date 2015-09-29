//
//  DefaultHomeViewController.m
//  ZHMS-PDA
//
//  Created by klbest1 on 13-12-13.
//  Copyright (c) 2013年 Jackson. All rights reserved.
//

#import "DefaultHomeVC.h"
#import "ButtonHelper.h"
#import "SelfTravelVC.h"
#import "Macros.h"
#import "CleanCarVC.h"
#import "BMKMapView.h"
#import "NetManager.h"
#import "CleanCarVC.h"
#import "BaiDuMapView.h"
#import "WebVC.h"
#import "RootTabBarVC.h"

typedef enum{
    convSelfDriveButton = 1000,
    convTraficAgentButton,
    convMyLvTuBangButton,
    convWashButton,
    convGasAndStopButton,
    convAdView,
}ConTag;
@interface DefaultHomeVC ()

@end

@implementation DefaultHomeVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
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
    self.title = @"一级标题";
}

-(void)loadView{
    [self initView: mIsPortait];
}

//初始化数据
-(void)initCommonData{

}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_adInfoArray removeAllObjects];
    [_noticeArray removeAllObjects];
    [_adInfoArray release];
    [_noticeArray release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView: (BOOL) aPortait {
    
    //contentView大小设置
    CGRect vViewRect = CGRectMake(0, 0, mWidth, mHeight);
    UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
    [vContentView setBackgroundColor:[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1]];
    //自驾
    UIButton *vSelfDriveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vSelfDriveButton setTag:convSelfDriveButton];
    //车务代理
    UIButton *vTraficAgentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vTraficAgentButton setTag:convTraficAgentButton];
    //我的旅途邦
    UIButton *vMyLvTuBangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vMyLvTuBangButton setTag:convMyLvTuBangButton];
    //洗车
    UIButton *vWashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vWashButton setTag:convWashButton];
    //车主生活
    UIButton *vGasAndStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vGasAndStopButton setTag:convGasAndStopButton];
    
    [vContentView addSubview:vSelfDriveButton];
    [vContentView addSubview:vTraficAgentButton];
    [vContentView addSubview:vWashButton];
    [vContentView addSubview:vGasAndStopButton];
    [vContentView addSubview:vMyLvTuBangButton];
    
    self.view = vContentView;
    
    [self setViewFrame:aPortait];
    SAFE_ARC_RELEASE(vContentView);
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
            //自驾
            UIButton *vButton = (UIButton *)[self.view viewWithTag:convSelfDriveButton];
            [vButton createButtonWithFrame:CGRectMake(67/2, 110, 248/2, 217/2)
                                     Title:@""
                               NormalImage:[UIImage imageNamed:@"index_diyTour_btn"]
                              HelightImage:[UIImage imageNamed:@"index_diyTour_btn"]
                                    Target:self SELTOR:@selector(selfDriveButtonClicked:)];
            //车务代理
            vButton = (UIButton *)[self.view viewWithTag:convTraficAgentButton];
            [vButton createButtonWithFrame:CGRectMake((67/2+248/2+10) , 110,248/2, 217/2)
                                     Title:@""
                               NormalImage:[UIImage imageNamed:@"index_insurance_btn"]
                              HelightImage:[UIImage imageNamed:@"index_insurance_btn"]
                                    Target:self SELTOR:@selector(traficAgentButtonClicked:)];
            
            //我的旅途邦
            vButton = (UIButton *)[self.view viewWithTag:convMyLvTuBangButton];
            [vButton createButtonWithFrame:CGRectMake(230/2, 110+167/2,90, 90)
                                     Title:@""
                               NormalImage:[UIImage imageNamed:@"index_my_btn"]
                              HelightImage:[UIImage imageNamed:@"index_my_btn"]
                                    Target:self SELTOR:@selector(myLvTuBangButtonClicked:)];
            
            //洗车美容
            vButton = (UIButton *)[self.view viewWithTag:convWashButton];
            [vButton createButtonWithFrame:CGRectMake(67/2, 110+248/2 +5,248/2, 217/2)
                                     Title:@""
                               NormalImage:[UIImage imageNamed:@"index_carWash_btn"]
                              HelightImage:[UIImage imageNamed:@"index_carWash_btn"]
                                    Target:self SELTOR:@selector(washButtonClicked:)];
            
            //车生活
            vButton = (UIButton *)[self.view viewWithTag:convGasAndStopButton];
            [vButton createButtonWithFrame:CGRectMake((67/2+248/2+10) , 110+248/2 +5,248/2, 217/2)
                                     Title:@""
                               NormalImage:[UIImage imageNamed:@"index_life_btn"]
                              HelightImage:[UIImage imageNamed:@"index_life_btn"]
                                    Target:self SELTOR:@selector(driveLifeButtonClicked:)];
            [self addImageAdView];
            [self addNoticeAdView:370];
        }else{
            //自驾
            UIButton *vButton = (UIButton *)[self.view viewWithTag:convSelfDriveButton];
            [vButton createButtonWithFrame:CGRectMake(67/2, 110, 248/2, 217/2)
                                     Title:@""
                               NormalImage:[UIImage imageNamed:@"index_diyTour_btn"]
                              HelightImage:[UIImage imageNamed:@"index_diyTour_btn"]
                                    Target:self SELTOR:@selector(selfDriveButtonClicked:)];
            //车务代理
           vButton = (UIButton *)[self.view viewWithTag:convTraficAgentButton];
           [vButton createButtonWithFrame:CGRectMake((67/2+248/2+10) , 110,248/2, 217/2)
                                    Title:@""
                              NormalImage:[UIImage imageNamed:@"index_insurance_btn"]
                             HelightImage:[UIImage imageNamed:@"index_insurance_btn"]
                                   Target:self SELTOR:@selector(traficAgentButtonClicked:)];
            
            //我的旅途邦
            vButton = (UIButton *)[self.view viewWithTag:convMyLvTuBangButton];
            [vButton createButtonWithFrame:CGRectMake(230/2, 110+167/2,90, 90)
                                     Title:@""
                               NormalImage:[UIImage imageNamed:@"index_my_btn"]
                              HelightImage:[UIImage imageNamed:@"index_my_btn"]
                                    Target:self SELTOR:@selector(myLvTuBangButtonClicked:)];
            
            //洗车美容
            vButton = (UIButton *)[self.view viewWithTag:convWashButton];
            [vButton createButtonWithFrame:CGRectMake(67/2, 110+248/2 +5,248/2, 217/2)
                                        Title:@""
                               NormalImage:[UIImage imageNamed:@"index_carWash_btn"]
                              HelightImage:[UIImage imageNamed:@"index_carWash_btn"]
                                    Target:self SELTOR:@selector(washButtonClicked:)];
            
            //车生活
            vButton = (UIButton *)[self.view viewWithTag:convGasAndStopButton];
            [vButton createButtonWithFrame:CGRectMake((67/2+248/2+10) , 110+248/2 +5,248/2, 217/2)
                                     Title:@""
                               NormalImage:[UIImage imageNamed:@"index_life_btn"]
                              HelightImage:[UIImage imageNamed:@"index_life_btn"]
                                    Target:self SELTOR:@selector(driveLifeButtonClicked:)];
            //添加公告
//            [self addNoticeAdView:310];
            [self addImageAdView];
        }
    }else{
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//------------------------------------------------
-(void)setAdInfoArray:(NSMutableArray *)adInfoArray{
    if (_adInfoArray == Nil) {
        _adInfoArray = [[NSMutableArray alloc] init];
    }
    [_adInfoArray removeAllObjects];
    [_adInfoArray addObjectsFromArray:adInfoArray];
    [self addImageAdView];
}

-(void)setNoticeArray:(NSMutableArray *)noticeArray{
    if (_noticeArray == Nil) {
        _noticeArray = [[NSMutableArray alloc] init];
    }
    [_noticeArray removeAllObjects];
    [_noticeArray addObjectsFromArray:noticeArray];
    //添加公告
    [self addNoticeAdView:370];
}

#pragma mark -  其他辅助功能
-(void)addImageAdView{
    //初始化广告
    UIView *vAdView = [self.view viewWithTag:convAdView];
    if (vAdView) {
        [vAdView removeFromSuperview];
    }
    vAdView = [SGFocusImageFrame setTopAdView:320 Hight:200/2 ImagesArray:self.adInfoArray Delegate:self];
    [self.view addSubview:vAdView];
}

#pragma mark 添加公告栏
-(void)addNoticeAdView:(float)aOriginY{
    if ([self.view viewWithTag:66] != Nil) {
        [[self.view viewWithTag:66] removeFromSuperview];
    }
    //初始化广告view
    AdView *vNoticeAdView = [[AdView alloc] initWithFrame:CGRectMake(0, aOriginY, 320, 80)];
    vNoticeAdView.delegate = self;
    [vNoticeAdView setBackgroundColor:[UIColor whiteColor]];
    //分解公告title
    NSMutableArray *vTitleStrArray = [NSMutableArray array];
    for (NSDictionary *vDic in self.noticeArray) {
        NSString *vNoticeTitle = [vDic objectForKey:@"activityTitle"];
        [vTitleStrArray addObject:vNoticeTitle];
    }
    //添加广告文字介绍
    [vNoticeAdView addAdsFromVertical:vTitleStrArray];
    [vNoticeAdView setTag:66];
    [self.view addSubview:vNoticeAdView];
    SAFE_ARC_RELEASE(vNoticeAdView);
}

#pragma mark Web展示广告
-(void)showWebVC:(NSString *)aURLStr{
    //获取根rootVC
    RootTabBarVC *vVC= (RootTabBarVC *)[ViewControllerManager getBaseViewController:@"RootTabBarVC"];
    //web显示广告链接
    WebVC *vWebVC = [[WebVC alloc] init];
    vWebVC.URLStr = aURLStr;
    //展示VC
    UINavigationController *vNavi = [[UINavigationController alloc] initWithRootViewController:vWebVC];
    [vVC presentModalViewController:vNavi animated:YES];
    SAFE_ARC_RELEASE(vWebVC);
    SAFE_ARC_RELEASE(vNavi);
}

#pragma mark - 其他业务点击事件
#pragma mark 自驾
-(void)selfDriveButtonClicked:(UIButton *)sender{
    //在rootTabBar中切换到自驾页面
    if ([_delegate respondsToSelector:@selector(didChosedSelfDrive:)]) {
        [_delegate didChosedSelfDrive:Nil];
    }
}
#pragma mark 保险车务
-(void)traficAgentButtonClicked:(UIButton *)sender{
    [ViewControllerManager createViewController:@"InsureAndAgentVC"];
    [ViewControllerManager showBaseViewController:@"InsureAndAgentVC" AnimationType:vaDefaultAnimation SubType:0];

}
#pragma mark 我的旅途邦
-(void)myLvTuBangButtonClicked:(id)sender{
    //在rootTabBar中切换到我的旅途邦页面
    if ([_delegate respondsToSelector:@selector(didChosedSelfDrive:)]) {
        [_delegate didChosedMyLvtuBang:Nil];
    }
}
#pragma mark 点击洗车
-(void)washButtonClicked:(UIButton *)sender{
    [ViewControllerManager createViewController:@"CleanCarVC"];
    [ViewControllerManager showBaseViewController:@"CleanCarVC" AnimationType:vaDefaultAnimation SubType:0];
    CleanCarVC *vVC = (CleanCarVC *)[ViewControllerManager getBaseViewController:@"CleanCarVC"];
    [vVC typeSelected:stWash_Consmetology BunessName:Nil];
}
#pragma mark 点击车生活
-(void)driveLifeButtonClicked:(UIButton *)sender{
    [ViewControllerManager createViewController:@"DriverLifeVC"];
    [ViewControllerManager showBaseViewController:@"DriverLifeVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 点击轮播图片
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    LOG(@"%s \n click===>%@",__FUNCTION__,item.title);
    NSString *vImageURLStr = item.outURLStr;
    LOG(@"点击广告图片URL:%@",vImageURLStr);
    if (vImageURLStr.length > 0) {
        [self showWebVC:vImageURLStr];
    }
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
//    LOG(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
}

#pragma mark AdViewDelegate
#pragma mark 点击轮播公告
-(void)didAdViewClicked:(id)sender{
    LOG(@"广告点击了：第%@个广告",sender);
    NSDictionary *vDic = [self.noticeArray objectAtIndex:[sender intValue]];
    NSString *vURLStr = [vDic objectForKey:@"hrefLocation"];
    LOG(@"点击公告URL:%@",vURLStr);
    IFISNIL(vURLStr);
    if (vURLStr.length > 0) {
        [self showWebVC:vURLStr];
    }
}
@end
