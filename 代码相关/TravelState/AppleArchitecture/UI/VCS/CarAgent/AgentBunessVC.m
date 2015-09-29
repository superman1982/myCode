//
//  AgentBunessVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AgentBunessVC.h"
#import "CleanCarTableViewCell.h"
#import "NearByBuinessMapVC.h"
#import "NetManager.h"
#import "BunessDetailVC.h"
#import "BaiDuDataLoader.h"
#import "UserManager.h"
#import "CleanCarVC.h"
#import "AgentSearchTypeVC.h"
#import "AnimationTransition.h"

@interface AgentBunessVC ()
{
    NSInteger     mPageIndex;
    NSInteger   mPageSize ;
    BOOL        isInitWebData;
    UIButton    *mMiddleButton;
    BunessDetailMapVC *mNearByMapVC;//地图
    ChoseDistrictVC *mChosePlaceVC;  //选择区域
    AgentSearchTypeVC *mSearchTypeVC;
    
    CGRect mOriginRect ;  //搜索类型位置
    CGRect mDestinaRect; //搜索类型移动位置
    NSString *mSearchKey;  //搜索关键字
    NSInteger mSearchType;  //搜索类型
    NSInteger mSearchPageIndex;
    NSInteger mSearPageSize;
    CleanCarVC *mCleanCarVC; //洗车等服务
    SearchType mCurrentServiceType; //当前服务类型
}

@property (nonatomic,retain)   NSMutableArray *agentBusinessArray;

@property (nonatomic,assign) BOOL isMapClicked;

@end
@implementation AgentBunessVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"AgentBunessVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"AgentBunessVC" bundle:aBuddle];
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
    //初始化服务类型按钮，使其全局以便更改title
    mMiddleButton = [[UIButton alloc] init];
    [mMiddleButton setBackgroundColor:[UIColor clearColor]];
    [mMiddleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [mMiddleButton setFrame:CGRectMake(0, 0, 100, 44)];
    [mMiddleButton addTarget:self action:@selector(changeDistrictButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    mMiddleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0];
    UIImageView *mArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 14, 17, 17)];
    [mArrowImageView setImage:[UIImage imageNamed:@"index_arrowDown_btn.png"]];
    
    [mMiddleButton addSubview:mArrowImageView];
    self.navigationItem.titleView = mMiddleButton;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    self.isMapClicked = NO;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mMiddleButton release];
    [_placeDic release];
    [_agentBunessTableView release];
    [_ifHasBunessLable release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self createHeaderView];

    if (mSearchTypeVC == Nil) {
        mSearchTypeVC = [[AgentSearchTypeVC alloc] init];
        mSearchTypeVC.delegate = self;
        NSArray *vTypeArray = @[@"商家",@"地址",@"商品",];
        mSearchTypeVC.typeArray = [vTypeArray mutableCopy];
    }
    
    if (mCleanCarVC == Nil) {
        mCleanCarVC = [[CleanCarVC alloc] init];
        [mCleanCarVC.view setFrame:CGRectMake(0,0, _servicesContentView.frame.size.width, _servicesContentView.frame.size.height)];
        [mCleanCarVC setTableFrame:CGRectMake(0,0, _servicesContentView.frame.size.width, _servicesContentView.frame.size.height)];
    }
    
    CGRect vMiddeRect = [self.view convertRect:self.searchTypeButton.frame fromView:self.searchTypeButton];
    mOriginRect = CGRectMake(vMiddeRect.origin.x,vMiddeRect.origin.y, mSearchTypeVC.view.frame.size.width,  mSearchTypeVC.view.frame.size.height);
    mDestinaRect = CGRectMake(vMiddeRect.origin.x, vMiddeRect.size.height+8,mSearchTypeVC.view.frame.size.width,  mSearchTypeVC.view.frame.size.height);
    
    self.middleContentView.layer.cornerRadius = 5;
    self.middleContentView.layer.masksToBounds = YES;
    
    self.searchTypeButton.layer.cornerRadius = 5;
    self.searchTypeButton.layer.masksToBounds = YES;
    
    self.eatButton.layer.cornerRadius = 5;
    self.eatButton.layer.masksToBounds = YES;
    
    self.sleepButton.layer.cornerRadius = 5;
    self.sleepButton.layer.masksToBounds = YES;
    
    self.playButton.layer.cornerRadius = 5;
    self.playButton.layer.masksToBounds = YES;
    
    //展示商家类型
    if (_isSearchType) {
        [self setSearchShowNunessVC];
    }else{
        [self setNormalShowBunessVC];
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
//----------

-(void)back{
    if (self.isMapClicked) {
        self.isMapClicked = NO;
        [self addBunessTable];
    }else{
        [super back];
    }
}

-(void)setBunessTitle:(NSString *)bunessTitle{
    if (_bunessTitle == Nil) {
        _bunessTitle= bunessTitle;
    }
    self.title = bunessTitle;
}

-(void)setPlaceDic:(NSDictionary *)placeDic{
    _placeDic = [[NSDictionary alloc] initWithDictionary:placeDic];
    NSString *title = [NSString stringWithFormat:@"%@商家",[[_placeDic objectForKey:@"district"] objectForKey:@"name"]];
    [mMiddleButton setTitle:title forState:UIControlStateNormal];
    [self initWebData];
}

-(void)setAgentBusinessArray:(NSMutableArray *)agentBusinessArray{
    if (_agentBusinessArray == Nil) {
        _agentBusinessArray = [[NSMutableArray alloc] init];
    }
    if (isInitWebData) {
        [_agentBusinessArray removeAllObjects];
    }
    [_agentBusinessArray addObjectsFromArray:agentBusinessArray];
    //本地区暂无商家提示
    if (_agentBusinessArray.count == 0) {
        self.ifHasBunessLable.hidden = NO;
        [self.view bringSubviewToFront:self.ifHasBunessLable];
    }else{
        self.ifHasBunessLable.hidden = YES;
    }
    [self.agentBunessTableView reloadData];
}

-(void)setIsMapClicked:(BOOL)isMapClicked{
    _isMapClicked = isMapClicked;
    if (_isMapClicked) {
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

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger vRowIndex = self.agentBusinessArray.count;
    if (vRowIndex > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return vRowIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentify = @"QCMRCell";
    CleanCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CleanCarTableViewCell" owner:self options:nil] objectAtIndex:0] ;
    }
    
    [cell setCell:[self.agentBusinessArray objectAtIndex:indexPath.row]];
    
    if ([self.searchField isFirstResponder]) {
        [self.searchField resignFirstResponder];
    }
    if (_agentBusinessArray.count >= 10) {
        [self setFooterView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self moveUP];
    ShangJiaInfo *vInfo = [self.agentBusinessArray objectAtIndex:indexPath.row];
    [CleanCarVC gotoBunessDetail:stAgent ShangJiaInfo:vInfo];
    
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
                                     self.agentBunessTableView.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    
	[self.agentBunessTableView addSubview:_refreshHeaderView];
    
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
    CGFloat height = MAX(self.agentBunessTableView.contentSize.height, self.agentBunessTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.agentBunessTableView.frame.size.width,
                                              self.agentBunessTableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.agentBunessTableView.frame.size.width, self.agentBunessTableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.agentBunessTableView addSubview:_refreshFooterView];
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
		self.agentBunessTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.agentBunessTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}else{
        self.agentBunessTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.agentBunessTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agentBunessTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agentBunessTableView];
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
    
    if (aRefreshPos == 0) {
        //是搜索类型则初始化搜索的商家
        if (_isSearchType) {
            [self initSearchBuness];
        }else{
            //初始化列表展示商家
            [self initWebData];
        }
    }else if (aRefreshPos == 1){
        if (_isSearchType) {
            [self downLoadSearchBuness];
        }else{
            [self loadWebData];
        }
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
    
//    if (_agentBusinessArray.count >= 10) {
//        [self setFooterView];
//    }
    
}

#pragma mark BunessDetailVCDelegate
#pragma mark 商家详情返回
-(void)didBunessDetailVCBackClicked:(id)sender{
    if (self.isMapClicked) {
        [mNearByMapVC viewWillAppear:YES];
        [mNearByMapVC adddAnnotation:self.agentBusinessArray SearchType:stAgent];
    }
}

//#pragma mark 点击事件
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *vTouch = [touches anyObject];
//    CGPoint vPoint = [vTouch locationInView:self.view];
//    if (!CGRectContainsPoint(self.searchField.frame,vPoint)) {
//        [self.searchField resignFirstResponder];
//    }
//}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
}

//隐藏键盘时，将View恢复为原样式
-(void)inputKeyboardWillHide:(NSNotification *)notification{
}

#pragma mark - 其他辅助功能
#pragma mark - 选择区域
-(void)goToChosePlaceVC:(NSDictionary *)aData{
    if (!self.isMapClicked) {
        if (mChosePlaceVC == Nil) {
            mChosePlaceVC = [[ChoseDistrictVC alloc] init];
            NSNumber *vCityID = [[_placeDic objectForKey:@"city"] objectForKey:@"id"];
            IFISNILFORNUMBER(vCityID);
            //请求网络数据
            NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"type",vCityID,@"id",nil];
            
            [NetManager postDataFromWebAsynchronous:APPURL103 Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
                //解析返回数据到数组
                NSDictionary *vDataDic = [[NetManager jsonToDic:responseObject] objectForKey:@"data"];
                NSMutableArray *vDataArray = [NSMutableArray array];
                for (NSDictionary *vDic in vDataDic) {
                    [vDataArray addObject:vDic];
                }
                
                mChosePlaceVC.placeArray = vDataArray;
                mChosePlaceVC.delegate = self;
                mChosePlaceVC.cityDic = [_placeDic objectForKey:@"city"];
                mChosePlaceVC.provinceDic = [_placeDic objectForKey:@"province"];
                [mChosePlaceVC.view setTag:1000];
                [mChosePlaceVC.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
                //显示地区
                [self.view addSubview:mChosePlaceVC.view];
                //设置动画
                [UIView animateChangeView:mChosePlaceVC.view AnimationType:vaMoveIn SubType:vsFromBottom Duration:.2 CompletionBlock:Nil];
                
            } Failure:^(NSURLResponse *response, NSError *error) {
            } RequestName:@"获取区" Notice:@""];
        }else{
            [mChosePlaceVC.view setTag:1000];
            [mChosePlaceVC.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            //显示地区
            [self.view addSubview:mChosePlaceVC.view];
            //设置动画
            [UIView animateChangeView:mChosePlaceVC.view AnimationType:vaMoveIn SubType:vsFromBottom Duration:.2 CompletionBlock:Nil];
        }
       
    }
}

#pragma mark 下载数据初始化
-(void)initWebData{
    isInitWebData = YES;
    mPageIndex = 0;
    mPageSize = 14;
    NSDictionary *vParemeter = [self getParemeter];
    [self postToWeb:vParemeter];
    
}


-(NSDictionary *)getParemeter{
    id vProinceID = [[_placeDic objectForKey:@"province"] objectForKey:@"id"];
    IFISNILFORNUMBER(vProinceID);
    
    id vCityId = [[_placeDic objectForKey:@"city"] objectForKey:@"id"];
    IFISNILFORNUMBER(vCityId);
    
    id vDistrictId = [[_placeDic objectForKey:@"district"] objectForKey:@"id"];
    IFISNILFORNUMBER(vDistrictId);
    
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vProinceID,@"provinceId",
                                vCityId,@"cityId",
                                vDistrictId,@"districtId",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    return vParemeter;
}

#pragma mark 下载数据设置
-(void)loadWebData{
    isInitWebData = NO;
    mPageIndex++;
    NSDictionary *vParemeter = [self getParemeter];
    [self postToWeb:vParemeter];
}

#pragma mark 请求数据
-(void)postToWeb:(NSDictionary *)aParemeter{
    [NetManager postDataFromWebAsynchronous:APPURL506 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vNoticeArray = Nil;
        if (vDataDic.count > 0) {
            vNoticeArray = [self getShangJiaInfo:vDataDic];
        }
        self.agentBusinessArray = vNoticeArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求车务商家" Notice:@""];
}

#pragma mark 初始化搜索
-(void)initSearchBuness{
    if (mSearchKey.length == 0) {
        return;
    }
    isInitWebData = YES;
    mSearchPageIndex = 0;
    mSearPageSize = 14;
    [self postSearchData];
}
#pragma mark 加载搜索数据
-(void)downLoadSearchBuness{
    if (mSearchKey.length == 0) {
        return;
    }
    isInitWebData = NO;
    mSearchPageIndex++;
    [self postSearchData];
}

#pragma mark 请求搜索数据
-(void)postSearchData{
    NSDictionary *vTestDic = @{
                               @"searchType":[NSNumber numberWithInt:mSearchType],
                               @"searchKey":mSearchKey,
                               @"pageIndex":[NSNumber numberWithInt:mSearchPageIndex],
                               @"pageSize":[NSNumber numberWithInt:mSearPageSize]};
    
    [NetManager postDataFromWebAsynchronous:APPURL330 Paremeter:vTestDic Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vNoticeArray = Nil;
        if (vDataDic.count > 0) {
            vNoticeArray = [self getShangJiaInfo:vDataDic];
        }
        self.agentBusinessArray = vNoticeArray;
        if (vNoticeArray.count > 0) {
            //隐藏附近服务列表
            if (mCleanCarVC.view.superview != Nil) {
                [mCleanCarVC.view removeFromSuperview];
                self.servicesContentView.hidden = YES;
            }
            [self.view addSubview:self.agentBunessTableView];
            [self.view bringSubviewToFront:self.agentBunessTableView];
        }else{
            [mCleanCarVC typeSelected:mCurrentServiceType BunessName:self.searchField.text];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"搜索商家" Notice:@""];
}

-(NSMutableArray *)getShangJiaInfo:(id)aData
{
    NSMutableArray *vArray = [NSMutableArray array];
    for (NSDictionary *dic in aData) {
        ShangJiaInfo *vShangJai = [[ShangJiaInfo alloc] init];
        vShangJai.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"] ];
        IFISNIL(vShangJai.name);
        vShangJai.address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
        IFISNIL(vShangJai.address);
        vShangJai.phone = [NSString stringWithFormat:@"%@", [dic objectForKey:@"phone"]];
        IFISNIL(vShangJai.phone);
        vShangJai.photo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"photo"]];
        IFISNIL(vShangJai.photo);
        vShangJai.isauthenticate = [[dic objectForKey:@"isauthenticate"] integerValue];
        vShangJai.stars = [[dic objectForKey:@"stars"] integerValue];
        
        double vlongitude = [[dic objectForKey:@"longitude"] doubleValue];
        double vlatitude = [[dic objectForKey:@"latitude"] doubleValue];
        CLLocationCoordinate2D v2d =  CLLocationCoordinate2DMake(vlatitude, vlongitude);
        vShangJai.pt = v2d;
        //计算离用户的位置的距离
        CLLocationCoordinate2D vUserLocation = [UserManager instanceUserManager].userCoord;
         int vDistance = (int)[BaiDuDataLoader distanceFromLocation:vUserLocation ToLocation:v2d];
        vShangJai.distance = vDistance;
        
        vShangJai.bunessId = [dic objectForKey:@"businessId"] ;
        IFISNIL(vShangJai.bunessId);
        vShangJai.minMoney = [dic objectForKey:@"minMoney"];
        IFISNIL(vShangJai.minMoney );
        vShangJai.maxMoney = [dic objectForKey:@"maxMoney"];
        IFISNIL(vShangJai.maxMoney);
        
        vShangJai.searchType = [dic objectForKey:@"searchType"];
        IFISNILFORNUMBER(vShangJai.searchType);
        
        vShangJai.serviceName = [dic objectForKey:@"serviceName"];
        IFISNIL(vShangJai.serviceName);
        
        [vArray addObject: vShangJai];
        SAFE_ARC_RELEASE(vShangJai);
    }
    
    //排序
    [vArray sortUsingComparator:^NSComparisonResult(ShangJiaInfo *obj1, ShangJiaInfo *obj2) {
        return  obj1.distance > obj2.distance;
    }];
    return vArray;
}

-(void)addBunessTable{
    [[self.view viewWithTag:1001] removeFromSuperview];
    [self.view addSubview:self.agentBunessTableView];
    [self.view bringSubviewToFront:self.ifHasBunessLable];
}

#pragma mark 加载搜索类型动画
-(void)moveDown{
    [UIView moveToView:mSearchTypeVC.view DestRect:mDestinaRect OriginRect:mOriginRect duration:.2 IsRemove:NO Completion:Nil];
}

#pragma mark 选定搜索后移除动画
-(void)moveUP{
    [UIView moveToView:mSearchTypeVC.view DestRect:mOriginRect OriginRect:mDestinaRect duration:.2 IsRemove:YES Completion:Nil];
}

#pragma mark 设置列表展示商家
-(void)setNormalShowBunessVC{
    [self.agentBunessTableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view bringSubviewToFront:self.agentBunessTableView];
}

#pragma mark 展示搜索展示商家
-(void)setSearchShowNunessVC{
    [self.agentBunessTableView setFrame:CGRectMake(0, self.agentBunessTableView.frame.origin.y, 320, self.agentBunessTableView.frame.size.height-44)];
}

#pragma mark - 其他业务点击事件
#pragma mark 选择地图或商家列表
-(void)tableOrMapButtonTouchDown:(id)sender{
    if ([self.view viewWithTag:1001] == Nil) {
        self.isMapClicked = YES;
        [self.agentBunessTableView removeFromSuperview];
        if (mNearByMapVC == Nil) {
            mNearByMapVC = [[BunessDetailMapVC alloc] init];
        }
        [mNearByMapVC.view setTag:1001];
        [mNearByMapVC adddAnnotation:self.agentBusinessArray SearchType:stAgent];
        [self.view addSubview:mNearByMapVC.view];
    }
}

#pragma mark 选择商家区域
-(void)changeDistrictButtonTouchDown:(id)sender{
    UIView *vDistrictView = [self.view viewWithTag:1000];
    if (vDistrictView == Nil) {
        [self goToChosePlaceVC:Nil];
    }else{
        //设置动画
        [UIView moveToView:vDistrictView DestRect:CGRectMake(0, -200, 320, 300) OriginRect:vDistrictView.frame duration:.2 IsRemove:YES Completion:Nil];
    }
}

#pragma mark 区域选择完毕
-(void)didFinishChosedPlace:(NSDictionary *)sender{
    UIView *vDistrictView = [self.view viewWithTag:1000];
    //设置动画
    [UIView moveToView:vDistrictView DestRect:CGRectMake(0, -200, 320, 300) OriginRect:vDistrictView.frame duration:.2 IsRemove:YES Completion:Nil];
    //设置新的区域，重新请求数据，同时更改标题
    self.placeDic = sender;
}

#pragma mark 点击搜索
- (IBAction)searchButtonTouchDown:(id)sender {
    if (self.searchField.text.length == 0) {
        return;
    }
    
    mSearchKey = self.searchField.text;
    [self initSearchBuness];
}

- (IBAction)searTypeTouchDonw:(id)sender {
    if (mSearchTypeVC.view.superview == Nil) {
        [self.view addSubview:mSearchTypeVC.view];
        [self.view bringSubviewToFront:self.middleContentView];
        [self moveDown];
    }else{
        [self moveUP];
    }
}

- (IBAction)needEatButtonClicked:(id)sender {
    if (self.agentBunessTableView.superview != Nil) {
        [self.agentBunessTableView removeFromSuperview];
    }
    
    self.servicesContentView.hidden = NO;
    [self.servicesContentView addSubview:mCleanCarVC.view];
    [self.view bringSubviewToFront:self.servicesContentView];
    [mCleanCarVC typeSelected:stFood BunessName:Nil];
    mCurrentServiceType = stFood;

    [self moveUP];
}

- (IBAction)needSleepButtonClicked:(id)sender {
    if (self.agentBunessTableView.superview != Nil) {
        [self.agentBunessTableView removeFromSuperview];
    }
    
    self.servicesContentView.hidden = NO;
    [self.servicesContentView addSubview:mCleanCarVC.view];
    [self.view bringSubviewToFront:self.servicesContentView];
    [mCleanCarVC typeSelected:stHotel BunessName:Nil];
    mCurrentServiceType = stHotel;
    [self moveUP];
}

- (IBAction)needPlayButtonClicked:(id)sender {
    if (self.agentBunessTableView.superview != Nil) {
        [self.agentBunessTableView removeFromSuperview];
    }
    self.servicesContentView.hidden = NO;
    [self.servicesContentView addSubview:mCleanCarVC.view];
    [self.view bringSubviewToFront:self.servicesContentView];
    [mCleanCarVC typeSelected:stViewPoint BunessName:Nil];
    mCurrentServiceType = stViewPoint;
    [self moveUP];
}
#pragma mark 搜索类型选择完毕
-(void)didAgentSearchTypeVCSeletedType:(NSInteger)aType Name:(NSString *)aName{
    mSearchType = aType;
    [self.searchTypeButton setTitle:aName forState:UIControlStateNormal];
    [self moveUP];
}

#pragma mark 屏幕点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(mSearchTypeVC.view.frame,vTouchPoint)
        ) {
        [self searTypeTouchDonw:Nil];
    }
}
- (void)viewDidUnload {
   [self setAgentBunessTableView:nil];
    [self setIfHasBunessLable:nil];
   [super viewDidUnload];
}
@end
