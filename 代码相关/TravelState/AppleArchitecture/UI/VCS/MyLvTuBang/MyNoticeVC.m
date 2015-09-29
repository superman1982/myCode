//
//  MyNoticeVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyNoticeVC.h"
#import "NoticeCell.h"
#import "UserManager.h"
#import "NetManager.h"

@interface MyNoticeVC ()
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    NSInteger mPageIndex;
    NSInteger mPageSize;
    NSInteger mType;  //请求提醒类型
    BOOL      isInitWebData;
    AgentSearchTypeVC *mSearchTypeVC;
    CGRect mOriginRect ;  //搜索类型位置
    CGRect mDestinaRect; //搜索类型移动位置
}

@property (nonatomic,retain)   NSMutableArray *mNoticeInfoArray;

@end


@implementation MyNoticeVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"MyNoticeVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyNoticeVC" bundle:aBuddle];
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
    self.title = @"我的提醒";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"全部" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(searTypeTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
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
    [_mNoticeInfoArray removeAllObjects],_mNoticeInfoArray = nil;
    [_noticeTableView release];
    [_refreshFooterView release];
    [_refreshHeaderView release];
    [_agentButton release];
    [_insuranceButton release];
    [_chongZhiButton release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self createHeaderView];
//    [self cheWuDaiBanClicked:Nil];
    if (mSearchTypeVC == Nil) {
        mSearchTypeVC = [[AgentSearchTypeVC alloc] init];
        mSearchTypeVC.delegate = self;
        NSArray *vTypeArray = @[@"全      部",
                                @"车务代办",
                                @"保      险",
                                @"冲      值",
                                @"交      易",
                                ];
        mSearchTypeVC.tableWidth = 90;
        mSearchTypeVC.typeArray = [vTypeArray mutableCopy];
    }
    
    mOriginRect = CGRectMake(320-mSearchTypeVC.view.frame.size.width,-30,mSearchTypeVC.view.frame.size.width,  mSearchTypeVC.view.frame.size.height);
    mDestinaRect = CGRectMake(320-mSearchTypeVC.view.frame.size.width, 0,mSearchTypeVC.view.frame.size.width,  mSearchTypeVC.view.frame.size.height);
    [self initWebData];
    self.noticeTableView.clickeDelegate = self;
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
    _refreshHeaderView = nil;
    _refreshFooterView = nil;
    [super viewShouldUnLoad];
}

//----------

-(void)setMNoticeInfoArray:(NSMutableArray *)mNoticeInfoArray{
    if (_mNoticeInfoArray == Nil) {
        _mNoticeInfoArray = [[NSMutableArray alloc] init];
    }
    if (isInitWebData) {
        [_mNoticeInfoArray removeAllObjects];
    }
    [_mNoticeInfoArray addObjectsFromArray:mNoticeInfoArray];
    [self.noticeTableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger vRowIndex = _mNoticeInfoArray.count;
    if (vRowIndex > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return vRowIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"NoticeCell";
    NoticeCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCell" owner:self options:nil] objectAtIndex:0];
    }
    NSDictionary *vDic = [_mNoticeInfoArray objectAtIndex:indexPath.row];
    vCell.timeLable.text = [vDic objectForKey:@"remindDate"];
    IFISNIL(vCell.timeLable.text);
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                                     self.noticeTableView.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    
	[self.noticeTableView addSubview:_refreshHeaderView];
    
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
    CGFloat height = MAX(self.noticeTableView.contentSize.height, self.noticeTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.noticeTableView.frame.size.width,
                                              self.noticeTableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.noticeTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.noticeTableView addSubview:_refreshFooterView];
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
		self.noticeTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.noticeTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.noticeTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.noticeTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.noticeTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.noticeTableView];
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
        [self initWebData];
    }else if (aRefreshPos == 1){
        [self loadWebData];
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
    
    if (_mNoticeInfoArray.count >= 10) {
        
        [self setFooterView];
    }
    
}


#pragma mark - 其他辅助功能
#pragma mark 下载数据初始化
-(void)initWebData{
    isInitWebData = YES;
    id vUserID = [UserManager instanceUserManager].userID;
    mPageIndex = 0;
    mPageSize = 14;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                [NSNumber numberWithInt:mType],@"type",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    [self postToWeb:vParemeter];
    
}
#pragma mark 下载数据设置
-(void)loadWebData{
    isInitWebData = NO;
    mPageIndex++;
     id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                [NSNumber numberWithInt:mType],@"type",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    [self postToWeb:vParemeter];
}

#pragma mark 请求数据
-(void)postToWeb:(NSDictionary *)aParemeter{
    [NetManager postDataFromWebAsynchronous:APPURL803 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vNoticeArray = Nil;
        if (vDataDic.count > 0) {
            vNoticeArray = [NSMutableArray array];
            for (NSDictionary *vDic in vReturnDic) {
                [vNoticeArray addObject:vDic];
            }
        }
        self.mNoticeInfoArray = vNoticeArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"请求我的提醒" Notice:@""];
}

#pragma mark 初始化button状态
-(void)clearButtons{
    [self.agentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.agentButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    [self.insuranceButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.insuranceButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    [self.chongZhiButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.chongZhiButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
}

#pragma mark 加载搜索类型动画
-(void)moveDown{
    [UIView moveToView:mSearchTypeVC.view DestRect:mDestinaRect OriginRect:mOriginRect duration:.2 IsRemove:NO Completion:Nil];
}

#pragma mark 选定搜索后移除动画
-(void)moveUP{
    [UIView moveToView:mSearchTypeVC.view DestRect:mOriginRect OriginRect:mDestinaRect duration:.2 IsRemove:YES Completion:Nil];
}

#pragma mark 获取订单类型
-(NSString *)getType:(NSInteger)aIndex{
    NSArray *vTypeArray =@[@"全部",
                           @"车务代办",
                           @"保险",
                           @"冲值",
                           @"交易",
                           ];
    return [vTypeArray objectAtIndex:aIndex];
}


#pragma mark  - 其他业务点击事件
#pragma mark 车务代办
- (IBAction)cheWuDaiBanClicked:(id)sender {
    mType = 1;
    [self initWebData];
    [self clearButtons];
    [self.agentButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
    [self.agentButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
}

#pragma mark 保险
- (IBAction)insuranceClicked:(id)sender {
    mType = 2;
    [self initWebData];
    [self clearButtons];
    [self.insuranceButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
    [self.insuranceButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
}

#pragma mark 充值
- (IBAction)chongZhiClicked:(id)sender {
    mType = 3;
    [self initWebData];
    [self clearButtons];
    [self.chongZhiButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
    [self.chongZhiButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
}


- (void)searTypeTouchDown:(id)sender {
    if (mSearchTypeVC.view.superview == Nil) {
        [self.view addSubview:mSearchTypeVC.view];
        [self moveDown];
    }else{
        [self moveUP];
    }
}

#pragma mark 搜索类型选择完毕
-(void)didAgentSearchTypeVCSeletedType:(NSInteger)aType Name:(NSString *)aName{
    //搜索类型
    NSString *vTypStr = [self getType:aType];
    mType = aType;
    //重设button宽度
    float vButtonWidth = 40;
    if (mType == 1) {
        vButtonWidth = 80;
    }
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:vTypStr forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, vButtonWidth, 44)];
    [vRightButton addTarget:self action:@selector(searTypeTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
    
    [self moveUP];
    [self initWebData];
}

-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(mSearchTypeVC.view.frame,vTouchPoint)) {
        [self moveUP];
    }
}

- (void)viewDidUnload {
[self setNoticeTableView:nil];
    [self setAgentButton:nil];
    [self setInsuranceButton:nil];
    [self setChongZhiButton:nil];
[super viewDidUnload];
}
@end
