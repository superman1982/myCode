//
//  MessageVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
#import "UserManager.h"
#import "NetManager.h"

@interface MessageVC ()
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    NSInteger mPageIndex;
    NSInteger mPageSize;
    BOOL     isInitWebData;
}
@property (nonatomic,retain)   NSMutableArray *mMessageInfoArray;
@end

@implementation MessageVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"MessageVC_2x" bundle:aBuddle];
    }else {
        self = [super initWithNibName:@"MessageVC" bundle:aBuddle];
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
    self.title = @"我的消息";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    [self initWebData];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_mMessageInfoArray removeAllObjects],_mMessageInfoArray = nil;
    [_messageTableView release];
    [_refreshFooterView release];
    [_refreshHeaderView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self createHeaderView];
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
    _messageTableView = nil;
    [super viewShouldUnLoad];
}
//----------

-(void)setMMessageInfoArray:(NSMutableArray *)mMessageInfoArray{
    if (_mMessageInfoArray == Nil) {
        _mMessageInfoArray = [[NSMutableArray alloc] init];
    }
    if (isInitWebData) {
        [_mMessageInfoArray removeAllObjects];
    }
    [_mMessageInfoArray addObjectsFromArray:mMessageInfoArray];
    [self.messageTableView reloadData];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger vRowIndex = _mMessageInfoArray.count;
    if (vRowIndex > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mMessageInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"MessCell";
    MessageCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:0];
    }
    NSDictionary *vDic = [_mMessageInfoArray objectAtIndex:indexPath.row];
    vCell.messageLable.text = [vDic objectForKey:@"title"];
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
                                     self.messageTableView.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    
	[self.messageTableView addSubview:_refreshHeaderView];
    
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
    CGFloat height = MAX(self.messageTableView.contentSize.height, self.messageTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.messageTableView.frame.size.width,
                                              self.messageTableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.messageTableView.frame.size.width, self.messageTableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.messageTableView addSubview:_refreshFooterView];
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
		self.messageTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.messageTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}else{
        self.messageTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.messageTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.messageTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.messageTableView];
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
    
    if (_mMessageInfoArray.count >= 10) {
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
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    [self postToWeb:vParemeter];
}

#pragma mark 请求数据
-(void)postToWeb:(NSDictionary *)aParemeter{
    [NetManager postDataFromWebAsynchronous:APPURL804 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vNoticeArray = Nil;
        if (vDataDic.count > 0) {
            vNoticeArray = [NSMutableArray array];
            for (NSDictionary *vDic in vReturnDic) {
                [vNoticeArray addObject:vDic];
            }
        }
        self.mMessageInfoArray = vNoticeArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"我的消息" Notice:@""];
}


- (void)viewDidUnload {
    [self setMessageTableView:nil];
    [super viewDidUnload];
}
@end
