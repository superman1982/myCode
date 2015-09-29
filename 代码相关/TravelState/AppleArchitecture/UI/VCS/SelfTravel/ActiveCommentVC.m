//
//  ActiveCommentVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-12.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ActiveCommentVC.h"
#import "NetManager.h"
#import "BunessCommentCell.h"
#import "UserManager.h"
#import "ActivityRouteManeger.h"

@interface ActiveCommentVC ()
{
    BOOL   isInitWebData;
    NSInteger mPageSize;
    NSInteger mPageIndex;
}
@property (nonatomic,retain) NSMutableArray *commentArray;

@end

@implementation ActiveCommentVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"ActiveCommentVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ActiveCommentVC" bundle:aBuddle];
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
    self.title = @"活动评价";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

//初始化数据
-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_commentArray removeAllObjects];
    [_commentArray release];
    [_commentTableView release];
    [_commentTextField release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView: (BOOL) aPortait {
    [self initWebData];
    [self createHeaderView];
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
    }else{
    }
}

//------------------------------------------------

-(void)setCommentArray:(NSMutableArray *)commentArray{
    if (_commentArray == Nil) {
        _commentArray = [[NSMutableArray alloc] init];
    }
    if (isInitWebData) {
        [_commentArray removeAllObjects];
    }
    [_commentArray addObjectsFromArray:commentArray];
    [self.commentTableView reloadData];
}


#pragma mark UITableViewDataSource -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger vRowCount = self.commentArray.count;
    if (vRowCount > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return vRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BunessCommentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BunessCommentCell" owner:self options:nil] objectAtIndex:0];
    NSString *vContentStr = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    [cell setHightOfCell:vContentStr];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"commentCell";
    BunessCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BunessCommentCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.starImageView.hidden = YES;
    [cell setCell:[self.commentArray objectAtIndex:indexPath.row]];
    return cell;
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
                                     self.commentTableView.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    
	[self.commentTableView addSubview:_refreshHeaderView];
    
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
    CGFloat height = MAX(self.commentTableView.contentSize.height, self.commentTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.commentTableView.frame.size.width,
                                              self.commentTableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.commentTableView.frame.size.width, self.commentTableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.commentTableView addSubview:_refreshFooterView];
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
		self.commentTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.commentTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}else{
        self.commentTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.commentTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.commentTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.commentTableView];
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
        [self downLoadWebData];
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
    
    if (_commentArray.count >= 10) {
        [self setFooterView];
    }
    
}


#pragma mark - 其他辅助功能
-(void)initWebData{
    isInitWebData = YES;
    mPageSize = 14;
    mPageIndex = 0;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.activeInfo.ActivityId ,@"activityId",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                [NSNumber numberWithInt:0],@"type",
                                nil];
    [self postWebData:vParemeter];
}

-(void)downLoadWebData{
    isInitWebData = NO;
    mPageIndex++;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.activeInfo.ActivityId,@"businessId",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                [NSNumber numberWithInt:0],@"type",
                                nil];
    [self postWebData:vParemeter];
}

-(void)postWebData:(NSDictionary *)aParemeter{
    [NetManager postDataFromWebAsynchronous:APPURL406 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vCommentsArray = [NSMutableArray array];
        if (vDataDic.count > 0) {
            NSDictionary *vCommentDic = [vDataDic objectForKey:@"comment"];
            for (NSDictionary *vDic in vCommentDic) {
                [vCommentsArray addObject:vDic];
            }
        }
        self.commentArray = vCommentsArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求活动评论" Notice:@""];
}

#pragma mark 其他业务点击事件
- (IBAction)publishClicked:(id)sender {
    if (![ActivityRouteManeger checkIfIsLogin]) {
        return;
    }
    
    if (self.commentTextField.text.length> 0) {
        NSMutableDictionary *vParemeter = [NSMutableDictionary dictionary];
        id vUserID = [UserManager instanceUserManager].userID;
        [vParemeter setObject:vUserID forKey:@"userId"];
        id activityId = self.activeInfo.ActivityId;
        [vParemeter setObject:activityId forKey:@"activityId"];
        [vParemeter setObject:[NSNumber numberWithInt:0] forKey:@"score"];
        [vParemeter setObject:self.commentTextField.text forKey:@"commentContent"];
        [ActivityRouteManeger postSharePraseCommentData:APPURL405 Paremeter:vParemeter Prompt:@"" RequestName:@"评论"];
        [self.commentTextField resignFirstResponder];
        if (self.commentArray.count > 0) {
            [self.commentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

-(void)refreshUI{
    [self initWebData];
    self.commentTextField.text = @"";
}
- (void)viewDidUnload {
[self setCommentTableView:nil];
    [self setCommentTextField:nil];
[super viewDidUnload];
}
@end
