//
//  NeedCarVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "NeedCarVC.h"
#import "MakeCarCell.h"
#import "NetManager.h"
#import "UserManager.h"
#import "AgrementVC.h"
#import "Toast+UIView.h"

@interface NeedCarVC ()
{
    NSMutableDictionary *mSelectedDic;
    NSMutableArray *mCells;
    NSNumber *mChosedRow;
    BOOL mIsAgreeAgrement;
    NSInteger mMaxSeats;
}
@end

@implementation NeedCarVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
              self = [super initWithNibName:@"NeedCarVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"NeedCarVC" bundle:aBuddle];
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
    self.title = @"选择拼车车辆";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(carInfoConfirmButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mCells = [[NSMutableArray alloc] init];
    mSelectedDic = [[NSMutableDictionary alloc] init];
    mIsAgreeAgrement = YES;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mSelectedDic removeAllObjects];
    [mSelectedDic release];
    [mCells removeAllObjects],[mCells release];
    [_refreshFooterView release];
    [_refreshHeaderView release];
    [_activeInfo release];
    [_needCarInfo removeAllObjects],_needCarInfo = Nil;
    [_needCarTableView release];
    [_zanWuCheliangLable release];
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
    [super viewShouldUnLoad];
}
//----------

-(void)setNeedCarInfo:(NSMutableArray *)needCarInfo{
    if (_needCarInfo == Nil) {
        _needCarInfo = [[NSMutableArray alloc] init];
    }
    [_needCarInfo addObjectsFromArray:needCarInfo];
    [self.needCarTableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

#pragma mark table背景颜色
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return self.agreementFooterView.frame.size.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return self.agreementFooterView;
    }
    return Nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSInteger vRow = _needCarInfo.count;
        if (vRow > 0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.zanWuCheliangLable.hidden = YES;
        }else{
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.zanWuCheliangLable.hidden = NO;
        }
        return vRow;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MakeCarCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"MakeCarCell" owner:self options:Nil] objectAtIndex:0];
    vCell.delegate = self;
    
    if (indexPath.section == 0) {
        vCell.index = indexPath.row;
        [self addCell:vCell];
        NSDictionary *vDic = [self.needCarInfo objectAtIndex:indexPath.row];
        [vCell setCell:vDic chosedIndex:mChosedRow];
    }
    
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
                                     self.needCarTableView.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    
	[self.needCarTableView addSubview:_refreshHeaderView];
    
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
    CGFloat height = MAX(self.needCarTableView.contentSize.height, self.needCarTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.needCarTableView.frame.size.width,
                                              self.needCarTableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.needCarTableView.frame.size.width, self.needCarTableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.needCarTableView addSubview:_refreshFooterView];
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
		self.needCarTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.needCarTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}else{
        self.needCarTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.needCarTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.needCarTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.needCarTableView];
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
    }else if (aRefreshPos == 1){
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
    
    if (_needCarInfo.count >= 10) {
        [self setFooterView];
    }
    
}


#pragma mark MakeCarCellDelegate
-(void)didMakeCarCellChecked:(NSNumber *)sender{
    NSInteger vCheckedRow = [sender intValue];
    if (self.needCarInfo.count > vCheckedRow) {
        NSDictionary *vSeletedDic = [self.needCarInfo objectAtIndex:vCheckedRow];
        id vProviID = [vSeletedDic objectForKey:@"signupUserId"];
        IFISNIL(vProviID);
        [mSelectedDic setObject:vProviID forKey:@"provideCarId"];
        
        mMaxSeats = [[vSeletedDic objectForKey:@"seatQuantity"] intValue];
        self.seatNumberButton.text = [NSString stringWithFormat:@"%d",mMaxSeats];
        
        NSInteger vSeat = [self.seatNumberButton.text intValue];
        [mSelectedDic setObject:[NSNumber numberWithInt:vSeat] forKey:@"needSeat"];
    }
    mChosedRow = sender;
}

#pragma mark - 其他辅助功能
-(void)needCarWebInit{
    
}

-(void)needCarDownLoad{
}

-(void)needCarPostData{
    //拼接请求数据，获取活动ID
    NSNumber *vActivId = [self.activeInfo ActivityId];
    vActivId = [vActivId isKindOfClass:[NSNumber class]] ? vActivId : [NSNumber numberWithInt:0];
    id userId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",vActivId,@"activityId", nil];
    //请求网络数据
    NSData *vReturnData = [NetManager postToURLSynchronous:APPURL410 Paremeter:vParemeter timeout:30 RequestName:@"获取拼车列表"];
    //分析数据
    NSDictionary *vReturnDic = [NetManager jsonToDic:vReturnData];
    NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
    NSMutableArray *vDataArray = [NSMutableArray array];
    for (NSDictionary *vDic in vDataDic) {
        [vDataArray addObject:vDic];
    }
    self.needCarInfo = vDataArray;
}

#pragma mark 保存cell到数组
-(void)addCell:(id)aCell{
    BOOL vIsHaveInfo = NO;
    //检查是否已经储存过该cell
    for (id cellIndex in mCells) {
        if (aCell == cellIndex) {
            vIsHaveInfo = YES;
        }
    }
    //保存cell
    if (!vIsHaveInfo) {
        [mCells addObject:aCell];
    }
}

#pragma mark 清除所有的check状态
-(void)clearOtherCheckButton{
    for (NSInteger vCellIndex = 0 ;vCellIndex < mCells.count; vCellIndex ++) {
        MakeCarCell *vCell = [mCells objectAtIndex:vCellIndex];
        [vCell clearCheck];
    }
}

#pragma mark - 其他业务点击事件
-(void)carInfoConfirmButtonTouchDown:(id)sender{
    if (self.needCarInfo.count == 0) {
        return;
    }
    if (!mIsAgreeAgrement) {
        [self.view makeToast:@"同意拼车协议才能拼车！" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    if (mSelectedDic.count > 0) {
        if ([_delegate respondsToSelector:@selector(didNeedCarFinished:)]) {
            [_delegate didNeedCarFinished:mSelectedDic];
            [ViewControllerManager backViewController:vaDefaultAnimation SubType:0];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择拼车车辆！"];
    }
}

- (IBAction)agreeCheckButtonClicked:(UIButton *)sender {
    if (!mIsAgreeAgrement) {
        mIsAgreeAgrement = YES;
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_select"] forState:UIControlStateNormal];
    }else{
        mIsAgreeAgrement = NO;
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_default"] forState:UIControlStateNormal];
    }
}

- (IBAction)agrementButtonClicked:(id)sender {
    AgrementVC *vAgrementVC = [[AgrementVC alloc] init];
    vAgrementVC.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    UINavigationController *vNavi= [[UINavigationController alloc] initWithRootViewController:vAgrementVC];
    [vAgrementVC setAgrementType:atMakeCar];
    [self presentModalViewController:vNavi animated:YES];
    SAFE_ARC_RELEASE(vAgrementVC);
    SAFE_ARC_RELEASE(vNavi);
}

- (IBAction)addButtonTouchedDown:(id)sender {
    NSInteger vCurrentSeats = [self.seatNumberButton.text intValue];
    vCurrentSeats++;
    if (vCurrentSeats >= mMaxSeats) {
        vCurrentSeats = mMaxSeats;
    }
    self.seatNumberButton.text = [NSString stringWithFormat:@"%d",vCurrentSeats];
    NSInteger vSeat = [self.seatNumberButton.text intValue];
    [mSelectedDic setObject:[NSNumber numberWithInt:vSeat] forKey:@"needSeat"];
}
- (IBAction)descLineButtonToucheDown:(id)sender {
    NSInteger vCurrentSeats = [self.seatNumberButton.text intValue];
    vCurrentSeats--;
    if (vCurrentSeats <= 0) {
        vCurrentSeats = 0;
    }
    self.seatNumberButton.text = [NSString stringWithFormat:@"%d",vCurrentSeats];
    NSInteger vSeat = [self.seatNumberButton.text intValue];
    [mSelectedDic setObject:[NSNumber numberWithInt:vSeat] forKey:@"needSeat"];
}

- (void)viewDidUnload {
[self setNeedCarTableView:nil];
    [self setZanWuCheliangLable:nil];
[super viewDidUnload];
}
@end
