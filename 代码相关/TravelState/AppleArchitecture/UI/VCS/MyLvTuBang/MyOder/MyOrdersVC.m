//
//  MyOrdersVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyOrdersVC.h"
#import "OrderDetailVC.h"
#import "UserManager.h"
#import "NetManager.h"
#import "OrderInfo.h"
#import "MyOrderHeaderCell.h"
#import "MyOrderFooterCell.h"

#define BUTTONWIDTH 75

@interface MyOrdersVC ()
{
    NSInteger mPageIndex;
    NSInteger mPageSize;
    NSInteger mType;
    BOOL      mIsInitWebData;
    NSMutableArray *mButtonArray;
    AgentSearchTypeVC *mSearchTypeVC; //订单类型
    CGRect mOriginRect ;  //搜索类型位置
    CGRect mDestinaRect; //搜索类型移动位置
    NSInteger mSeletedSection;
}

@property (nonatomic,retain) NSMutableArray *orderInfoArray;
@end

@implementation MyOrdersVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"MyOrdersVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyOrdersVC" bundle:aBuddle];
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
    self.title = @"我的订单";
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
    mButtonArray = [[NSMutableArray alloc] init];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_travelButton release];
    [_agentButton release];
    [_cleanCarButton release];
    [_insuranceButton release];
    [_orderTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self createHeaderView];
//    [self createTypeButton];
//    [self typeButtonClicked:[mButtonArray objectAtIndex:0]];
    if (mSearchTypeVC == Nil) {
        mSearchTypeVC = [[AgentSearchTypeVC alloc] init];
        mSearchTypeVC.delegate = self;
        NSArray *vTypeArray = @[@"全      部",
                                @"景      点",
                                @"美      食",
                                @"酒      店",
                                @"休      闲",
                                @"生      活",
                                @"其      它",
                                @"车辆业务",
                                @"车      务",];
        mSearchTypeVC.tableWidth = 90;
        mSearchTypeVC.typeArray = [vTypeArray mutableCopy];
    }
    
    mOriginRect = CGRectMake(320-mSearchTypeVC.view.frame.size.width,-30,mSearchTypeVC.view.frame.size.width,  mSearchTypeVC.view.frame.size.height);
    mDestinaRect = CGRectMake(320-mSearchTypeVC.view.frame.size.width, 0,mSearchTypeVC.view.frame.size.width,  mSearchTypeVC.view.frame.size.height);
    
    self.orderTableView.clickeDelegate = self;
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

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)setOrderInfoArray:(NSMutableArray *)orderInfoArray{
    if (_orderInfoArray == Nil) {
        _orderInfoArray = [[NSMutableArray alloc] init];
    }
    if (mIsInitWebData) {
        [_orderInfoArray removeAllObjects];
    }
    [_orderInfoArray addObjectsFromArray:orderInfoArray];
    [self.orderTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *vItemArray = [self.orderInfoArray objectAtIndex:section];
    if (vItemArray.count > 0) {
        OrderInfo *vInfo = [vItemArray objectAtIndex:0];
        //点击了显示其余两件，显示全部
        if (vInfo.isShowedOtherItem) {
            return vItemArray.count;
        }else{
            //没有点击，显示一行
            return 1;
        }
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    MyOrderHeaderCell *vHeadCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderCell" owner:self options:nil] objectAtIndex:0];
    return  vHeadCell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    MyOrderFooterCell *vFooterCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderFooterCell" owner:self options:nil] objectAtIndex:0];
    return  vFooterCell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyOrderHeaderCell *vHeadCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderCell" owner:self options:nil] objectAtIndex:0];
    NSArray *vItemArray = [self.orderInfoArray objectAtIndex:section];
    OrderInfo *vInfo = [vItemArray lastObject];
    vHeadCell.serviceNameLable.text = vInfo.businessName;
    return  vHeadCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MyOrderFooterCell *vFooterCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderFooterCell" owner:self options:nil] objectAtIndex:0];
    NSArray *vItemArray = [self.orderInfoArray objectAtIndex:section];
    OrderInfo *vInfo = [vItemArray lastObject];
    [vFooterCell setCell:vInfo];
    return  vFooterCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil] objectAtIndex:0];
    //当点击”显示其他几件时“除了第一行，其余都隐藏该按钮
    if (indexPath.row > 0) {
        [vCell setHideShowOtherUI];
    }
    //在第一行时，当只有一个服务时不显示“显示其余商品”
    if (indexPath.row == 0) {
        NSArray *vItemArray = [self.orderInfoArray objectAtIndex:indexPath.section];
        if (vItemArray.count == 1) {
            [vCell setHideShowOtherUI];
        }else{
            [vCell setShowShowOtherUI];
        }
    }
    return vCell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"orderCell";
    MyOrderCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil] objectAtIndex:0];
        
        UIView *vSeletedView = [[UIView alloc] initWithFrame:vCell.frame];
        [vSeletedView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:240.0/255 blue:255.0/255 alpha:1]];
        vCell.selectedBackgroundView = vSeletedView;
        SAFE_ARC_AUTORELEASE(vSeletedView);
        vCell.delegate = self;
    }
    NSArray *vItemArray = [self.orderInfoArray objectAtIndex:indexPath.section];
    OrderInfo *vInfo = [vItemArray objectAtIndex:indexPath.row];
    [vCell setCell:vInfo];
    //保存section标记，以便更改显示状态
    vCell.tag = indexPath.section;
    if (indexPath.row == 0) {
        if (vItemArray.count > 1) {
            OrderInfo *vInfo = [vItemArray objectAtIndex:0];
            if (!vInfo.isShowedOtherItem) {
                [vCell.showOtherButton setTitle:[NSString stringWithFormat:@"显示其余%d件商品",vItemArray.count -1] forState:UIControlStateNormal];
            }else{
                [vCell.showOtherButton setTitle:[NSString stringWithFormat:@"隐藏其余%d件商品",vItemArray.count -1] forState:UIControlStateNormal];
            }
            [vCell setShowShowOtherUI];
        }else {
            [vCell setHideShowOtherUI];
        }
    }else{
        //隐藏显示其余两件
        [vCell setHideShowOtherUI];
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *vItemArray =[self.orderInfoArray objectAtIndex:indexPath.section];
    [ViewControllerManager createViewController:@"OrderDetailVC"];
    OrderDetailVC *vVC =(OrderDetailVC *)[ViewControllerManager getBaseViewController:@"OrderDetailVC"];
    vVC.orderDetailArray = vItemArray;
    [ViewControllerManager showBaseViewController:@"OrderDetailVC" AnimationType:vaDefaultAnimation SubType:0];
    mSeletedSection = indexPath.section;
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
                                     self.orderTableView.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    
	[self.orderTableView addSubview:_refreshHeaderView];
    
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
    CGFloat height = MAX(self.orderTableView.contentSize.height, self.orderTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.orderTableView.frame.size.width,
                                              self.orderTableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.orderTableView.frame.size.width, self.orderTableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.orderTableView addSubview:_refreshFooterView];
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
		self.orderTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.orderTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}else{
        self.orderTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.orderTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.orderTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.orderTableView];
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
    
    if (_orderInfoArray.count >= 10) {
        [self setFooterView];
    }
    
}

#pragma mark MyOrderCellDelegate
-(void)didMyOrderCellCancledOrder:(id)sender{
    [self performSelector:@selector(initWebData) withObject:Nil afterDelay:.5];
}

-(void)didMyOrderShowOtherService:(OrderInfo *)sender Section:(NSInteger)aSection{
    sender.isShowedOtherItem = !sender.isShowedOtherItem;
    NSMutableArray *vItemArray = [self.orderInfoArray objectAtIndex:aSection];
    [vItemArray replaceObjectAtIndex:0 withObject:sender];
    [self.orderTableView reloadData];
}

#pragma mark - 其他辅助功能
#pragma mark 清空button的点击状态
-(void)clearButtons{
    for (UIButton *vButton in mButtonArray) {
        [vButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [vButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }

}

#pragma mark 创建类型buton
-(void)createTypeButton{
    NSArray *vTypeArray = @[@"景点",
                            @"美食",
                            @"酒店",
                            @"休闲",
                            @"生活",
                            @"其它",
                            @"车辆业务",
                            @"车务",
                            ];
    for (NSInteger vIndex = 0; vIndex < vTypeArray.count; vIndex++) {
        NSString *vTitle = [vTypeArray objectAtIndex:vIndex];
        UIButton *vTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vTypeButton setFrame:CGRectMake(BUTTONWIDTH*vIndex, 0, BUTTONWIDTH, 48)];
        [vTypeButton setTitle:vTitle forState:UIControlStateNormal];
        [vTypeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [vTypeButton setTag:(vIndex+1)];
        if ([vTitle isEqualToString:@"车辆业务"]) {
            [vTypeButton setTag:11];
        }else if ([vTitle isEqualToString:@"车务"]){
            [vTypeButton setTag:12];
        }else if ([vTitle isEqualToString:@"我的活动"]){
            [vTypeButton setTag:13];
        }
        
        [vTypeButton addTarget:self action:@selector(typeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContentView addSubview:vTypeButton];
        [mButtonArray addObject:vTypeButton];
    }
    [self.buttonContentView setContentSize:CGSizeMake(BUTTONWIDTH *vTypeArray.count, 48)];
}

#pragma mark 初始化网络请求
-(void)initWebData{
    mPageIndex = 0;
    mPageSize = 14;
    mIsInitWebData = YES;
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                [NSNumber numberWithInt:mType],@"serviceType",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    [self postWebData:vParemeter];
}

#pragma mark 下载网络数据
-(void)downLoadWebData{
    mIsInitWebData = NO;
    mPageIndex++;
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                [NSNumber numberWithInt:mType],@"serviceType",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    [self postWebData:vParemeter];
}

#pragma mark 请求网络数据
-(void)postWebData:(NSDictionary *)aParemeter{
    [NetManager postDataFromWebAsynchronous:APPURL811 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSArray *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vOrderArray = [NSMutableArray array];
        if (vDataDic.count > 0) {
            for (NSDictionary *vDic in vDataDic) {
                NSMutableArray *vItemArray = [NSMutableArray array];
                NSDictionary *services = [vDic objectForKey:@"services"];
                for (NSDictionary * lDic in services) {
                    OrderInfo *vInfo = [[OrderInfo alloc] init];
                    vInfo.businessId = [vDic objectForKey:@"businessId"];
                    vInfo.businessPhoto = [vDic objectForKey:@"businessPhoto"];
                    vInfo.businessName = [vDic objectForKey:@"businessName"];
                    IFISNIL(vInfo.businessName);
                    vInfo.orderId = [vDic objectForKey:@"orderId"];
                    IFISNIL(vInfo.orderId);
                    vInfo.orderType = [vDic objectForKey:@"orderType"];
                    IFISNILFORNUMBER(vInfo.orderType);
                    vInfo.totalServices = [vDic objectForKey:@"totalServices"];
                    IFISNILFORNUMBER(vInfo.totalServices);
                    vInfo.totalprice = [vDic objectForKey:@"price"];
                    IFISNILFORNUMBER(vInfo.totalprice);
                    vInfo.totalreturnMoney = [vDic objectForKey:@"returnMoney"];
                    IFISNILFORNUMBER(vInfo.totalreturnMoney);
                    
                    vInfo.orderTime = [vDic objectForKey:@"orderTime"];
                    IFISNIL(vInfo.orderTime);
                    vInfo.exchangeTime = [vDic objectForKey:@"exchangeTime"];
                    IFISNIL(vInfo.exchangeTime);
                    NSInteger vState = [[vDic objectForKey:@"orderState"] intValue];
                    switch (vState) {
                        case 9:
                            vInfo.orderState = otCancle;
                            break;
                        case 1:
                            vInfo.orderState = otDealing;
                            break;
                        case 2:
                            vInfo.orderState = otConfirm;
                            break;
                        case 3:
                            vInfo.orderState = otPayed;
                            break;
                        default:
                            break;
                    }
                    vInfo.isEvaluate = [vDic objectForKey:@"isEvaluate"];
                    IFISNILFORNUMBER(vInfo.isEvaluate);
                    vInfo.userComment = [vDic objectForKey:@"userComment"];
                    IFISNIL(vInfo.userComment);
                    vInfo.sellerComment = [vDic objectForKey:@"sellerComment"];
                    IFISNIL(vInfo.sellerComment);
                    
                    
                    vInfo.serviceName = [lDic objectForKey:@"serviceName"];
                    vInfo.serviceDesc = [lDic objectForKey:@"serviceDesc"];
                    vInfo.orderCount = [lDic objectForKey:@"orderCount"];
                    vInfo.servicePhtoto = [lDic objectForKey:@"servicePhtoto"];
                    vInfo.price = [lDic objectForKey:@"price"];
                    vInfo.vipPrice = [lDic objectForKey:@"vipPrice"];
                    vInfo.returnMoney = [lDic objectForKey:@"returnMoney"];
                    
                    [vItemArray addObject:vInfo];
                    vInfo = Nil;
                }
                [vOrderArray addObject:vItemArray];
            }
        }
        self.orderInfoArray = vOrderArray;
        //刷新订单详情
        OrderDetailVC *vDetailVC =(OrderDetailVC *)[ViewControllerManager getBaseViewController:@"OrderDetailVC"];
        if (vDetailVC != nil) {
            [self refreshOrderUI];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求我的订单" Notice:@""];
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
    NSArray *vTypeArray = @[@"全部",
                            @"景点",
                            @"美食",
                            @"酒店",
                            @"休闲",
                            @"生活",
                            @"其它",
                            @"车辆业务",
                            @"车务",];
    return [vTypeArray objectAtIndex:aIndex];
}

#pragma mark 刷新订单详情页面
-(void)refreshOrderUI{
    if (self.orderInfoArray.count > mSeletedSection) {
        NSMutableArray *vItemArray =[self.orderInfoArray objectAtIndex:mSeletedSection];
        OrderDetailVC *vVC =(OrderDetailVC *)[ViewControllerManager getBaseViewController:@"OrderDetailVC"];
        vVC.orderDetailArray = vItemArray;
    }

}

#pragma mark 其他业务点击事件
#pragma mark 点击某项服务
-(void)typeButtonClicked:(UIButton *)sender{
    [self clearButtons];
    [sender setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    mType = sender.tag;
    [self initWebData];
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
    //车辆业务和车务类型
    mType = aType;
    if (mType == 7) {
        mType = 11;
    }else if(mType == 8){
        mType = 12;
    }
    //重设button宽度
    float vButtonWidth = 40;
    if (mType == 11) {
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
@end
