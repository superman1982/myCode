//
//  ShoppingCartVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "PurchaseCarCell.h"
#import "UserManager.h"
#import "NetManager.h"
#import "PurchaseCarInfo.h"
#import "Toast+UIView.h"
#import "RootTabBarVC.h"

@interface ShoppingCartVC ()
{
    NSMutableArray *mBunessIdInfoArray;
}
@property (nonatomic,retain) NSMutableArray *purchaseInfoArray;
@property (nonatomic,retain) NSMutableArray *bunessHeadInfoArray;
@end

@implementation ShoppingCartVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ShoppingCartVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ShoppingCartVC" bundle:aBuddle];
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
    self.title = @"购物车";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确认订单" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 80, 44)];
    [vRightButton addTarget:self action:@selector(payMentButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
    
    SAFE_ARC_RELEASE(vBarButtonItem);
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mBunessIdInfoArray = [[NSMutableArray alloc] init];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_purchaseInfoArray removeAllObjects];
    [_purchaseInfoArray release];
    [_purchaseTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    if (_isNeedToResetUI) {
        [self.purchaseTableView setFrame:self.view.frame];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![UserManager isLogin]) {
        [self.view makeToast:@"登录后，方可查看购物车" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
    }
    //移除数据
    [self.purchaseInfoArray removeAllObjects];
    [self.purchaseTableView reloadData];
    //重新刷新数据
    [self initWebData];
}
#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}

//-----------------
- (void)viewDidUnload {
    [self setPurchaseTableView:nil];
    [super viewDidUnload];
}

-(void)setPurchaseInfoArray:(NSMutableArray *)purchaseInfoArray{
    if (_purchaseInfoArray == Nil) {
        _purchaseInfoArray = [[NSMutableArray alloc] init];
    }
    [_purchaseInfoArray removeAllObjects];
    [_purchaseInfoArray addObjectsFromArray:purchaseInfoArray];
    //设置NaVi状态
    if ([UserManager isLogin]) {
        if (_purchaseInfoArray.count == 0) {
            [self hideNavigationItem];
            [self.view makeToast:@"您的购物车是空的" duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
        }else {
            [self showNaviGationItem];
        }
    }
    [self.purchaseTableView reloadData];
}

-(void)setBunessHeadInfoArray:(NSMutableArray *)bunessHeadInfoArray{
    if (_bunessHeadInfoArray == Nil) {
        _bunessHeadInfoArray = [[NSMutableArray alloc] init];
    }
    [_bunessHeadInfoArray removeAllObjects];
    [_bunessHeadInfoArray addObjectsFromArray:bunessHeadInfoArray];
    [self.purchaseTableView reloadData];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PurchaseCarCell *vCell = [[[NSBundle mainBundle]loadNibNamed:@"PurchaseCarCell" owner:self options:Nil] objectAtIndex:0];
    
    return vCell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger vCount = self.purchaseInfoArray.count;
    if (vCount > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return vCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    PurchaseHeaderCell *vCell = [[[NSBundle mainBundle]loadNibNamed:@"PurchaseHeaderCell" owner:self options:Nil] objectAtIndex:0];
    return vCell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PurchaseHeaderCell *vCell = [[[NSBundle mainBundle]loadNibNamed:@"PurchaseHeaderCell" owner:self options:Nil] objectAtIndex:0];
    [vCell setCell:[self.bunessHeadInfoArray objectAtIndex:section]];
    vCell.delegate = self;
    return vCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *vItemtArray = [self.purchaseInfoArray objectAtIndex:indexPath.section];
        PurchaseCarInfo *vInfo = [vItemtArray objectAtIndex:row];
        [self deleteOrder:vInfo PathIndex:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.purchaseInfoArray.count > section) {
        NSMutableArray *vItemArray = [self.purchaseInfoArray objectAtIndex:section];
        return vItemArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"purchaseCell";
    PurchaseCarCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == Nil) {
        vCell = [[[NSBundle mainBundle]loadNibNamed:@"PurchaseCarCell" owner:self options:Nil] objectAtIndex:0];
        vCell.delegate = self;
    }
    NSMutableArray *vItemArray = [self.purchaseInfoArray objectAtIndex:indexPath.section];
    PurchaseCarInfo *vInfo = [vItemArray objectAtIndex:indexPath.row];
    [vCell setCell:vInfo];
    return vCell;
}

#pragma mark - 其他辅助功能
-(void)initWebData{
    id userId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    [NetManager postDataFromWebAsynchronous:APPURL702 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vCartArray = [NSMutableArray array];
        if (vDataDic.count > 0) {
            for (NSDictionary *vDic in vDataDic) {
                PurchaseCarInfo *vInfo = [[PurchaseCarInfo alloc] init];
                vInfo.businessId = [vDic objectForKey:@"businessId"];
                IFISNIL(vInfo.businessId);
                vInfo.businessPhoto = [vDic objectForKey:@"businessPhoto"];
                IFISNIL(vInfo.businessPhoto);
                vInfo.businessName = [vDic objectForKey:@"businessName"];
                IFISNIL(vInfo.businessName);
                vInfo.serviceType = [vDic objectForKey:@"serviceType"];
                IFISNILFORNUMBER(vInfo.serviceType);
                vInfo.standardServiceType = [vDic objectForKey:@"standardServiceType"];
                IFISNILFORNUMBER(vInfo.standardServiceType);
                vInfo.serviceId = [vDic objectForKey:@"serviceId"];
                IFISNIL(vInfo.serviceId);
                vInfo.name = [vDic objectForKey:@"name"];
                IFISNIL(vInfo.name);
                vInfo.photo = [vDic objectForKey:@"photo"];
                IFISNIL(vInfo.photo);
                vInfo.count = [vDic objectForKey:@"count"];
                IFISNILFORNUMBER(vInfo.count);
                vInfo.price = [vDic objectForKey:@"price"];
                IFISNILFORNUMBER(vInfo.price);
                vInfo.vipPrice = [vDic objectForKey:@"vipPrice"];
                IFISNILFORNUMBER(vInfo.vipPrice);
                vInfo.returnMoney = [vDic objectForKey:@"returnMoney"];
                IFISNILFORNUMBER(vInfo.returnMoney);
                vInfo.isChecked = YES;
                [vCartArray addObject:vInfo];
                //保存商家id
                [self addBunsinessID:vInfo];
                SAFE_ARC_RELEASE(vInfo);
            }
        }
        //对商家进行分类
        NSMutableArray *vClassfiedArray = [self getClassifiedBunessInfo:vCartArray];
        self.purchaseInfoArray = vClassfiedArray;
        //计算合计信息
        NSMutableArray *vHeadInfoArray = [self getHeadSummationInfo:self.purchaseInfoArray];
        self.bunessHeadInfoArray = vHeadInfoArray;
        
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"获取购物车数据" Notice:Nil];
}

#pragma mark 隐藏naviButton
-(void)hideNavigationItem{
    RootTabBarVC *vVC = (RootTabBarVC *)[ViewControllerManager getBaseViewController:@"RootTabBarVC"];
    [vVC hideShopingCarNavi];
}

#pragma mark 显示Navibutton
-(void)showNaviGationItem{
    RootTabBarVC *vVC = (RootTabBarVC *)[ViewControllerManager getBaseViewController:@"RootTabBarVC"];
    [vVC setShoppingCarNavi];
}

#pragma mark PurchaseCarCellDelegate
#pragma mark 订单数量增减
-(void)didPurchaseCarCellCountChanged:(PurchaseCarInfo *)aInfo{
    if (aInfo == Nil) {
        return;
    }
    [self replaceProductsInfoOnRow:aInfo];
}

#pragma mark PurchaseConfirmVCDelegate
#pragma mark 订单提交成功

-(void)didPurchaseConfirmVCSubmitSucces:(id)sender{
    [self initWebData];
}

#pragma mark PurchaseHeaderCellDelegate
#pragma mark 订单的勾选状态
-(void)didPurchaseHeaderCellCheckChanged:(PurchaseHeadInfo *)aInfo{
    if (aInfo == Nil) {
        return;
    }
    [self replaceHeadCheckInfo:aInfo];
}

#pragma mark 添加商家id 分类
-(void)addBunsinessID:(PurchaseCarInfo *)aInfo{
    BOOL isHasInfo = NO;
    //判断是否已经添加了该商家id
    for (NSString *bId in mBunessIdInfoArray) {
        if ([bId isEqualToString:aInfo.businessId]) {
            isHasInfo = YES;
        }
    }
    //没有添加则加入到数组
    if (!isHasInfo) {
        [mBunessIdInfoArray addObject:aInfo.businessId];
        //商家订单默认勾选
    }
}

#pragma mark 按照商家对订单进行分类
-(NSMutableArray *)getClassifiedBunessInfo:(NSMutableArray *)aBunessInfoArray{
    NSMutableArray *vClassfiedBunessInfoArray = [NSMutableArray array];
    for (NSString *vBid in mBunessIdInfoArray) {
        NSMutableArray *vItemArray = [NSMutableArray array];
        //寻找商家id相同的订单信息
        for (PurchaseCarInfo *vInfo in aBunessInfoArray) {
            if([vBid isEqualToString:vInfo.businessId]){
                [vItemArray addObject:vInfo];
            }
        }
        //如果找到了订单信息，加入到数组
        if (vItemArray.count > 0) {
            [vClassfiedBunessInfoArray addObject:vItemArray];
        }
    }
    
    return vClassfiedBunessInfoArray;
}

#pragma mark 计算商家合计信息
-(NSMutableArray *)getHeadSummationInfo:(NSMutableArray *)aBunessInfoArray{
    NSMutableArray *vHeadInfoArray = [NSMutableArray array];
    for (NSMutableArray *vItemArray in aBunessInfoArray) {
        PurchaseHeadInfo *vHeadInfo = [[PurchaseHeadInfo alloc] init];
        vHeadInfo.isCheck = YES;
        for (PurchaseCarInfo *vInfo in vItemArray) {
            vHeadInfo.bunessName = vInfo.businessName;
            //计算原价的总价
            NSInteger vSumMoney = [vHeadInfo.summPriceMoney intValue];
            vSumMoney += [vInfo.price intValue]* [vInfo.count intValue];
            vHeadInfo.summPriceMoney = [NSNumber numberWithInt:vSumMoney];
            
            //计算会员的总价
            NSInteger vVipMoney = [vHeadInfo.summVipPriceMoney intValue];
            vVipMoney +=[vInfo.vipPrice intValue] * [vInfo.count intValue];
            vHeadInfo.summVipPriceMoney = [NSNumber numberWithInt:vVipMoney];
            //服务类型
            vHeadInfo.serviceType = vInfo.serviceType;
        }
        [vHeadInfoArray addObject:vHeadInfo];
    }
    
    return vHeadInfoArray;
}

#pragma mark 获取最终用户选择的订单
-(NSMutableArray *)getFinalOrderInfo{
    NSMutableArray *vFinalOrderArray = [NSMutableArray array];
    for (NSInteger index = 0; index < self.bunessHeadInfoArray.count; index++) {
        PurchaseHeadInfo *vInfo = [self.bunessHeadInfoArray objectAtIndex:index];
        if (vInfo.isCheck) {
            NSArray *vItemArray = [self.purchaseInfoArray objectAtIndex:index];
            [vFinalOrderArray addObject:vItemArray];
        }
    }
    
    return vFinalOrderArray;
}

#pragma mark 获取用户最终选择的商家合计信息
-(NSMutableArray *)getFinalHeadInfo{
    NSMutableArray *vFinalHeadInfo = [NSMutableArray array];
    for (NSInteger index = 0; index < self.bunessHeadInfoArray.count; index++) {
        PurchaseHeadInfo *vInfo = [self.bunessHeadInfoArray objectAtIndex:index];
        if (vInfo.isCheck) {
            [vFinalHeadInfo addObject:vInfo];
        }
    }
    return vFinalHeadInfo;
}

#pragma mark 替换掉购物车原信息
-(void)replaceProductsInfoOnRow:(PurchaseCarInfo *)aInfo{
    NSNumber *vReplaceSection = Nil;
    NSNumber *vReplaceRow = Nil;
    for (NSInteger vIndex  = 0; vIndex < self.purchaseInfoArray.count; vIndex ++) {
        //寻找每一个seciton
        NSArray *vItemArray = [self.purchaseInfoArray objectAtIndex:vIndex];
        //寻找sction下是否有当前改变的商家
        for (NSInteger vRow = 0; vRow < vItemArray.count ; vRow++) {
            PurchaseCarInfo *vInfo = [vItemArray objectAtIndex:vRow];
            if ([vInfo.serviceId isEqualToString:aInfo.serviceId]) {
                //保存商家索引
                vReplaceSection = [NSNumber numberWithInt:vIndex];
                vReplaceRow = [NSNumber numberWithInt:vRow];
            }
        }

    }
    if (vReplaceSection != Nil) {
        //找到seciton的数租
        NSMutableArray *vSectionArray = [self.purchaseInfoArray objectAtIndex:[vReplaceSection intValue]];
        //改变商家信息
        [vSectionArray replaceObjectAtIndex:[vReplaceRow intValue] withObject:aInfo];
        //改变Section数组信息
        [self.purchaseInfoArray replaceObjectAtIndex:[vReplaceSection intValue] withObject:vSectionArray];
        //重新计算合计信息
        NSMutableArray *vNewHeadInfo =[self getHeadSummationInfo:self.purchaseInfoArray];
        self.bunessHeadInfoArray = vNewHeadInfo;
    }
}

#pragma mark 替换掉商家订单的勾选状态信息
-(void)replaceHeadCheckInfo:(PurchaseHeadInfo *)aHeadInfo{
    NSNumber *vReplaceIndex = Nil;
    for (NSInteger vIndex = 0 ; vIndex < self.bunessHeadInfoArray.count; vIndex++) {
        PurchaseHeadInfo *vHeadInfo = [self.bunessHeadInfoArray objectAtIndex:vIndex];
        if ([vHeadInfo.bunessName isEqualToString:aHeadInfo.bunessName]) {
            vReplaceIndex = [NSNumber numberWithInt:vIndex];
        }
    }
    
    if (vReplaceIndex != Nil) {
        [self.bunessHeadInfoArray replaceObjectAtIndex:[vReplaceIndex intValue] withObject:aHeadInfo];
    }
}

#pragma mark 删除购物车订单
-(void)deleteOrder:(PurchaseCarInfo *)aInfo PathIndex:(NSIndexPath *)aPath{
    id userId = [UserManager instanceUserManager].userID;
    NSArray *serviceInfo = @[@{@"serviceId": aInfo.serviceId,@"count":aInfo.count}];
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                userId,@"userId",
                                serviceInfo,@"serviceInfo",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL703 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                NSMutableArray *vItemArray = [self.purchaseInfoArray objectAtIndex:aPath.section];
                [vItemArray removeObject:aInfo];
                if (vItemArray.count == 0) {
                    //没有订单信息，将商家的所有信息移除
                    [self.purchaseInfoArray removeObjectAtIndex:aPath.section];
                    //移除商家合计信息
                    [self.bunessHeadInfoArray removeObjectAtIndex:aPath.section];
                }else{
                    //移除商家信息
                    [self.purchaseInfoArray replaceObjectAtIndex:aPath.section withObject:vItemArray];
                    //重新计算合计信息
                     NSMutableArray *vNewHeadInfo =[self getHeadSummationInfo:self.purchaseInfoArray];
                    self.bunessHeadInfoArray = vNewHeadInfo;
                }
                [self.purchaseTableView reloadData];
            }else {
                [SVProgressHUD showErrorWithStatus:@"删除失败，请重试"];
            }
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"删除购物车订单" Notice:@""];
}

#pragma mark - 其他业务点击事件
-(BOOL)editButtonTouchDown{
    if (self.purchaseTableView.editing) {
        [self.purchaseTableView setEditing:NO animated:YES];
    }else{
        [self.purchaseTableView setEditing:YES animated:YES];
    }
    
    return self.purchaseTableView.editing;
}

#pragma mark - 结算订单
-(void)closeAcountTouchDown{
    NSMutableArray *vFinalOrderArray = [self getFinalOrderInfo];
    NSMutableArray *vFinalHeadInfo = [self getFinalHeadInfo];
    if (vFinalOrderArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择订单"];
        return;
    }
    [ViewControllerManager createViewController:@"PurchaseConfirmVC"];
    PurchaseConfirmVC *vVC = (PurchaseConfirmVC *)[ViewControllerManager getBaseViewController:@"PurchaseConfirmVC"];
    vVC.confirmInfoArray = vFinalOrderArray;
    vVC.headInfoArray = vFinalHeadInfo;
    vVC.delegate = self;
    [ViewControllerManager showBaseViewController:@"PurchaseConfirmVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 购物车编辑
-(void)shoppingCartEditButtonTouchDown:(UIButton *)sender{
    BOOL isEdit = [self editButtonTouchDown];
    if (isEdit) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

#pragma mark 购物车去结算
-(void)payMentButtonTouchDown:(UIButton *)sender{
    [self closeAcountTouchDown];
}

@end
