//
//  ElectronicRouteBookVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ElectronicRouteBookVC.h"
#import "ElectronicTableViewVC.h"
#import "BunessDetailMapVC.h"
#import "AnimationTransition.h"
#import "ElectronicBookManeger.h"

@interface ElectronicRouteBookVC ()
{
    NSMutableArray *vVCArrays;  //保存所有的行程列表
    SliderViewController *mSliderVC; //滑动列表的contentView
    BunessDetailMapVC *mRoutesVC; //百度地图
    NSInteger mCurrentPage;//当前是第几页行程
    NSMutableArray *mDayButtons;
    NSDateFormatter *dateFormatter;   //时间格式
}
@property (nonatomic,assign) BOOL isExpandedMap;    //是否扩大了地图

@end

@implementation ElectronicRouteBookVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"ElectronicRouteBookVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ElectronicRouteBookVC" bundle:aBuddle];
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
    self.title = @"电子路书";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
    
}

-(void)initCommonData{
    mDayButtons = [[NSMutableArray alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
   [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   vVCArrays = [[NSMutableArray alloc] init];
}


#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [dateFormatter release];
    [mDayButtons removeAllObjects];
    [mDayButtons release];
    [self.electronicDic release];
    [mRoutesVC release];
    [mSliderVC release];
    [vVCArrays removeAllObjects],[vVCArrays release];
    [_mapContentView release];
    [_connectLeaderButton release];
    [_exPandAndLengthMapButton release];
    [_pageContentView release];
    [_expandContentView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    //初始化地图
    [self addSmallMap];
    //创建所有的行程列表
    mSliderVC = [[SliderViewController alloc] init];
    mSliderVC.delegate = self;
    //获取路线信息
    NSDictionary *vRouteDic = [self.electronicDic objectForKey:ROUTEDICKEY];
    NSDictionary *vDayDataDic = [[vRouteDic objectForKey:@"dayData"] mutableCopy];
    //最近接近当天的行程
    NSNumber *vNearByToDayIndex = Nil;
    //创建不同天数列表
    NSInteger vDayCount = 0;
    for (NSDictionary *vDic in vDayDataDic ) {

        NSMutableDictionary *vMutableDic = [vDic mutableCopy];
        //保存文件路径，以便点击查看个站点详情页
        NSString *vFilePathStr = [vRouteDic objectForKey:UNZIPFILEPATHKEY];
        IFISNIL(vFilePathStr);
        [vMutableDic setValue:vFilePathStr forKey:UNZIPFILEPATHKEY];
        //保存主活动ID,以便点击查看个站点详情页
        id vactivityId = [vRouteDic objectForKey:@"activityId"];
        IFISNIL(vactivityId);
        [vMutableDic setValue:vactivityId forKey:@"activityId"];
        //创建电子路书日程表
        ElectronicTableViewVC *vElecTableViewVC = [[ElectronicTableViewVC alloc] init];
        vElecTableViewVC.routesType = self.routesType;
        [vElecTableViewVC setDayDataDic:vMutableDic];
        [vVCArrays addObject:vElecTableViewVC];
        SAFE_ARC_RELEASE(vElecTableViewVC);
        
        //创建天数button
        [self addDayButtons:vDayCount];
        
        //寻找最接近当天得行程列表,同时满足路书是活动路书时
        if (vNearByToDayIndex == Nil && self.routesType == atActiveRoutes) {
            NSString *vDateStr= [vDic objectForKey:@"realDate"];
            IFISNIL(vDateStr);
            NSDate *vDate = [dateFormatter dateFromString:vDateStr];
  
            //寻找比当日稍晚的日期
            NSDate *vLateDate = [vDate laterDate:[NSDate date]];
            if ( vDate!= Nil &&[vLateDate isEqualToDate:vDate]) {
                vNearByToDayIndex = [NSNumber numberWithInt:vDayCount];
            }
            //寻找是否有当日日期等于活动日期，
            NSString *vTodayStr = [dateFormatter stringFromDate:[NSDate date]];
            if ([vTodayStr isEqualToString:vDateStr]) {
                vNearByToDayIndex = [NSNumber numberWithInt:vDayCount];
            }
        }
        vDayCount++;
    }
    
    //因为取消自动伸缩，所以self.View应该是从64像素开始
    CGRect vTableContentRect = self.tableContentView.frame;
    if (vVCArrays.count > 0) {
        [mSliderVC setViewControllers:vVCArrays ViewRect:CGRectMake(0, 0, vTableContentRect.size.width, vTableContentRect.size.height-64) PagePointImage:@""];
        //添加滑动页面,将滑动页面大小设为0用自定义的滑动页面
        [mSliderVC addSlidePageControllToView:self.pageContentView Frame:CGRectMake(0, 0, 0, 0) PagePointImage:@""];
        [self.tableContentView addSubview:mSliderVC.view];
        [self addChildViewController:mSliderVC];
        [self.view bringSubviewToFront:self.connectLeaderButton];
    }
    
    //移动行程列表到最接近当天日期的行程
    if (vNearByToDayIndex != Nil) {
        [mSliderVC sliderToPage:[vNearByToDayIndex intValue]];
        //改变最近那天天数button状态
        [self changeDayButtonSate:[vNearByToDayIndex intValue]];
        //搜寻地图路线
        [self searchRoutes];
    }else{
        //默认为第一天，改变第一天天数Button状态
        [self changeDayButtonSate:0];
        //搜寻地图路线
        [self searchRoutes];
    }
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [mRoutesVC viewWillAppear:YES];
}

#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}
//----------

- (void)viewDidUnload {
    [self setMapContentView:nil];
    [self setConnectLeaderButton:nil];
    [self setExPandAndLengthMapButton:nil];
    [self setPageContentView:nil];
    [self setExpandContentView:nil];
    [super viewDidUnload];
}

-(void)back{
    if (self.isExpandedMap) {
        //从大地图返回时刷新地图并添加大头针，否则崩溃
        [mRoutesVC viewWillAppear:YES];
        [self exPandAndlenthMapButtonClicked:self.exPandAndLengthMapButton];
    }else{
        [super back];
    }
}

-(void)setIsExpandedMap:(BOOL)isExpandedMap{
    _isExpandedMap = isExpandedMap;
    if (isExpandedMap) {
        self.title = @"行程地图";
        [self.exPandAndLengthMapButton setBackgroundImage:[UIImage imageNamed:@"roadBook_zoomOut_btn"] forState:UIControlStateNormal];
    }else{
         self.title = @"电子路书";
        [self.exPandAndLengthMapButton setBackgroundImage:[UIImage imageNamed:@"roadBook_zoomIn_btn"] forState:UIControlStateNormal];
    }
}

-(void)setElectronicDic:(NSDictionary *)electronicDic{
    if (_electronicDic == nil) {
        _electronicDic = [[NSDictionary alloc] initWithDictionary:electronicDic];
    }
}
#pragma mark SliderViewControllerDelegate
-(void)didScrollToPage:(NSInteger)aPage DiRection:(ViewAnnatationSubtype)aDirec{
    LOG(@"当前页数%d",aPage);
    mCurrentPage = aPage;
    
//    [self cleaderDayButtons];
//    //改变天数button选中状态
//    UIButton *vButton = [mDayButtons objectAtIndex:aPage];
//    [vButton setBackgroundImage:[UIImage imageNamed:@"roadBook_day_btn_select"] forState:UIControlStateNormal];
//    [vButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self changeDayButtonSate:aPage];
    [self searchRoutes];
}
//从附近商家返回
#pragma mark CleanCarVCDelegate
-(void)didCleanCarVCBack:(id)sender{
//    [mRoutesVC viewWillAppear:YES];
    [self searchRoutes];
}

#pragma mark ScenicDetailVCDelegate
-(void)didBackToVCClicked:(BOOL)sender{
    [mRoutesVC viewWillAppear:YES];
    [self searchRoutes];
}

#pragma mark - 其他辅助功能
#pragma mark 初始化地图
-(void)initMapView{
    //先移除地图
    if(mRoutesVC.view.superview != Nil){
        [mRoutesVC.view removeFromSuperview];
    }
    //实例化地图
    if (mRoutesVC == Nil) {
        mRoutesVC = [[BunessDetailMapVC alloc] init];
    }
}

#pragma mark 添加天数按钮
-(void)addDayButtons:(NSInteger)aIndex{
    //创建天数button
    int space = 10;
    UIButton *vDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vDayButton setFrame:CGRectMake((space + 50)*aIndex + 5, 24, 52, 30)];
    [vDayButton setBackgroundImage:[UIImage imageNamed:@"roadBook_day_btn_default"] forState:UIControlStateNormal];
    [vDayButton setTitle:[NSString stringWithFormat:@"第%d天",(aIndex+1)] forState:UIControlStateNormal];
    [vDayButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    vDayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [vDayButton setTag:aIndex];
    [vDayButton addTarget:self action:@selector(dayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageContentView setContentSize:CGSizeMake((space + 50)*aIndex + 80, self.pageContentView.frame.size.height)];
    [self.pageContentView addSubview:vDayButton];
    [mDayButtons addObject:vDayButton];
    
}

#pragma mark 改变天数状态
-(void)changeDayButtonSate:(NSInteger )aIndex{
    [self cleaderDayButtons];
    //改变天数button选中状态
    UIButton *vButton = [mDayButtons objectAtIndex:aIndex];
    [vButton setBackgroundImage:[UIImage imageNamed:@"roadBook_day_btn_select"] forState:UIControlStateNormal];
    [vButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSInteger vPageIndex = aIndex/5;
    [self.pageContentView scrollRectToVisible:CGRectMake(vPageIndex*300, self.pageContentView.frame.origin.y, self.pageContentView.frame.size.width, self.pageContentView.frame.size.height) animated:YES];
}

#pragma mark 获取行程信息
-(NSMutableArray *)getRouteLocation:(NSArray *)aArray{
    if (aArray.count == 0) {
        LOGERROR(@"getRouteLocation");
        return Nil;
    }
    NSMutableArray *vLocationArray = [NSMutableArray array];
    for (ElectronicSiteInfo *vInfo in aArray) {
        CLLocation *vCoord = [[CLLocation alloc] initWithLatitude:[vInfo.latitude doubleValue]longitude:[vInfo.longitude doubleValue]];
        [vLocationArray addObject:vCoord];
        SAFE_ARC_RELEASE(vCoord);
    }
    return vLocationArray;
}
#pragma mark 搜寻线路
-(void)searchRoutes{
//    //获取当天显示的列表
    ElectronicTableViewVC *vTableVC = (ElectronicTableViewVC *)[vVCArrays objectAtIndex:mCurrentPage];
    //获取站点坐标
    NSMutableArray *vLocationArray = [self getRouteLocation:vTableVC.routesInfoArray];
    [self addPointAnnotation];
    [mRoutesVC searchMutilLineWithLocationArray:vLocationArray];
//    [self performSelector:@selector(addPointAnnotation) withObject:Nil afterDelay:.3];
}

#pragma mark 添加地图大头针
-(void)addPointAnnotation{
    //获取当天显示的列表
    ElectronicTableViewVC *vTableVC = (ElectronicTableViewVC *)[vVCArrays objectAtIndex:mCurrentPage];
    [mRoutesVC addSitesAnnotation:vTableVC.routesInfoArray];
}

#pragma mark 清除日程button
-(void)cleaderDayButtons{
    for (UIButton *vButton in mDayButtons) {
        [vButton setBackgroundImage:[UIImage imageNamed:@"roadBook_day_btn_default"] forState:UIControlStateNormal];
        [vButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}

#pragma mark 添加小地图到列表
-(void)addSmallMap{
    //初始化地图
    [self initMapView];
    //改变地图扩大标记为no
    self.isExpandedMap = NO;
    CGRect vMapContentRect = self.mapContentView.frame;
    [mRoutesVC reSetViewFrame:CGRectMake(0, 0, vMapContentRect.size.width, vMapContentRect.size.height)];
    [self.mapContentView addSubview:mRoutesVC.view];
    
}

#pragma mark - 其他业务点击事件
#pragma mark  - 放大缩小地图
- (IBAction)exPandAndlenthMapButtonClicked:(UIButton *)sender {
    if (!self.isExpandedMap) {
        //初始化地图
        [self initMapView];
        //设置地图为大地图
        [mRoutesVC reSetViewFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //添加地图到全屏
        [self.view addSubview:mRoutesVC.view];
        //改变缩小按钮位置
        CGRect viewRect = self.view.frame;
        [self.expandContentView setFrame:CGRectMake(266, viewRect.size.height - 60, self.expandContentView.frame.size.width, self.expandContentView.frame.size.height)];
        [self.view bringSubviewToFront:self.expandContentView];
        //改变地图扩大标记为yes
        self.isExpandedMap = YES;
        //规划线路
        [self searchRoutes];
    }else{
        //变为小地图
        [self addSmallMap];
        //改变扩大按钮位置
        [self.expandContentView setFrame:CGRectMake(266, 88, self.expandContentView.frame.size.width, self.expandContentView.frame.size.height)];
        //规划线路
        [self searchRoutes];
    }

}

#pragma mark 点击天数
-(void)dayButtonClicked:(UIButton *)sender{
    LOG(@"点击第%d天",sender.tag);
    //移动到点击的日程上
    [mSliderVC sliderToPage:sender.tag];
}

- (IBAction)leaderButtonClicked:(id)sender {
    [TerminalData phoneCall:self.view PhoneNumber:[NSString stringWithFormat:@"%@",self.leaderPhone]];
}

- (void)didReceiveMemoryWarning {
    
}
@end
