//
//  KJFWTableView.m
//  CTB
//
//  Created by klbest1 on 13-7-11.
//  Copyright (c) 2013年 My. All rights reserved.
//

#import "CleanCarView.h"
#import "CleanCarTableViewCell.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "ShangJiaInfo.h"
#import "StringHelper.h"

@interface CleanCarView ()
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    NSMutableArray *qcmrTempAray;
    
    BOOL RenZhenFlag_;
    NSString *imageHttp_;
    CLLocationCoordinate2D myPt_;
    BaiDuDataLoader *mQcmrDataLoader;
}
@end

@implementation CleanCarView
@synthesize qcmrInfoArr = mQcmrInfoArr;
@synthesize searchType = mSearchType;
@synthesize KJTableViewdelegate = _KJTableViewdelegate;
@synthesize tableInfoArray = qcmrTempAray;

@synthesize parentVC;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self comInit];
    }
    return self;
}

//chauffeur_drive 代驾
//Refit 改装
//maintenance 维修
//wash_cosmetology 洗车

-(void)comInit{
    myPt_ = CLLocationCoordinate2DMake(30.630415, 104.050654);
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _tableView.rowHeight = 96;
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    //添加没有商家提示
    UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    vLable.text = @"本地区暂无商家";
    vLable.textColor = [UIColor darkGrayColor];
    vLable.center = self.center;
    vLable.hidden = YES;
    vLable.textAlignment = NSTextAlignmentCenter;
    [vLable setTag:11000];
    [self.tableView addSubview:vLable];
    SAFE_ARC_RELEASE(vLable);
    
    [self webDataInit];

}

-(void)webDataInit{

    [self createHeaderView];
    mQcmrInfoArr = [[NSMutableArray alloc] init];
    qcmrTempAray = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    //初始化dataloader类的信息
    mQcmrDataLoader = [[BaiDuDataLoader alloc] init];
    mQcmrDataLoader.delegate = self;
    
}

-(void)loadBusiness:(SearchType)aType
          BaiDuParemeter:(struct BaiDuCould)aBaiDu
           SortFlag:(SortType)aSortType
       BusinessName:(NSString *)aBusynessName{
    mSearchType = aType ;
    [self.qcmrInfoArr removeAllObjects];
    [mQcmrDataLoader searchBusiness:aType BaiDuParemeter:aBaiDu SortFlag:aSortType BusinessName:aBusynessName];
}


-(void)reloadShangJiaData{
    [qcmrTempAray removeAllObjects];
    qcmrTempAray = nil;
    qcmrTempAray = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    [self.tableView reloadData];

}

#pragma mark TableView DataSource And Delegate
//1个section有多少条记录
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (qcmrTempAray.count == 10 && mQcmrInfoArr.count > 0) {   //缓存数组加载
        
        NSRange range = NSMakeRange(0,10);
        if (mQcmrInfoArr.count < 10) {
            range = NSMakeRange(0, mQcmrInfoArr.count);
            NSRange range1 = NSMakeRange(mQcmrInfoArr.count, qcmrTempAray.count - mQcmrInfoArr.count);
            [qcmrTempAray removeObjectsInRange:range1];
        }
        [qcmrTempAray replaceObjectsInRange:range withObjectsFromArray:mQcmrInfoArr range:range];
        //添加分隔线
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return qcmrTempAray.count;
    }
    else if(qcmrTempAray.count > 10){
        //添加分隔线
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return qcmrTempAray.count;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return 0;
}

//table分类数目
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (qcmrTempAray.count >= 10) {
        [self setFooterView];
    }
    
    NSInteger index = indexPath.row;
    switch (mSearchType) {
        case stWash_Consmetology:
            {
                static NSString *cellIdentify = @"QCMRCell";
                CleanCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
                if(cell == nil)
                {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"CleanCarTableViewCell" owner:self options:nil] objectAtIndex:0] ;
                }
                [cell setCell:[qcmrTempAray objectAtIndex:index]];
                
                return cell;
            }
            break;
        default:
           {
               static NSString *cellIdentify = @"QCMRCell";
               CleanCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
              if(cell == nil)
              {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CleanCarTableViewCell" owner:self options:nil] objectAtIndex:0] ;
              }
            
              [cell setCell:[qcmrTempAray objectAtIndex:index]];
            
               return cell;
           }
            break;
    }
    
    return nil;
}


//加载商家详细页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShangJiaInfo *vShangJiaData = [qcmrTempAray objectAtIndex:indexPath.row];
  
    if ([_KJTableViewdelegate respondsToSelector:@selector(didSelectedRowAtKJTableview:)]) {
        [_KJTableViewdelegate didSelectedRowAtKJTableview:vShangJiaData];
    }
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
                                     self.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    
	[self.tableView addSubview:_refreshHeaderView];
    
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
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableView.frame.size.width,
                                              self.tableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
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
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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

        
    }else if (aRefreshPos == 1)
    {

        if (mQcmrInfoArr.count > 0) {
         
            NSInteger rangeStart = qcmrTempAray.count;
            NSInteger rangeLength = 10;
            if ((rangeStart + rangeLength) >= mQcmrInfoArr.count) {
                rangeLength = mQcmrInfoArr.count - qcmrTempAray.count;
            }
            NSRange range = NSMakeRange(rangeStart,rangeLength);
            
            NSMutableArray *tempArray  = [NSMutableArray array];
            for (int i = 0; i < rangeLength; i++) {
                [tempArray addObject:@"0"];
            }
            [qcmrTempAray addObjectsFromArray:tempArray];
            [qcmrTempAray replaceObjectsInRange:range withObjectsFromArray:mQcmrInfoArr range:range];
            qcmrTempAray.count > 10  ? [self.tableView reloadData]: 0;  //更改
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
    
}

#pragma mark BaiDuDataLoaderDelegate -------
-(void)removeProgress{
    [SVProgressHUD dismiss];
}

-(void)addDataToUI{
    [self reloadShangJiaData];
    [self removeProgress];
}

-(void)begainLoadBaiduCloundData:(id)sender{
    [SVProgressHUD showWithStatus: @"加载中"];
}

-(void)LoadBaiduCloundWithNoDataExist:(id)sender{
}

-(void)LoadBaiduCloundDataFailure:(id)sender{
    if (mQcmrInfoArr.count > 0) {
        [mQcmrInfoArr removeAllObjects];
    }
    [SVProgressHUD showErrorWithStatus: @"加载失败"];
}

-(void)LoadBaiduCloundDataFinished:(NSMutableArray *)aData{
 
    if (aData.count > 0) {
        [mQcmrInfoArr addObjectsFromArray:aData];
    }
    //暂无商家lable
    UIView *vView = [self.tableView viewWithTag:11000];
    if (mQcmrInfoArr.count > 0) {
        vView.hidden = YES;
    }else{
        vView.hidden = NO;
    }
}

-(void)LoadBaiDuSearchFailer:(id)sender{
    [self addDataToUI];
}

-(void)LoadBaiDuSearchFinish:(NSMutableArray *)aBaiDuSearchData{
    //暂无商家lable
    UIView *vView = [self.tableView viewWithTag:11000];
    if (aBaiDuSearchData.count > 0) {
        [mQcmrInfoArr addObjectsFromArray:aBaiDuSearchData];
        //隐藏暂无商家
    }
    if (mQcmrInfoArr.count > 0) {
        vView.hidden = YES;
    }else{
        vView.hidden = NO;
    }
    [self addDataToUI];
}

#pragma mark 提示是否有商家
-(void)setNoticeUI{
    //暂无商家lable
    UIView *vView = [self.tableView viewWithTag:11000];
    if (mQcmrInfoArr.count > 0) {
        vView.hidden = YES;
    }else{
        vView.hidden = NO;
    }
}

#if __has_feature(objc_arc)
#else
-(void)dealloc{
    [mQcmrInfoArr removeAllObjects],mQcmrInfoArr = nil;
    [qcmrTempAray removeAllObjects],qcmrTempAray = nil;
    [super dealloc];
}
#endif
@end
