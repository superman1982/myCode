//
//  SelfTravelVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "SelfTravelVC.h"
#import "SliderViewController.h"
#import "NetManager.h"
#import "SelfDriveCell.h"
#import "ActiveInfo.h"
#import "ActiveDetailVC.h"
#import "ActivityRouteManeger.h"
#import "UserManager.h"
#import "BaiDuMapView.h"

@interface SelfTravelVC ()
{
    //是否点击活动路书
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    //官方置顶路书滚动View
    SliderViewController *mSliderVC;
    NSInteger mPageSize;
    NSInteger mPageIndex;
    NSInteger mType;
    BOOL      isInitWebData;
}

@property (nonatomic,retain) NSMutableArray *topArray;
//官方路书Views
@property (nonatomic,retain) NSMutableArray *topViewsArray;
@end

@implementation SelfTravelVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"SelfTravelVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"SelfTravelVC" bundle:aBuddle];
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
    self.title = @"昵称";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mType = 1;
    self.noticeStr = Nil;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_topArray removeAllObjects];
    [_topArray release];
    [_topArray removeAllObjects];
    [_topArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mSliderVC release];
    [_refreshFooterView release];
    [_refreshHeaderView release];
    [_routesArray removeAllObjects],[_routesArray release];
    [_contentView release];
    [_routeTableView release];
    [_huodongLushuButton release];
    [_recommendButton release];
    [_zanWuHuoDongLuShuLable release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self.routeTableView setFrame:CGRectMake(0, 0, 320, self.contentView.frame.size.height)];
    [self.contentView addSubview:self.routeTableView];
    [self.huodongLushuButton setTitleColor:[UIColor colorWithRed:0 green:65/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    [self.recommendButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    [self createHeaderView];
    [self addBaiduMap];
    if (mType == 2) {
        [self.huodongLushuButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.huodongLushuButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
        [self.recommendButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
        [self.recommendButton setTitleColor:[UIColor colorWithRed:0 green:64/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
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
#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}

//------------------------

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareDidCancle:) name:@"shareDidCancle" object:Nil];
    if (self.routesArray.count == 0) {
        [self huoDongLushuClicked:Nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setTopArray:(NSMutableArray *)topArray{
    if (_topArray == Nil) {
        _topArray = [[NSMutableArray alloc] init];
    }
    [_topArray removeAllObjects];
    [_topArray addObjectsFromArray:topArray];
    [self.routeTableView reloadData];
}

-(void)setTopViewsArray:(NSMutableArray *)topViewsArray{
    if (_topViewsArray == Nil) {
        _topViewsArray = [[NSMutableArray alloc] init];
    }
    [_topViewsArray removeAllObjects];
    [_topViewsArray addObjectsFromArray:topViewsArray];
}

#pragma mark - 其他辅助功能
-(void)initSelfDriveData{
    isInitWebData = YES;
    //设置请求类型
    mPageIndex = 0;
    mPageSize = 14;
    //获取参数
    NSDictionary *vParemeter = [self setPostParemeterType:mType PageIndex:mPageIndex PageSize:mPageSize];
    [self postWebData:vParemeter];
}

#pragma mark 添加活动数据到列表
-(void)addSelfDriveWebDta{
    isInitWebData = NO;
    mPageIndex++;
    NSDictionary *vParemeter = [self setPostParemeterType:mType PageIndex:mPageIndex PageSize:mPageSize];
    [self postWebData:vParemeter];
}

#pragma mark 组合请求参数
-(NSDictionary *)setPostParemeterType:(NSInteger)aType
                        PageIndex:(NSInteger)aPageIndex
                         PageSize:(NSInteger)aPageSize
{
    //kktest
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
    
    id vUSerID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUSerID,@"userId",
                                vProvinceID,@"provinceId",
                                vCityID,@"cityId",
                                vDistrictID,@"districtId",
                                [NSNumber numberWithInt:aType],@"type",
                                [NSNumber numberWithInt:aPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:aPageSize],@"pageSize",
                                nil];
    return vParemeter;
}

#pragma mark 请求自驾数据
-(void)postWebData:(NSDictionary *)aParemeter{
    
    [NetManager postDataFromWebAsynchronous:APPURL401 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSDictionary *vDetailDataDic = [vDataDic objectForKey:@"normal"];
        NSMutableArray *vDetailDataArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDetailDataDic) {
            ActiveInfo *vActiveInfo = [self analyzeActivityDic:vDic];
            if (vActiveInfo != Nil) {
                [vDetailDataArray addObject:vActiveInfo];
            }
        }
        
        NSDictionary *vTopDic = [vDataDic objectForKey:@"top"];
        NSMutableArray *vTopArray = [NSMutableArray array];
        for (NSDictionary *vDic in vTopDic) {
            ActiveInfo *vActiveInfo = [self analyzeActivityDic:vDic];
            if (vActiveInfo != Nil) {
                [vTopArray addObject:vActiveInfo];
            }
        }
        self.routesArray = vDetailDataArray;
        if (isInitWebData) {
            [self initOfficalRoute:vTopArray];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求活动路书" Notice:_noticeStr];
}

-(void )setRoutesArray:(NSMutableArray *)routesArray{
    if (_routesArray == nil) {
        _routesArray = [[NSMutableArray alloc] init];
    }
    if (isInitWebData) {
        [_routesArray removeAllObjects];
    }
    [_routesArray addObjectsFromArray:routesArray];
    [self.routeTableView reloadData];
    
    //移动到第一行
    if (isInitWebData) {
        if (routesArray.count > 0) {
            [self.routeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

#pragma mark 分解活动数据到对象
-(ActiveInfo *)analyzeActivityDic:(NSDictionary *)aDic{
    ActiveInfo *vActiveInfo = [[ActiveInfo alloc] init];
    vActiveInfo.ActivityId = [aDic objectForKey:@"activityId"];
    IFISNILFORNUMBER(vActiveInfo.ActivityId);
    //            vActiveInfo.type = [vDic objectForKey:@"type"];
    if (mType == 1) {
        vActiveInfo.type = atActiveRoutes;
    }else if(mType == 2){
        vActiveInfo.type = atRecomendRoutes;
    }
    vActiveInfo.isOfficial = [aDic objectForKey:@"isOfficial"];
    IFISNILFORNUMBER(vActiveInfo.isOfficial);
    vActiveInfo.shareCount = [aDic objectForKey:@"shareCount"];
    IFISNILFORNUMBER(vActiveInfo.shareCount);
    vActiveInfo.praiseCount = [aDic objectForKey:@"praiseCount"];
    IFISNILFORNUMBER(vActiveInfo.praiseCount);
    vActiveInfo.comentCount = [aDic objectForKey:@"commentCount"];
    IFISNILFORNUMBER(vActiveInfo.comentCount);
    vActiveInfo.activeTitle = [aDic objectForKey:@"activityTitle"];
    IFISNIL(vActiveInfo.activeTitle);
    vActiveInfo.activityURL = [aDic objectForKey:@"activityURL"];
    IFISNIL(vActiveInfo.activityURL);
    vActiveInfo.activeImages = [aDic objectForKey:@"activityImage"];
    vActiveInfo.activeTime = [aDic objectForKey:@"activityTime"];
    IFISNIL(vActiveInfo.activeTime);
    vActiveInfo.signupEndDate = [aDic objectForKey:@"signupEndDate"];
    IFISNIL(vActiveInfo.signupEndDate);
    vActiveInfo.listingPrice = [aDic objectForKey:@"price"];
    IFISNILFORNUMBER(vActiveInfo.listingPrice);
    vActiveInfo.memberPrice = [aDic objectForKey:@"vipPrice"];
    IFISNILFORNUMBER(vActiveInfo.memberPrice);
    vActiveInfo.returnMoney = [aDic objectForKey:@"returnMoney"];
    IFISNILFORNUMBER(vActiveInfo.returnMoney);
    vActiveInfo.singupNumber = [aDic objectForKey:@"signupNumber"];
    IFISNILFORNUMBER(vActiveInfo.singupNumber);
    vActiveInfo.rouadBookURL = [aDic objectForKey:@"roadBookUrl"];
    IFISNIL(vActiveInfo.rouadBookURL);
    vActiveInfo.isSignup = [aDic objectForKey:@"isSignup"];
    IFISNILFORNUMBER(vActiveInfo.isSignup);
    vActiveInfo.leaderPhone = [aDic objectForKey:@"leaderPhone"];
    IFISNILFORNUMBER(vActiveInfo.leaderPhone);
    vActiveInfo.isIncludeSelf = [aDic objectForKey:@"isIncludeSelf"];
    vActiveInfo.totalSignup = [aDic objectForKey:@"totalSignup"];
    IFISNILFORNUMBER(vActiveInfo.totalSignup);
    vActiveInfo.allowNoMember = [aDic objectForKey:@"allowNoMember"];
    IFISNILFORNUMBER(vActiveInfo.allowNoMember);
    vActiveInfo.lodingMoney = [aDic objectForKey:@"lodgingMoney"];
    IFISNILFORNUMBER(vActiveInfo.lodingMoney);
    vActiveInfo.insuranceMone = [aDic objectForKey:@"insuranceMoney"];
    IFISNILFORNUMBER(vActiveInfo.insuranceMone);
    vActiveInfo.isIncludeInsurance = [aDic objectForKey:@"isIncludeInsurance"];
    IFISNILFORNUMBER(vActiveInfo.isIncludeInsurance);
    NSString *vRoadBookModifyTimeStr = [aDic objectForKey:@"roadBookModifyTime"];
    IFISNIL(vRoadBookModifyTimeStr);
    vActiveInfo.roadBookModifyTime = vRoadBookModifyTimeStr;
    SAFE_ARC_AUTORELEASE(vActiveInfo);
    return vActiveInfo;
}

#pragma mark 初始化sliderView
-(void)initSliderView{
    //如果已经加载过移除
    if (mSliderVC.view.superview != Nil) {
        [mSliderVC.view removeFromSuperview];
    }
    if (mSliderVC != Nil) {
        //清空官方推荐行程
        SAFE_ARC_RELEASE(mSliderVC);
        mSliderVC = nil;
    }
    
    //创建所有的行程列表
    mSliderVC = [[SliderViewController alloc] init];
}

#pragma mark 初始化官方路书
-(void )initOfficalRoute:(NSMutableArray *)aData{
    NSMutableArray *vViewArrays = [NSMutableArray array];
    for (NSInteger index = 0; index < aData.count; index ++) {
        SelfDriveCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"SelfDriveCell" owner:self options:Nil] objectAtIndex:0];
        ActiveInfo *vInfo = [aData objectAtIndex:index];
        [vCell setCell:vInfo];
        if (vInfo.type == atRecomendRoutes) {
            [vCell setRecommendRoutesUI];
        }else{
            [vCell setActiveRoteUI];
        }
        vCell.officeClickedButton.hidden = NO;
        vCell.officalImageView.hidden = NO;
        vCell.delegate = self;
        vCell.tag = index;
        [vViewArrays addObject:vCell];
    }
    //保存官方置顶的页面引用
    self.topViewsArray = vViewArrays;
    
    if (aData.count > 0) {
        [self initSliderView];
        //因为取消自动伸缩，所以self.View应该是从64像素开始
        [mSliderVC setViewViews:vViewArrays ViewRect:CGRectMake(0, 0, 320,150) PagePointImage:@""];
        [mSliderVC.view setBackgroundColor:[UIColor whiteColor]];
        mSliderVC.isAutoScroll = YES;
    }
    //保存官方置顶数据
    self.topArray = aData;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.topArray.count > 0) {
//        return mSliderVC.view.frame.size.height;
//    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
//        if (self.topArray.count > 0) {
//            return mSliderVC.view;
//        }
    }
    return Nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger vRowCount = self.routesArray.count;
    if (vRowCount > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        self.zanWuHuoDongLuShuLable.hidden = NO;
        if (mType == 1) {
            self.zanWuHuoDongLuShuLable.text = @"暂无活动路书";
        }else{
            self.zanWuHuoDongLuShuLable.text = @"暂无推荐路书";
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return vRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"driveCell";
    SelfDriveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelfDriveCell" owner:self options:Nil] objectAtIndex:0];
        SAFE_ARC_AUTORELEASE(cell);
    }
    
    NSInteger vIndex = indexPath.row;
    ActiveInfo *vInfo = [self.routesArray objectAtIndex:vIndex];
    [cell setCell:vInfo];
    cell.imageView.backgroundColor = [UIColor darkGrayColor];
    if (vInfo.type == atRecomendRoutes) {
        [cell setRecommendRoutesUI];
    }else{
        [cell setActiveRoteUI];
    }
    
    if (self.routesArray.count >= 10) {
        [self setFooterView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取活动ID
    ActiveInfo *vInfo = [self.routesArray objectAtIndex:indexPath.row];
    [self gotoActiveDetailVC:vInfo.ActivityId];
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma mark methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - 100,
                                     self.routeTableView.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    
	[self.routeTableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.routeTableView.contentSize.height, self.routeTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.routeTableView.frame.size.width,
                                              self.routeTableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.routeTableView.frame.size.width, self.routeTableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.routeTableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
    
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.routeTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.routeTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}else{
        self.routeTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.routeTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.routeTableView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.routeTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    self.noticeStr = @"";
    if (aRefreshPos == 0) {
        //刷新
        [self initSelfDriveData];
    }else if (aRefreshPos == 1){
        //加载
        [self addSelfDriveWebDta];
    }
    
	[self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	return [NSDate date]; // should return date data source was last changed
}


//刷新调用的方法
-(void)refreshView{
    [self testFinishedLoadData];
}
//加载调用的方法
-(void)getNextPageView{
    
    [self removeFooterView];
    [self testFinishedLoadData];
    
}
-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    
}

#pragma mark ActiveBookVCDelegate
-(void)didActiveBookVCSucess:(id)sender{
    [self huoDongLushuClicked:Nil];
}

#pragma mark SelfDriveCellDelegate
#pragma mark 置顶活动被点击
-(void)didSelfDriveCellClicked:(id)sender{
    ActiveInfo *vInfo = [self.topArray objectAtIndex:[sender intValue]];
    [self gotoActiveDetailVC:vInfo];
}

#pragma mark - 其他辅助功能
#pragma mark - 预先加载百度地图
-(void)addBaiduMap{
    //先加载一次地图，不然地图无法显示。
    BMKMapView *vMapView = [[BMKMapView alloc] init];
    [vMapView setFrame:CGRectMake(-40, -40, 0, 0)];
    [vMapView setHidden:YES];
    [self.view addSubview:vMapView];
}

#pragma mark 更改某行的活动数据
-(void)reloadActiveDataOnRow:(ActiveInfo *)aInfo{
    NSNumber *vReplaceIndex = Nil;
    
    NSString *aActivityStr = [NSString stringWithFormat:@"%@",aInfo.ActivityId ];
    //检测相同活动id的商家
    for (int i = 0; i< self.routesArray.count; i++) {
        ActiveInfo *info = [self.routesArray objectAtIndex:i];
        NSString *infoActivityStr = [NSString stringWithFormat:@"%@",info.ActivityId ];
        if ([aActivityStr isEqualToString:infoActivityStr]) {
            //保存相同的活动在数组中得索引
            vReplaceIndex = [NSNumber numberWithInt:i];
        }
        
    }
    //替换掉相应的活动数据
    if (vReplaceIndex != Nil) {
        [self.routesArray replaceObjectAtIndex:[vReplaceIndex intValue] withObject:aInfo];
        [self.routeTableView reloadData];
    }else{
        //如果在非官方路书中没有找到相应的活动数据，就在官方置顶的路书中找，然后替换
        for (int j = 0; j<self.topArray.count; j++) {
            ActiveInfo *vInfo = [self.topArray objectAtIndex:j];
            NSString *vInfoActivityStr = [NSString stringWithFormat:@"%@",vInfo.ActivityId ];
            if ([aActivityStr isEqualToString:vInfoActivityStr]) {
                //保存相同的活动在数组中的索引
                vReplaceIndex = [NSNumber numberWithInt:j];
            }
        }
        //替换官方置顶数据，并更新页面
        if (vReplaceIndex != Nil) {
            [self.topArray replaceObjectAtIndex:[vReplaceIndex intValue] withObject:aInfo];
            SelfDriveCell *vCell = [self.topViewsArray objectAtIndex:[vReplaceIndex intValue]];
            [vCell setCell:aInfo];
        }
    }
}

-(void)gotoActiveDetailVC:(id )aActiveId{
    //用户id
    id vUserId = [UserManager instanceUserManager].userID;
    //组合请求参数
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:aActiveId,@"activityId",vUserId,@"userId", nil];
    //请求数据
    [NetManager postDataFromWebAsynchronous:APPURL402 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vDataDic = [[NetManager jsonToDic:responseObject] objectForKey:@"data"];
        //跳转页面
        [ViewControllerManager createViewController:@"ActiveDetailVC"];
        ActiveDetailVC *vAcDetailVC = (ActiveDetailVC *)[ViewControllerManager getBaseViewController:@"ActiveDetailVC"];
        vAcDetailVC.detailDic = vDataDic;
        vAcDetailVC.acticeInfo = [self analyzeActivityDic:vDataDic];
        [ViewControllerManager showBaseViewController:@"ActiveDetailVC" AnimationType:vaDefaultAnimation SubType:0];
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"请求活动详情" Notice:@""];

}

#pragma mark - 其他业务功能
- (IBAction)huoDongLushuClicked:(id)sender {
    mType = 1;
    [self.huodongLushuButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
    [self.huodongLushuButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    [self.recommendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.recommendButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    self.noticeStr = @"";
    [self initSliderView];
    [self initSelfDriveData];
}

- (IBAction)recommendClicked:(id)sender {
    mType = 2;
    [self.huodongLushuButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.huodongLushuButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    [self.recommendButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
    [self.recommendButton setTitleColor:[UIColor colorWithRed:0 green:64/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    self.noticeStr = @"";
    [self initSliderView];
    [self initSelfDriveData];

}

-(void)shareDidCancle:(NSNotification *)aNoti{
    if (self.view.frame.origin.y > 0) {
        [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    }
    LOG(@"selfTravel.y%f",self.view.frame.origin.y);
    LOG(@"tableView.y%f",self.routeTableView.frame.origin.y);
}

- (void)didReceiveMemoryWarning {

}
- (void)viewDidUnload {
    [self setContentView:nil];
    [self setRouteTableView:nil];
    [self setHuodongLushuButton:nil];
    [self setRecommendButton:nil];
    [self setZanWuHuoDongLuShuLable:nil];
[super viewDidUnload];
}
@end
