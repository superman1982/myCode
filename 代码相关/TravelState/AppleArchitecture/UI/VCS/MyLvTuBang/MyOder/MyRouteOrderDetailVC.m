//
//  MyRouteOrderDetailVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyRouteOrderDetailVC.h"
#import "RouteOrderCell.h"
#import "RouteDownCell.h"
#import "BookCarCell.h"
#import "NetManager.h"
#import "UserManager.h"

@interface MyRouteOrderDetailVC ()
{
    BOOL isInitWebData;
    NSDictionary *orderDic;
}
@property (nonatomic,retain)     NSMutableArray *rotuteOrderInfo;

@end

@implementation MyRouteOrderDetailVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"MyRouteOrderDetailVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyRouteOrderDetailVC" bundle:aBuddle];
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
    self.title = @"行程订单";
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
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
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

-(void)setRotuteOrderInfo:(NSMutableArray *)rotuteOrderInfo{
    if (_rotuteOrderInfo == Nil) {
        _rotuteOrderInfo = [[NSMutableArray alloc] init];
    }
    
    if (isInitWebData) {
        [_rotuteOrderInfo removeAllObjects];
    }
    [_rotuteOrderInfo addObjectsFromArray:rotuteOrderInfo];
    [self.MyRouteOrderDetailTableView reloadData];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        if (section == 3){
            NSArray *vprovideCar = [orderDic objectForKey:@"provideCar"];
            if (vprovideCar.count == 0) {
                return 0;
            }
        }else if (section == 4){
            return 0;
        }
        
        return 30;
    }
    return 0;
}

#pragma mark tableview headerview背景
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    UILabel *vTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 21)];
    vTitleLable.backgroundColor = [UIColor clearColor];
    [vTitleLable setFont:[UIFont systemFontOfSize:15]];
    vTitleLable.textColor = [UIColor darkGrayColor];
    
    if (section == 1) {
        vTitleLable.text = @"活动报名人员";
        [headerView addSubview:vTitleLable];
    }else if (section == 2){
        vTitleLable.text = @"住宿信息";
        [headerView addSubview:vTitleLable];
    }else if (section == 3){
        vTitleLable.text = @"拼车信息";
        [headerView addSubview:vTitleLable];
    }else if (section == 4){
        vTitleLable.text = @"购保信息";
        [headerView addSubview:vTitleLable];
    }
    SAFE_ARC_AUTORELEASE(vTitleLable);
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RouteOrderCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"RouteOrderCell" owner:self options:Nil] objectAtIndex:0];
        return vCell.frame.size.height;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        NSArray *vSinupuser = [orderDic objectForKey:@"signupUsers"];
        return vSinupuser.count;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        NSArray *vprovideCar = [orderDic objectForKey:@"provideCar"];
        return vprovideCar.count;
    }else if (section == 4){
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RouteOrderCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"RouteOrderCell" owner:self options:Nil] objectAtIndex:0];
        [vCell setCell:[self getOrderInfo:orderDic]];
        return vCell;
    }else {
        static NSString *vCellIdentify = @"routeDownCell";
        RouteDownCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
        if (vCell == Nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"RouteDownCell" owner:self options:Nil] objectAtIndex:0];
        }
        
        [vCell setCell:orderDic Section:indexPath.section Row:indexPath.row];
        return vCell;
    }
    
    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 初始化网络请求
-(void)initWebData{
    IFISNIL(self.activityId);
    id usertId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                usertId,@"userId",
                                self.activityId,@"activityId",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL933 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            orderDic = [[NSDictionary alloc] initWithDictionary:vDataDic];
            [self.MyRouteOrderDetailTableView reloadData];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"行程订单" Notice:@""];
}

-(OrderInfo *)getOrderInfo:(NSDictionary *)aDic{
    if (aDic.count == 0) {
        return Nil;
    }
    OrderInfo *vInfo = [[OrderInfo alloc] init];
    vInfo.businessId = [aDic objectForKey:@"activityId"];
    vInfo.businessPhoto = self.routeImageURLStr;
    vInfo.businessName = [aDic objectForKey:@"activityTitle"];
    IFISNIL(vInfo.businessName);
    vInfo.orderId = [aDic objectForKey:@"orderId"];
    IFISNIL(vInfo.orderId);
    vInfo.orderType = [aDic objectForKey:@"orderType"];
    IFISNILFORNUMBER(vInfo.orderType);
    vInfo.totalprice = [aDic objectForKey:@"price"];
    vInfo.price = [aDic objectForKey:@"price"];
    IFISNILFORNUMBER(vInfo.price);
    vInfo.totalreturnMoney = [aDic objectForKey:@"returnMoney"];
    IFISNILFORNUMBER(vInfo.returnMoney);
    vInfo.vipPrice = [aDic objectForKey:@"vipPrice"];
    IFISNILFORNUMBER(vInfo.vipPrice);
    vInfo.orderTime = [aDic objectForKey:@"orderTime"];
    IFISNIL(vInfo.orderTime);
    vInfo.exchangeTime = [aDic objectForKey:@"exchangeTime"];
    IFISNIL(vInfo.exchangeTime);
    NSInteger vState = [[aDic objectForKey:@"orderState"] intValue];
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
    vInfo.isEvaluate = [aDic objectForKey:@"isEvaluate"];
    IFISNILFORNUMBER(vInfo.isEvaluate);
    vInfo.userComment = [aDic objectForKey:@"userComment"];
    IFISNIL(vInfo.userComment);
    vInfo.sellerComment = [aDic objectForKey:@"sellerComment"];
    IFISNIL(vInfo.sellerComment);
    SAFE_ARC_AUTORELEASE(vInfo);
    return vInfo;
}

@end
