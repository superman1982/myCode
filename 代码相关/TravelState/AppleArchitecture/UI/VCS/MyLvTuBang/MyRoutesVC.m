//
//  MyRoutesVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyRoutesVC.h"
#import "MyRoutesCell.h"
#import "NetManager.h"
#import "ActiveDetailVC.h"
#import "ActivityRouteManeger.h"
#import "UserManager.h"
#import "MyRouteOrderDetailVC.h"

@interface MyRoutesVC ()
{
    NSInteger    mPageIndex;
    NSInteger    mPageSize ;
    BOOL         isInitWebData;
}
@property (nonatomic,retain) NSMutableArray *routesArray;
@end

@implementation MyRoutesVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"MyRoutesVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyRoutesVC" bundle:aBuddle];
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
    self.title = @"我的行程";
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
    [_routeTableView release];
    [_contentView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self.contentView addSubview:self.routeTableView];
    [self initWebData];
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

-(void)setRoutesArray:(NSMutableArray *)routesArray{
    if (_routesArray == Nil) {
        _routesArray = [[NSMutableArray alloc] init];
    }
    if (isInitWebData) {
        [_routesArray removeAllObjects];
    }
    [_routesArray addObjectsFromArray:routesArray];
    [self.routeTableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger vRowCount = self.routesArray.count;
    if (vRowCount > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return vRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"routesCell";
    MyRoutesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRoutesCell" owner:self options:Nil] objectAtIndex:0];
        SAFE_ARC_AUTORELEASE(cell);
    }
    
    NSInteger vIndex = indexPath.row;
    [cell setCell:[self.routesArray objectAtIndex:vIndex]];
    cell.imageView.backgroundColor = [UIColor darkGrayColor];
    return cell;
    
    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*//获取活动ID
    ActiveInfo *vInfo = [self.routesArray objectAtIndex:indexPath.row];
    NSNumber *activityID = vInfo.ActivityId;
    //组合请求参数
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:activityID,@"activityId", nil];
    //请求数据
    NSData *vReturnData = [NetManager postToURLSynchronous:APPURL402 Paremeter:vParemeter timeout:30 RequestName:@"请求活动详情"];
    NSDictionary *vDataDic = [[NetManager jsonToDic:vReturnData] objectForKey:@"data"];
    //跳转页面
    [ViewControllerManager createViewController:@"ActiveDetailVC"];
    ActiveDetailVC *vAcDetailVC = (ActiveDetailVC *)[ViewControllerManager getBaseViewController:@"ActiveDetailVC"];
    vAcDetailVC.detailDic = vDataDic;
    vAcDetailVC.acticeInfo = vInfo;
    [ViewControllerManager showBaseViewController:@"ActiveDetailVC" AnimationType:vaDefaultAnimation SubType:0];*/
    [ViewControllerManager createViewController:@"MyRouteOrderDetailVC"];
    MyRouteOrderDetailVC *vVC = (MyRouteOrderDetailVC *)[ViewControllerManager getBaseViewController:@"MyRouteOrderDetailVC"];
    ActiveInfo *vInfo = [self.routesArray objectAtIndex:indexPath.row];
    vVC.activityId = vInfo.ActivityId;
    vVC.routeImageURLStr = vInfo.activeImages;
    [ViewControllerManager showBaseViewController:@"MyRouteOrderDetailVC" AnimationType:vaDefaultAnimation SubType:0];
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
    
    if (aRefreshPos == 0) {
        //刷新
        [self initWebData];
    }else if (aRefreshPos == 1){
        //加载
        [self downLoadWebDta];
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
    
    if (self.routesArray.count >= 10) {
        [self setFooterView];
    }
    
}

#pragma mark - 其他辅助功能

#pragma mark 初始化网络请求数据
-(void)initWebData{
    isInitWebData = YES;
    mPageIndex = 0;
    mPageSize = 14;
    //获取参数
    NSDictionary *vParemeter = [self setPostPageIndex:mPageIndex PageSize:mPageSize];

    [self postWebData:vParemeter];
}

#pragma mark 下载我的行程数据
-(void)downLoadWebDta{
    isInitWebData = NO;
    mPageIndex++;
    NSDictionary *vParemeter = [self setPostPageIndex:mPageIndex PageSize:mPageSize];
    [self postWebData:vParemeter];
}

#pragma mark 刷新数据
-(void)refreshWebData{
    isInitWebData = YES;
    NSDictionary *vParemeter = [self setPostPageIndex:0 PageSize:mPageSize*(mPageIndex+1)];
    [self postWebData:vParemeter];
}

#pragma mark 组合请求参数
-(NSDictionary *)setPostPageIndex:(NSInteger)aPageIndex
                             PageSize:(NSInteger)aPageSize
{
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                [NSNumber numberWithInt:aPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:aPageSize],@"pageSize",
                                nil];
    return vParemeter;
}

#pragma mark 请求我的行程数据
-(void)postWebData:(NSDictionary *)aParemeter{
    
    [NetManager postDataFromWebAsynchronous:APPURL815 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vMyRoutesArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDataDic) {
            ActiveInfo *vActiveInfo = [[ActiveInfo alloc] init];
            vActiveInfo.ActivityId = [vDic objectForKey:@"activityId"];
            id vType = [vDic objectForKey:@"type"];
            if ([vType intValue] == 1) {
                vActiveInfo.type = atActiveRoutes;
            }else if ([vType intValue] == 2){
                vActiveInfo.type = atRecomendRoutes;
            }
            vActiveInfo.isOfficial = [vDic objectForKey:@"isOfficial"];
            vActiveInfo.shareCount = [vDic objectForKey:@"shareCount"];
            IFISNILFORNUMBER(vActiveInfo.shareCount);
            vActiveInfo.praiseCount = [vDic objectForKey:@"praiseCount"];
            IFISNILFORNUMBER(vActiveInfo.praiseCount);
            vActiveInfo.comentCount = [vDic objectForKey:@"commentCount"];
            IFISNILFORNUMBER(vActiveInfo.comentCount);
            vActiveInfo.activeTitle = [vDic objectForKey:@"activityTitle"];
            vActiveInfo.activeImages = [vDic objectForKey:@"activityImage"];
            vActiveInfo.activeTime = [vDic objectForKey:@"activityTime"];
            IFISNIL(vActiveInfo.activeTime);
           
            vActiveInfo.listingPrice = [vDic objectForKey:@"listingPrice"];
            IFISNILFORNUMBER(vActiveInfo.listingPrice);
            vActiveInfo.memberPrice = [vDic objectForKey:@"memberPrice"];
            IFISNILFORNUMBER(vActiveInfo.memberPrice);
            vActiveInfo.singupNumber = [vDic objectForKey:@"signupNumber"];
            IFISNILFORNUMBER(vActiveInfo.singupNumber);
            
            vActiveInfo.rouadBookURL = [vDic objectForKey:@"roadBookUrl"];
            vActiveInfo.isSignup = [vDic objectForKey:@"isSignup"];
            IFISNILFORNUMBER(vActiveInfo.isSignup);
            vActiveInfo.isIncludeSelf = [vDic objectForKey:@"isIncludeSelf"];
            IFISNILFORNUMBER(vActiveInfo.isIncludeSelf);
            vActiveInfo.totalSignup = [vDic objectForKey:@"totalSignup"];
            IFISNILFORNUMBER(vActiveInfo.totalSignup);
            vActiveInfo.allowNoMember = [vDic objectForKey:@"allowNoMember"];
            IFISNILFORNUMBER(vActiveInfo.allowNoMember);
            vActiveInfo.lodingMoney = [vDic objectForKey:@"lodgingMoney"];
            IFISNILFORNUMBER(vActiveInfo.lodingMoney);
            vActiveInfo.insuranceMone = [vDic objectForKey:@"insuranceMoney"];
            IFISNILFORNUMBER(vActiveInfo.insuranceMone);
            vActiveInfo.isIncludeInsurance = [vDic objectForKey:@"isIncludeInsurance"];
            IFISNILFORNUMBER(vActiveInfo.isIncludeInsurance);
            
            [vMyRoutesArray addObject:vActiveInfo];
        }
        self.routesArray = vMyRoutesArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求活动路书" Notice:@""];
}


- (void)viewDidUnload {
[self setRouteTableView:nil];
    [self setContentView:nil];
[super viewDidUnload];
}
@end
