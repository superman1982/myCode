//
//  DriveFriendsVC.m
//  CarServices
//
//  Created by klbest1 on 14-1-23.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "CleanCarVC.h"
#import "ConstDef.h"
#import "NetManager.h"
#import "HttpDefine.h"
#import "NearByBuinessMapVC.h"
#import "AnimationTransition.h"
#import "AgentBunessVC.h"

@interface CleanCarVC ()
{
    CleanCarView *mCleanCarView;
    BunessDetailMapVC *mNearByMapVC;
    UIButton    *mMiddleButton;
    ServiceTypeTableVC *mServiceTypeVC ;
}

@property (nonatomic,assign) BOOL isMapSelected;
@property (nonatomic,assign)  SearchType searchType;      //当前搜索类型

@end

@implementation CleanCarVC

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
    self.title = @"洗车";
    //初始化服务类型按钮，使其全局以便更改title
    mMiddleButton = [[UIButton alloc] init];
    [mMiddleButton setBackgroundColor:[UIColor clearColor]];
    [mMiddleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [mMiddleButton setFrame:CGRectMake(0, 0, 40, 44)];
    [mMiddleButton addTarget:self action:@selector(changeServiceTypeButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    mMiddleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0];
    UIImageView *mArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 14, 17, 17)];
    [mArrowImageView setImage:[UIImage imageNamed:@"index_arrowDown_btn.png"]];
    
    [mMiddleButton addSubview:mArrowImageView];
    self.navigationItem.titleView = mMiddleButton;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

//初始化数据
-(void)initCommonData{
    self.isMapSelected = NO;
    [self initTableView];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mMiddleButton release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView: (BOOL) aPortait {
    //contentView大小设置
    CGRect vViewRect = CGRectMake(0, 0, mWidth, mHeight);
    UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
    [vContentView setBackgroundColor:[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1]];
    
    [vContentView addSubview:mCleanCarView];
    
    self.view = vContentView;
    //设置控件方向
    [self setViewFrame:aPortait];
    
    if (mServiceTypeVC == Nil) {
        mServiceTypeVC = [[ServiceTypeTableVC alloc] init];
        mServiceTypeVC.delegate = self;
    }

    SAFE_ARC_RELEASE(vContentView);

    [self addBaiduMap];
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{
            [mCleanCarView setFrame:CGRectMake(0, 0, mWidth, mHeight-44-49)];
        }
    }else{
    }
}

//------------------------------------------------

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)back{
    if (self.isMapSelected) {
        self.isMapSelected = NO;
        [self addBunessTable];
    }else{
        //返回时刷新地图
        if ([_delegate respondsToSelector:@selector(didCleanCarVCBack:)]) {
            [_delegate didCleanCarVCBack:Nil];
        }
        [super back];
    }
}

-(void)setTableFrame:(CGRect )aRect{
    LOG(@"CleanCarFrame:%f",aRect.size.height);
    [mCleanCarView setFrame:aRect];
    [mCleanCarView.tableView setFrame:aRect];
}

-(void)setSearchType:(SearchType)searchType{
    _searchType = searchType;
    switch (searchType) {
        case stWash_Consmetology:
            [mMiddleButton setTitle:@"洗车" forState:UIControlStateNormal];
            break;
        case stViewPoint:
            [mMiddleButton setTitle:@"景点" forState:UIControlStateNormal];
            break;
        case stFood:
            [mMiddleButton setTitle:@"美食" forState:UIControlStateNormal];
            break;
        case stHotel:
            [mMiddleButton setTitle:@"酒店" forState:UIControlStateNormal];
            break;
        case stCasula:
            [mMiddleButton setTitle:@"休闲" forState:UIControlStateNormal];
            break;
        case stLive:
            [mMiddleButton setTitle:@"生活" forState:UIControlStateNormal];
            break;
        case stOther:
            [mMiddleButton setTitle:@"其他" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)setIsMapSelected:(BOOL)isMapSelected{
    _isMapSelected = isMapSelected;
    if (isMapSelected) {
      self.navigationItem.rightBarButtonItem = Nil;
    }else{
        UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vRightButton setBackgroundImage:[UIImage imageNamed:@"saler_map_btn_default"] forState:UIControlStateNormal];
        [vRightButton setBackgroundImage:[UIImage imageNamed:@"saler_map_btn_select"] forState:UIControlStateHighlighted];
        [vRightButton setFrame:CGRectMake(-10, 0, 24, 24)];
        [vRightButton addTarget:self action:@selector(tableOrMapButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
        self.navigationItem.rightBarButtonItem = vBarButtonItem;
    }
}

-(void)initTableView{
    if (mCleanCarView == nil) {
        mCleanCarView = [[CleanCarView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeight-44)];
    }
    mCleanCarView.KJTableViewdelegate = self;
    mCleanCarView.parentVC = self;
}

//选择不同的类型后加载不同的数据
-(void)typeSelected:(NSInteger )sender BunessName:(NSString *)aBunessName
{
    self.searchType = sender;
    struct BaiDuCould vBaiDuParemeter =  [self setBaiDuClound:0 Distance:0 Index:0 Size:20];
    [mCleanCarView loadBusiness:sender BaiDuParemeter:vBaiDuParemeter SortFlag:stDistance BusinessName:aBunessName];
}

-(struct BaiDuCould )setBaiDuClound:(NSInteger)aStars Distance:(NSInteger)aDistance Index:(NSInteger)aIndex Size:(NSInteger)aSize
{
    struct BaiDuCould vBaiDuParemeter;
    vBaiDuParemeter.bdBeginStar = aStars;
    vBaiDuParemeter.bdDistance = aDistance;
    vBaiDuParemeter.bdPageIndex = aIndex;
    vBaiDuParemeter.bdPageSize = aSize;
    
    return vBaiDuParemeter;
}

+(NSDictionary *)getPostParemeter:(id )aBunessID{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:aBunessID,@"businessId", nil];
    return parameters;
}

#pragma mark CleanCarTableViewDelegate
-(void)didSelectedRowAtKJTableview:(ShangJiaInfo *)sender{
    [CleanCarVC gotoBunessDetail:self.searchType ShangJiaInfo:sender];
}


#pragma mark BunessDetailVCDelegate
-(void)didBunessDetailVCBackClicked:(id)sender{
    if (self.isMapSelected) {
        [mNearByMapVC viewWillAppear:YES];
        [mNearByMapVC adddAnnotation:mCleanCarView.tableInfoArray SearchType:self.searchType];
    }
}

#pragma mark 内存处理
- (void)viewShouldUnLoad {
    mCleanCarView = nil;
    [super viewShouldUnLoad];
}
#pragma mark 其他辅助功能
-(void)addBunessTable{
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.view addSubview:mCleanCarView];
    [mCleanCarView setNoticeUI];
}

#pragma mark - 预先加载百度地图
-(void)addBaiduMap{

    //先加载一次地图，不然地图无法显示。
    BMKMapView *vMapView = [[BMKMapView alloc] init];
    [vMapView setFrame:CGRectMake(-40, -40, 0, 0)];
    [vMapView setHidden:YES];
    [self.view addSubview:vMapView];

}

#pragma mark 进入商家详情页面
+(void)gotoBunessDetail:(SearchType )aSearchtype ShangJiaInfo:(ShangJiaInfo *)aInfo {
    NSDictionary *vParemeter = [self getPostParemeter:aInfo.bunessId];
    
    [NetManager postDataFromWebAsynchronous:APPURL901 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic =[NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            [ViewControllerManager createViewController:@"BunessDetailVC"];
            BunessDetailVC *vBunessDetailVC = (BunessDetailVC *)[ViewControllerManager getBaseViewController:@"BunessDetailVC"];
            [vBunessDetailVC setBunessDetailData:vDataDic];
            vBunessDetailVC.searchType = aSearchtype;
            vBunessDetailVC.shangJiaInfo = aInfo;
            //设置商家详情delegate,方便返回时刷新地图
            if (aSearchtype == stAgent) {
                //从车务代理商家点击地图进入商家详情
                AgentBunessVC *vVC = (AgentBunessVC *)[ViewControllerManager getBaseViewController:@"AgentBunessVC"];
                vBunessDetailVC.delegate = vVC;
            }else{
                CleanCarVC *vVC = (CleanCarVC *)[ViewControllerManager getBaseViewController:@"CleanCarVC"];
                vBunessDetailVC.delegate = vVC;
            }
            [ViewControllerManager showBaseViewController:@"BunessDetailVC" AnimationType:vaDefaultAnimation SubType:0];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求商家详情" Notice:@""];
}

#pragma mark - 其他业务点击事件
#pragma mark 选择地图或商家列表
-(void)tableOrMapButtonTouchDown:(id)sender{
    if ([self.view viewWithTag:1001] == Nil) {
        [mCleanCarView removeFromSuperview];
        if (mNearByMapVC == Nil) {
            mNearByMapVC = [[BunessDetailMapVC alloc] init];
            [mNearByMapVC.view setTag:1001];
        }
        if (mCleanCarView.qcmrInfoArr.count > 0) {
            [mNearByMapVC adddAnnotation:mCleanCarView.tableInfoArray SearchType:self.searchType];
        }
        [self.view addSubview:mNearByMapVC.view];
        self.isMapSelected = YES;
    }
}

#pragma mark 选择不同类型
-(void)changeServiceTypeButtonTouchDown:(id)sender{
    if (self.searchType != stWash_Consmetology) {
        if (!self.isMapSelected) {
            UIView *vTypeView = [self.view viewWithTag:1000];
            if (vTypeView == Nil) {
                mServiceTypeVC.view.tag = 1000;
                [mServiceTypeVC.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
                [self.view addSubview:mServiceTypeVC.view];
                [UIView animateChangeView:mServiceTypeVC.tableView AnimationType:vaMoveIn SubType:vsFromBottom Duration:0.3 CompletionBlock:Nil];
            }else{
                //设置动画
                [UIView moveToView:vTypeView DestRect:CGRectMake(0, -200, 320, 300) OriginRect:vTypeView.frame duration:.2 IsRemove:YES Completion:Nil];
            }

        }
    }
}

#pragma mark 类型选择确定
-(void)didServiceTypeTableVCSelected:(SearchType)aType{
    [self typeSelected:aType BunessName:Nil];
    UIView *vTypeView = [self.view viewWithTag:1000];
    //设置动画
    [UIView moveToView:vTypeView DestRect:CGRectMake(0, -200, 300, 300) OriginRect:vTypeView.frame duration:.2 IsRemove:YES Completion:Nil];
}
#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
}

//隐藏键盘时，将View恢复为原样式
-(void)inputKeyboardWillHide:(NSNotification *)notification{
}
@end
