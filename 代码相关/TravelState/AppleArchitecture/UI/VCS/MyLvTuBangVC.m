//
//  SetingViewController.m
//  ZHMS-PDA
//
//  Created by klbest1 on 13-12-12.
//  Copyright (c) 2013年 Jackson. All rights reserved.
//

#import "MyLvTuBangVC.h"
#import "MainConfig.h"
#import "UserManager.h"
#import "AnimationTransition.h"
#import "ViewControllerManager.h"
#import "PersonalInfomationVC.h"
#import "MyMemberShipCardVC.h"
#import "ImageViewHelper.h"
#import "PersonalInfomationVC.h"
#import "StringHelper.h"
#import "UserManager.h"
#import "RootTabBarVC.h"
#import "NetManager.h"

typedef enum{
    convSettingTableView = 1000,
}ConTag;


@interface MyLvTuBangVC ()
{
    UITableViewCell *mTuBiCell;
}
@end

@implementation MyLvTuBangVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"MyLvTuBangVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyLvTuBangVC" bundle:aBuddle];
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
    self.title = @"一级标题";
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
    [_noticeContentView release];
    [_scrollContentView release];
    [_menuView release];
    [_menuTableView release];
    [_nickname release];
    [_memberTime release];
    [_sex release];
    [_headerImageUrl release];
    [_headerImageUrl release];
    [_isPaySms release];
    [_alertMessage release];
    [_noticeView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    BOOL isAutoLogin = [UserManager isAutoLogin];
    if (isAutoLogin && [UserManager instanceUserManager].userInfo != Nil) {
        [self setUI];
    }else{
        [self.view addSubview:self.withoutLoginView];
    }

    //网络断开时
    if (![NetManager isConnectNet]) {
        [self.view  addSubview:self.withoutLoginView];
    }
    
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

//-----------------
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 10;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
    }
    if(section == 2){
        return 2;
    }
    if(section == 3){
        return 2;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (indexPath.section == 0) {
        vCell.textLabel.text = @"充值途币:";
        UILabel *vRestMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(78, 12, 70, 21)];
        vRestMoneyLable.font = [UIFont systemFontOfSize:15];
        id vchargeMoney = [UserManager instanceUserManager].userInfo.rechargeMoney;
        vRestMoneyLable.text = [NSString stringWithFormat:@" %@",vchargeMoney];
        vRestMoneyLable.textColor = [UIColor orangeColor];
        [vRestMoneyLable setTag:55];
        [vCell.contentView addSubview:vRestMoneyLable];
      
        
        UILabel *vChongMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(vRestMoneyLable.frame.origin.x + vRestMoneyLable.frame.size.width+5, 11, 65, 21)];
        vChongMoneyLable.font = [UIFont systemFontOfSize:15];
        vChongMoneyLable.text = @"赠送途币:";
        vChongMoneyLable.textColor = [UIColor darkGrayColor];
        [vCell.contentView addSubview:vChongMoneyLable];
        
        UILabel *vAddMoneLable = [[UILabel alloc] initWithFrame:CGRectMake(vChongMoneyLable.frame.origin.x + vChongMoneyLable.frame.size.width , 12, 70, 21)];
        vAddMoneLable.font = [UIFont systemFontOfSize:15];
        id vGivingMoney = [UserManager instanceUserManager].userInfo.giveMoney;
        vAddMoneLable.text = [NSString stringWithFormat:@"%@",vGivingMoney];
        vAddMoneLable.textColor = [UIColor orangeColor];
        [vAddMoneLable setTag:56];
        [vCell.contentView addSubview:vAddMoneLable];
        
//        UILabel *vSongMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(vAddMoneLable.frame.origin.x + vAddMoneLable.frame.size.width , 11, 50, 21)];
//        vSongMoneyLable.font = [UIFont systemFontOfSize:15];
//        vSongMoneyLable.text = @"途币记录";
//        vSongMoneyLable.textColor = [UIColor darkGrayColor];
//        [vCell.contentView addSubview:vSongMoneyLable];
        
        mTuBiCell = vCell;
        SAFE_ARC_RELEASE(vAddMoneLable);
        SAFE_ARC_RELEASE(vChongMoneyLable);
        SAFE_ARC_RELEASE(vRestMoneyLable);
        SAFE_ARC_RELEASE(vSongMoneyLable);
        
    }else  if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"我的订单";
        }else if (indexPath.row == 1) {
            vCell.textLabel.text = @"我的行程";
        }
    }else  if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"我的爱车";
        }if (indexPath.row == 1) {
            vCell.textLabel.text = @"我的驾驶证";
        }
    }else  if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"安全中心";
        }else if (indexPath.row == 1) {
            vCell.textLabel.text = @"分享设置";
        }
    }
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self myJiFenRecordClicked];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self myOrderClicked];
        }else{
            [self myRoutesClicked];
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self myCarClicked];
        }else if (indexPath.row == 1){
            [self myDriveLisenceClicked];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            [self safeCenterClicked];
        }else if (indexPath.row == 1){
            [self shareSettingClicked];
        }
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
                                     self.menuTableView.frame.size.width, 100)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.customPullStr = @"松开充值途币";
    _refreshHeaderView.customNormlStr =@"下拉充值途币";
    _refreshHeaderView.customLoading = @"  ";
    _refreshHeaderView.statusLabel.text = @"下拉充值途币";
    _refreshHeaderView.lastUpdatedLabel.hidden = YES;
    _refreshHeaderView.statusLabel.textColor = [UIColor darkGrayColor];
    _refreshHeaderView.backgroundColor = self.view.backgroundColor;
    _refreshHeaderView.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _refreshHeaderView.activityView.center = CGPointMake(150, _refreshHeaderView.activityView.center.y);
	[self.menuTableView addSubview:_refreshHeaderView];
    
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
    CGFloat height = MAX(self.menuTableView.contentSize.height, self.menuTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.menuTableView.frame.size.width,
                                              self.menuTableView.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.menuTableView.frame.size.width, self.menuTableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.menuTableView addSubview:_refreshFooterView];
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
		self.menuTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.menuTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}else{
        self.menuTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.menuTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.menuTableView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.menuTableView];
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
        [self chongZhiClicked:Nil];
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
    
}
#pragma mark PersonalInfomationVCDelegate
#pragma mark 个人信息 返回
-(void)didPersonalInfomationVCChanged:(id)sender{
    [self setUI];
}

#pragma mark - 其他辅助功能
-(BOOL)checkIfHasPayPassword{
    id vPayPassword = [UserManager instanceUserManager].userInfo.isSetPayPassword;
    if ([vPayPassword intValue] == 1) {
        return YES;
    }else{
        [self.view addSubview:self.noticeContentView];
        [UIView animateChangeView:self.noticeContentView AnimationType:vaFade SubType:vsFromBottom Duration:.3 CompletionBlock:Nil];
        return NO;
    }
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
         // custom refresh logic would be placed here...
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"MMM d, h:mm a"];
      NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
    [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
    
}

#pragma mark 更新页面数据
-(void)setUI{
    
    //头像
    NSString *vHeadImageURLStr = [UserManager instanceUserManager].userInfo.headerImageUrl;
    IFISNIL(vHeadImageURLStr);

    [self.headerImageUrl setImageWithURL:[NSURL URLWithString:vHeadImageURLStr] PlaceHolder:[UIImage imageNamed:@"lvtubang"]];
    self.headerImageUrl.layer.cornerRadius = 10;
    self.headerImageUrl.layer.masksToBounds = YES;
    
    //昵称
    self.nickname.text = [UserManager instanceUserManager].userInfo.nickname;
    CGSize vSize = [StringHelper caluateStrLength:self.nickname.text Front:self.nickname.font ConstrainedSize:CGSizeMake(119, 21)];
    [self.nickname setFrame:CGRectMake(self.nickname.frame.origin.x, self.nickname.frame.origin.y, vSize.width, 21)];
    
    //会员时长
    NSString *vMemberTimeStr = [UserManager instanceUserManager].userInfo.memberTime;
    self.memberTime.text = [NSString stringWithFormat:@"会员时长:%@天",vMemberTimeStr];
    
    //性别
    id sex = [UserManager instanceUserManager].userInfo.sex;
    if ([sex isEqualToString:@"男"]) {
        [self.sex setImage:[UIImage imageNamed:@"myLTB_male_bkg"]];
    }else{
        [self.sex setImage:[UIImage imageNamed:@"myLTB_female_bkg"]];
    }
    //根据昵称，重新调整性别显示位置
    [self.sex setFrame:CGRectMake(self.nickname.frame.origin.x + self.nickname.frame.size.width+3, self.sex.frame.origin.y, self.sex.frame.size.width, self.sex.frame.size.height)];
    
    //提醒数目
    id vIsPaysms = [UserManager instanceUserManager].userInfo.isPaySms;
    if ([vIsPaysms intValue] > 0) {
        self.isPaySms.hidden = NO;
        [self.isPaySms setTitle:[NSString stringWithFormat:@"%@",vIsPaysms] forState:UIControlStateNormal];
    }
    
    id vAlertMessge = [UserManager instanceUserManager].userInfo.alertMessage;
    if ([vAlertMessge intValue] > 0) {
        self.alertMessage.hidden = NO;
        [self.alertMessage setTitle:[NSString stringWithFormat:@"%@",vAlertMessge] forState:UIControlStateNormal];
    }
    
    //冲途币数量
    UILabel *vChongTubiLable = (UILabel *)[mTuBiCell.contentView viewWithTag:55];
    id vrechargeMoney = [UserManager instanceUserManager].userInfo.rechargeMoney;
    vChongTubiLable.text = [NSString stringWithFormat:@" %@",vrechargeMoney];
    
    //赠送途币数量
    UILabel *vGiveTubiLable = (UILabel *)[mTuBiCell.contentView viewWithTag:56];
    id vGiveMoney = [UserManager instanceUserManager].userInfo.giveMoney;
    vGiveTubiLable.text = [NSString stringWithFormat:@"%@",vGiveMoney];
}

//隐藏键盘时，将View恢复为原样式
-(void)inputKeyboardWillHide:(NSNotification *)notification{
}

#pragma mark LoginVCDelegate
#pragma mark 登录成功
-(void)didLoginSuccess:(BOOL)sender{
    [self addLoginVC:sender];
}

#pragma mark RegisterVCDelegate
#pragma mark 注册成功
-(void)didRegistAndLoginSuccess:(BOOL)sender{
    LOG(@"组册成功后，返回到我的旅途邦信息:%d",sender);
    [self addLoginVC:sender];
}


#pragma mark - 其他辅助功能
#pragma mark 添加登陆后"我的旅途邦"
-(void)addLoginVC:(BOOL)isSelected{
    if (self.withoutLoginView.superview != nil) {
        [self.withoutLoginView removeFromSuperview];
    }
    //刷新我的旅途邦UI
    [self setUI];
    
    //刷新自驾界面数据
    RootTabBarVC *vRootVC = (RootTabBarVC *)[ViewControllerManager getBaseViewController:@"RootTabBarVC"];
    [vRootVC.selfDriveVC initSelfDriveData];
    //重设Navibar
    [vRootVC reSetMylvTuBangNaviBar];
}


#pragma mark 添加未登录“我的旅途邦”
-(void)addUnLoginVC{
    [self.view addSubview:self.withoutLoginView];
    RootTabBarVC *vRootVC = (RootTabBarVC *)[ViewControllerManager getBaseViewController:@"RootTabBarVC"];
    //刷新自驾界面数据
    [vRootVC.selfDriveVC initSelfDriveData];
    //重设Navibar
    [vRootVC reSetMylvTuBangNaviBar];
}

#pragma mark - 其他业务点击事件
#pragma mark 个人信息
- (IBAction)personalInfoButtonClicked:(id)sender {
    [ViewControllerManager  createViewController:@"PersonalInfomationVC"];
    [ViewControllerManager showBaseViewController:@"PersonalInfomationVC" AnimationType:vaDefaultAnimation SubType:0];
    PersonalInfomationVC *vVC = (PersonalInfomationVC *)[ViewControllerManager getBaseViewController:@"PersonalInfomationVC"];
    vVC.delegate = self;
}
#pragma mark 提醒
- (IBAction)noticeClicked:(id)sender {
    [ViewControllerManager  createViewController:@"MyNoticeVC"];
    [ViewControllerManager showBaseViewController:@"MyNoticeVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 消息
- (IBAction)MessageClicked:(id)sender {
//    [ViewControllerManager  createViewController:@"MessageVC"];
//    [ViewControllerManager showBaseViewController:@"MessageVC" AnimationType:vaDefaultAnimation SubType:0];
    [self chongZhiClicked:Nil];
}
#pragma mark 充值
- (IBAction)chongZhiClicked:(id)sender {
    if ([self checkIfHasPayPassword]) {
        [ViewControllerManager  createViewController:@"ChongZhiVC"];
        [ViewControllerManager showBaseViewController:@"ChongZhiVC" AnimationType:vaDefaultAnimation SubType:0];
    }

}

#pragma mark 转账
- (IBAction)transferMoneyClicked:(id)sender {
    if ([self checkIfHasPayPassword]) {
        [ViewControllerManager  createViewController:@"JiFenTranferVC"];
        [ViewControllerManager showBaseViewController:@"JiFenTranferVC" AnimationType:vaDefaultAnimation SubType:0];
    }
}

#pragma mark 点击升级会员
- (IBAction)UPGrandButtonClicked:(id)sender {
    [ViewControllerManager  createViewController:@"UpGrandMemberVC"];
    [ViewControllerManager showBaseViewController:@"UpGrandMemberVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 点击积分记录
-(void)myJiFenRecordClicked{
    [ViewControllerManager  createViewController:@"IntegrationRecordVC"];
    [ViewControllerManager showBaseViewController:@"IntegrationRecordVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 点击我的会员卡
-(void)myVIPCardClicked{
    [ViewControllerManager  createViewController:@"MyMemberShipCardVC"];
    [ViewControllerManager showBaseViewController:@"MyMemberShipCardVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 点击我的订单
-(void)myOrderClicked{
    [ViewControllerManager  createViewController:@"MyOrdersVC"];
    [ViewControllerManager showBaseViewController:@"MyOrdersVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 点击我的行程
-(void)myRoutesClicked{
    [ViewControllerManager  createViewController:@"MyRoutesVC"];
    [ViewControllerManager showBaseViewController:@"MyRoutesVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 点击我的保险
-(void)myInsuranceClicked{
    [ViewControllerManager createViewController:@"MyInsuranceVC"];
    [ViewControllerManager showBaseViewController:@"MyInsuranceVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 我的爱车
-(void)myCarClicked{
    [ViewControllerManager  createViewController:@"MyCarVC"];
    [ViewControllerManager showBaseViewController:@"MyCarVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark  驾驶证
-(void)myDriveLisenceClicked{
    [ViewControllerManager createViewController:@"MyDriveLiscense"];
    [ViewControllerManager showBaseViewController:@"MyDriveLiscense" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 安全中心
-(void)safeCenterClicked{
    [ViewControllerManager createViewController:@"SafeCenterVC"];
    [ViewControllerManager showBaseViewController:@"SafeCenterVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 分享设置
-(void)shareSettingClicked{
    [ViewControllerManager createViewController:@"ShareSetingVC"];
    [ViewControllerManager showBaseViewController:@"ShareSetingVC" AnimationType:vaDefaultAnimation SubType:0];
}

- (IBAction)setImejiatlyButtonClicked:(id)sender {
    [UIView animateChangeView:self.noticeContentView AnimationType:vaFade SubType:vsFromBottom Duration:.3 CompletionBlock:^{
        [ViewControllerManager createViewController:@"AddPayPasswordVC"];
        [ViewControllerManager showBaseViewController:@"AddPayPasswordVC" AnimationType:vaDefaultAnimation SubType:0];
        [self.noticeContentView removeFromSuperview];
    }];
}

- (IBAction)cancleButtonClicked:(id)sender {
    [UIView animateChangeView:self.noticeContentView AnimationType:vaFade SubType:vsFromBottom Duration:.3 CompletionBlock:^{
        [self.noticeContentView removeFromSuperview];
    }];
}


#pragma mark 其他业务点击事件
- (IBAction)loginButtonClicked:(id)sender {
    [ViewControllerManager createViewController:@"LoginVC"];
    [ViewControllerManager showBaseViewController:@"LoginVC" AnimationType:vaDefaultAnimation SubType:0];
    //设置LoginVC代理，登录成功后改变我的旅途邦为登录后页面
    LoginVC *vLoginVC = (LoginVC *)[ViewControllerManager getBaseViewController:@"LoginVC"];
    vLoginVC.delegate =  self;
}

- (IBAction)registerButtonClicked:(id)sender {
    [ViewControllerManager createViewController:@"RegisterVC"];
    [ViewControllerManager showBaseViewController:@"RegisterVC" AnimationType:vaDefaultAnimation SubType:0];
    RegisterVC *vVC = (RegisterVC *)[ViewControllerManager getBaseViewController:@"RegisterVC"];
    vVC.delegate = self;
}

- (void)viewDidUnload {
    [self setNoticeContentView:nil];
    [self setMenuTableView:nil];
    [self setNickname:nil];
    [self setMemberTime:nil];
    [self setSex:nil];
    [self setHeaderImageUrl:nil];
    [self setHeaderImageUrl:nil];
    [self setIsPaySms:nil];
    [self setAlertMessage:nil];
    [self setNoticeView:nil];
    [super viewDidUnload];
}

@end
