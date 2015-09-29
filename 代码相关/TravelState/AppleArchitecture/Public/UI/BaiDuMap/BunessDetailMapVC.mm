//
//  BunessDetailMapVC.m
//  CTBNewProject
//
//  Created by klbest1 on 13-12-9.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import "BunessDetailMapVC.h"
#import "BMKPointA.h"
#import "ShangJiaInfo.h"
#import "ElectronicSiteInfo.h"
#import "AnimationTransition.h"
#import "ScenicDetailVC.h"
#import "ActivityRouteManeger.h"
#import "ElectronicRouteBookVC.h"
#import "UserManager.h"
#import "ARCMacros.h"
#import "CleanCarVC.h"
#import "Macros.h"

@interface BunessDetailMapVC ()
{
    BaiDuDataLoader *mBaiDuDataLoader;
    SearchType mSearchType;
    CLLocationCoordinate2D mCenterCoord;
    BMKAnnotationView *mSelectedView;
}
@end

@implementation BunessDetailMapVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"BunessDetailMapVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"BunessDetailMapVC" bundle:aBuddle];
    }
    if (self != nil) {
    
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone ;
    }
    mBaiDuDataLoader = [[BaiDuDataLoader alloc] init];
    mBaiDuDataLoader.delegate = self;
//    self.mapPaoPaoInContentView.layer.borderWidth = 1;
//    self.mapPaoPaoInContentView.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
    self.mapPaoPaoInContentView.layer.cornerRadius = 10;
    self.mapPaoPaoInContentView.layer.masksToBounds = YES;
    
    self.gothereButton.layer.borderWidth = 1;
    self.gothereButton.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
    
    self.nearByButton.layer.borderWidth =1;
    self.nearByButton.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mBaiDuDataLoader release];
    [_bunessNameLable release];
    [_siteNoButton release];
    [_mapPaoPaoView release];
    [_gothereButton release];
    [_nearByButton release];
    [_mapPaoPaoInContentView release];
    [super dealloc];
}
#endif

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{
        }
    }else{
    }
}

//------------------------
- (void)viewDidUnload {
    [self setContentView:nil];
    [self setBunessNameLable:nil];
    [self setSiteNoButton:nil];
    [self setMapPaoPaoView:nil];
    [self setGothereButton:nil];
    [self setNearByButton:nil];
    [self setMapPaoPaoInContentView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[BaiDuMapView shareBaiDuMapView] viewWillAppear:animated];
    //如果重新显示本界面时，没有获取到百度地图，就重新加载
    if ([self.view viewWithTag:101] == nil) {
        [self addSingleMapVC];
        
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //一旦消失，则不需要百度地图，移除掉百度地图
    if ([self.view viewWithTag:101] != nil) {
        [[BaiDuMapView shareBaiDuMapView].view removeFromSuperview];
        [BaiDuMapView shareBaiDuMapView].delegate = nil;
    }
}

//添加百度地图
-(void)addSingleMapVC
{
    if ([BaiDuMapView shareBaiDuMapView].view.superview) {
        [[BaiDuMapView shareBaiDuMapView].view removeFromSuperview];
    }
    
    CGRect vMapRect = self.view.frame;;
    [[BaiDuMapView shareBaiDuMapView] setMapViewFrame:vMapRect];
    [BaiDuMapView shareBaiDuMapView].delegate = self;
    [[BaiDuMapView shareBaiDuMapView].view setTag:101];
    [self.view addSubview:[BaiDuMapView shareBaiDuMapView].view ];
    
}

/*    stViewPoint,                //景点
 stFood,                     //美食
 stHotel,                    //酒店
 stCasula,                    //休闲
 stLive,                       //生活
 stOther,                     //其他
 stAgent,                     //代办*/
#pragma mark - BaiduMapViewDelegate
//实现大头针显示图片样式
-(UIImage *)baiDuMapViewAddAnnotationImage:(BMKMapView *)mapView viewForAnnotation:(BMKPointA *)annotationView
{
    NSInteger vTag = annotationView.tag;
    NSString *vImageStr = @"fillingStation_park_btn";
    switch (mSearchType) {
        case stGasstation:
            vImageStr = @"fillingStation_fillingStation_btn";
            break;
        case stStopstation:
            vImageStr = @"fillingStation_park_btn";
            break;
        case stWash_Consmetology:
            vImageStr = @"mapMaker_wash_btn";
            break;
        case stViewPoint:
            vImageStr = @"mapMaker_view_btn";
            break;
        case stFood:
            vImageStr = @"mapMaker_food_btn";
            break;
        case stHotel:
            vImageStr = @"mapMaker_wine_btn";
            break;
            //?
        case stCasula:
            vImageStr = @"mapMaker_rest_btn";
            break;
            //?
        case stLive:
            vImageStr = @"mapMaker_DIY_btn";
            break;
        case stOther:
            vImageStr = @"mapMaker_other_btn";
            break;
        case stAgent:
            vImageStr = @"mapMaker_replace_btn";
            break;
        case stSceneSite:
            vImageStr = [NSString stringWithFormat:@"roadBook_mapMaker%d_bkg",vTag];
            break;
        default:
            break;
    }
    return [UIImage imageNamed:vImageStr];
}

//点击Annotation时的回调,在aView上添加想要设置的弹出泡泡就行。（[aview addsubview:]）
-(void )baiDuMapViewdidSelectAnnotationView:(BMKMapView *)aMapView PaoPaoView:(BMKAnnotationView *)aView{
    //保存点击的paopao，以便进入附近商家时有该点得数据
    mSelectedView = aView;
    //重设paopao大小，同时加载自定义泡泡
    aView.paopaoView.frame = CGRectMake(aView.paopaoView.frame.origin.x, aView.paopaoView.frame.origin.y, self.mapPaoPaoView.frame.size.width, self.mapPaoPaoView.frame.size.height);
    self.mapPaoPaoView.frame = CGRectMake(0, 0, self.mapPaoPaoView.frame.size.width, self.mapPaoPaoView.frame.size.height);
    //设置自定义泡泡的商家名
    self.bunessNameLable.text = ((BMKPointA *)aView.annotation).bunessTitle;
    [aView.paopaoView addSubview:self.mapPaoPaoView];
    
    NSInteger  vSiteNo = ((BMKPointA *)aView.annotation).tag;
    [self.siteNoButton setTitle:[NSString stringWithFormat:@"%d",vSiteNo] forState:UIControlStateNormal];
}

-(void)baiDuMapViewDidChangeAnimated:(BMKMapView *)aMapView regionDidChangeAnimated:(BOOL)aAnimated{
    [self.mapPaoPaoView.superview showBubble:YES];
}

//重设百度地图中心坐标
-(void)BaiDuMapViewViewwillAppear:(BOOL)animated{
    LOG(@"BaiDuMapViewViewwillAppearCenterCoord:%f,%f",mCenterCoord.longitude,mCenterCoord.latitude);
    if (mCenterCoord.latitude > 0) {
        [BaiDuMapView shareBaiDuMapView].mapView.centerCoordinate = mCenterCoord;
    }
    if (mSearchType == stSceneSite) {
        [BaiDuMapView shareBaiDuMapView].mapView.zoomLevel = 10;
    }else{
        [BaiDuMapView shareBaiDuMapView].mapView.zoomLevel = 14;
    }
}

#pragma mark BaiDuDataLoaderDelegate
-(void)LoadBaiDuSearchFinish:(NSArray *)sender{
    if (sender.count > 0) {
        [self adddAnnotation:sender SearchType:mSearchType];
    }
    
}

#pragma mark - 其他辅助功能
-(NSArray *)getBMKPointAnnotation:(NSArray *)aArray{
    NSMutableArray *vPointAnnotationArray = [NSMutableArray array];
    for (int i = 0; i < aArray.count; i++) {
        ShangJiaInfo *vCurrentData = [aArray objectAtIndex: i];
        
        BMKPointA *vItem = [[BMKPointA alloc] init];
        vItem.coordinate = vCurrentData.pt;
        vItem.title = @".   ";
        vItem.bunessTitle = vCurrentData.name;
        vItem.tag = i;
        vItem.renZheng = vCurrentData.isauthenticate;
        vItem.shangJiaInfo = vCurrentData;
        [vPointAnnotationArray addObject:vItem];
    }
    return vPointAnnotationArray;
}

#pragma mark 生成站点的PointAnnotation
-(NSArray *)getBMKPointAnnotationForSceneSite:(NSArray *)aArray{
    NSMutableArray *vPointAnnotationArray = [NSMutableArray array];
    for (int i = 0; i < aArray.count; i++) {
        ElectronicSiteInfo *vCurrentData = [aArray objectAtIndex: i];
        
        BMKPointA *vItem = [[BMKPointA alloc] init];
        CLLocation *vLocation = [[CLLocation alloc] initWithLatitude:[vCurrentData.latitude doubleValue] longitude:[vCurrentData.longitude doubleValue]];
        vItem.coordinate = vLocation.coordinate;
        vItem.title = @".   ";
        vItem.bunessTitle = vCurrentData.name;
        vItem.tag = [vCurrentData.siteNo intValue];
        [vPointAnnotationArray addObject:vItem];
        SAFE_ARC_RELEASE(vItem);
        SAFE_ARC_RELEASE(vLocation);
    }
    return vPointAnnotationArray;
}

#pragma mark 生成百度参数
-(struct BaiDuCould )setBaiDuClound:(NSInteger)aStars Distance:(NSInteger)aDistance Index:(NSInteger)aIndex Size:(NSInteger)aSize
{
    struct BaiDuCould vBaiDuParemeter;
    vBaiDuParemeter.bdBeginStar = aStars;
    vBaiDuParemeter.bdDistance = aDistance;
    vBaiDuParemeter.bdPageIndex = aIndex;
    vBaiDuParemeter.bdPageSize = aSize;
    
    return vBaiDuParemeter;
}

#pragma mark 添加商家大头针
-(void)adddAnnotation:(NSArray *)aArray SearchType:(SearchType )aType{
    if (aArray.count == 0) {
        LOGERROR(@"adddAnnotation:SearchType:");
        return;
    }
    
    [self.mapPaoPaoView removeFromSuperview];
    [BaiDuMapView shareBaiDuMapView].delegate = self;
    mSearchType = aType;
    //转换为BMKPoint对象
    NSArray *vPointArray = [self getBMKPointAnnotation:aArray];
    [[BaiDuMapView shareBaiDuMapView] addAnnotations:vPointArray];
    
    //设置第一个位置为中心点
    CLLocation *vFirstLocation = (CLLocation *)[vPointArray objectAtIndex:0];
    mCenterCoord = vFirstLocation.coordinate;
    [BaiDuMapView shareBaiDuMapView].mapView.centerCoordinate = mCenterCoord;

    //改变附近商家为"商家详情"
    [self.nearByButton setTitle:@"商家详情" forState:UIControlStateNormal];
    if (mSearchType == stSceneSite) {
        [BaiDuMapView shareBaiDuMapView].mapView.zoomLevel = 10;
    }else{
        [BaiDuMapView shareBaiDuMapView].mapView.zoomLevel = 14;
    }

}

-(void)addSitesAnnotation:(NSArray *)aArray{
    if (aArray.count == 0) {
        LOGERROR(@"adddAnnotation:");
        return;
    }
    [self.mapPaoPaoView removeFromSuperview];
    //保存搜索类型
    mSearchType = stSceneSite;
    //显示站点序号
    self.siteNoButton.hidden = NO;
    [BaiDuMapView shareBaiDuMapView].delegate = self;
    //转换为BMKPiontA对象
    NSArray *vPointArray = [self getBMKPointAnnotationForSceneSite:aArray];
    [[BaiDuMapView shareBaiDuMapView] addAnnotations:vPointArray];
    
    //设置第一个位置为中心点
    CLLocation *vFirstLocation = (CLLocation *)[vPointArray objectAtIndex:0];
    mCenterCoord = vFirstLocation.coordinate;
    LOG(@"加载大头针地图CenterCoord:%f,%f",mCenterCoord.longitude,mCenterCoord.latitude);
    [BaiDuMapView shareBaiDuMapView].mapView.centerCoordinate = mCenterCoord;
    
}

#pragma mark 查询加油站、停车场
-(void)searchGasAndStopStation:(SearchType )aSearchType {
    mSearchType = aSearchType;
    struct BaiDuCould vBaiDuParemeter =  [self setBaiDuClound:0 Distance:0 Index:0 Size:20];
    [mBaiDuDataLoader searchBusiness:aSearchType BaiDuParemeter:vBaiDuParemeter SortFlag:stDistance BusinessName:nil];
}
#pragma mark 规划行车线路
-(void)driveLineSearchWithStartLocation:(CLLocationCoordinate2D) aStartlocation EndLocation:(CLLocationCoordinate2D) aEndLocation
{
    [[BaiDuMapView shareBaiDuMapView]  driveSearchWithStartLocation:aStartlocation EndLocation:aEndLocation];
}

#pragma mark 重设view大小位置
-(void)reSetViewFrame:(CGRect)aFrame{
    [self.view setFrame:aFrame];
    [[BaiDuMapView shareBaiDuMapView] setMapViewFrame:aFrame];
    LOG(@"重设地图大小后CenterCoord:%f,%f",mCenterCoord.longitude,mCenterCoord.latitude);
    [BaiDuMapView shareBaiDuMapView].mapView.centerCoordinate = mCenterCoord;
}


#pragma mark 显示商家位置
-(void) setBunessMapData:(ShangJiaInfo *)aInfo SearchType:(SearchType)aType
{
    self.gothereButton.hidden = YES;
    self.nearByButton.hidden = YES;
    NSMutableArray *vArray = [NSMutableArray arrayWithObject:aInfo];
    [self adddAnnotation:vArray SearchType:aType];
}

#pragma mark 规划连续线路信息
-(void)searchMutilLineWithLocationArray:(NSArray *)aArray{
    if (aArray.count == 0) {
        LOGERROR(@"searchMutilLineWithLocationArray");
        return;
    }
    LOG(@"线路坐标：%@",aArray);
    CLLocation *vFirstLocation = (CLLocation *)[aArray objectAtIndex:0];
    mCenterCoord = vFirstLocation.coordinate;
    //设置地图中心坐标为线路第一个站点坐标
    [BaiDuMapView shareBaiDuMapView].mapView.centerCoordinate = vFirstLocation.coordinate;
//    //规划线路
    for (int i = 0; i < aArray.count-1; i ++) {
        int j = i + 1;
        CLLocation *vStartLocation = [aArray objectAtIndex:i];
        CLLocation *vEndLocation = [aArray objectAtIndex:j];
        BMKMapPoint pt1 = BMKMapPointForCoordinate(vStartLocation.coordinate);
        BMKMapPoint pt2 = BMKMapPointForCoordinate(vEndLocation.coordinate);
        BMKMapPoint * temppoints = new BMKMapPoint[2];
        temppoints[0].x = pt2.x;
        temppoints[0].y = pt2.y;
        temppoints[1].x = pt1.x;
        temppoints[1].y = pt1.y;
        CustomOverlay* custom = [[CustomOverlay alloc] initWithPoints:temppoints count:2];
//        SAFE_ARC_AUTORELEASE(custom);
        [[BaiDuMapView shareBaiDuMapView].mapView addOverlay:custom];
        
    }
}

- (IBAction)neayByBunessButtonClicked:(id)sender {
    if (mSearchType != stSceneSite) {
        ShangJiaInfo *vInfo = ((BMKPointA *)mSelectedView.annotation).shangJiaInfo;
        [CleanCarVC gotoBunessDetail:mSearchType ShangJiaInfo:vInfo];
    }else {
        //更新用户选择的坐标，百度云搜索附近商家时以用户选择的坐标为最新坐标
        [ActivityRouteManeger shareActivityManeger].userChosedBunessCoord =mSelectedView.annotation.coordinate;
        LOG(@"用户点击商家坐标:%f,%f",mSelectedView.annotation.coordinate.latitude, mSelectedView.annotation.coordinate.longitude);
        [ViewControllerManager createViewController:@"CleanCarVC"];
        [ViewControllerManager showBaseViewController:@"CleanCarVC" AnimationType:vaDefaultAnimation SubType:vsFromBottom];
        CleanCarVC *vVC = (CleanCarVC *)[ViewControllerManager getBaseViewController:@"CleanCarVC"];
        ElectronicRouteBookVC *vRouteBookVC = (ElectronicRouteBookVC *)[ViewControllerManager getBaseViewController:@"ElectronicRouteBookVC"];
        vVC.delegate = vRouteBookVC;
        [vVC typeSelected:stViewPoint BunessName:Nil];

    }
}
- (IBAction)goThereButtonClicked:(id)sender {
    CLLocationCoordinate2D vDestinaCoord = mSelectedView.annotation.coordinate;
    CLLocationCoordinate2D vUserCoord = [UserManager instanceUserManager].userCoord;
    [ActivityRouteManeger gotoBaiMapApp:vUserCoord EndLocation:vDestinaCoord];
}
@end
