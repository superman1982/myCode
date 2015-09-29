//
//  PurchaseConfirmVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-4.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "PurchaseConfirmVC.h"
#import "PurchaseCarInfo.h"
#import "PurchaseConfirmCell.h"
#import "UserManager.h"
#import "NetManager.h"

@interface PurchaseConfirmVC ()
{
    NSMutableArray *messageTextFieldArray;
}
@end

@implementation PurchaseConfirmVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"PurchaseConfirmVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"PurchaseConfirmVC" bundle:aBuddle];
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
    self.title = @"确认订单";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 80, 44)];
    [vRightButton addTarget:self action:@selector(submitOrdersButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    messageTextFieldArray = [[NSMutableArray alloc] init];
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
    NSInteger vSummtationMoney = 0;
    for (PurchaseHeadInfo *vHeadInfo in self.headInfoArray) {
        NSInteger itemMoney = [vHeadInfo.summVipPriceMoney intValue];
        vSummtationMoney += itemMoney;
        //代办加上工本费
        if ([vHeadInfo.serviceType intValue] == 12) {
            vSummtationMoney += [vHeadInfo.summPriceMoney intValue];
        }
    }
    self.finalAcountMoneyLable.text = [NSString stringWithFormat:@"%d",vSummtationMoney];
    
    //创建留言输入框
    for (NSInteger index = 0; index < self.headInfoArray.count;index++) {
        UITextField *vField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 220, 30)];
        vField.clearButtonMode = UITextFieldViewModeWhileEditing;
        vField.borderStyle = UITextBorderStyleRoundedRect;
        vField.returnKeyType = UIReturnKeyDone;
        vField.font = [UIFont systemFontOfSize:15];
        vField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        vField.delegate = self;
        [messageTextFieldArray addObject:vField];
        vField = Nil;
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
}
#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}

//-----------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)setConfirmInfoArray:(NSMutableArray *)confirmInfoArray{
    if (_confirmInfoArray == Nil) {
        _confirmInfoArray = [[NSMutableArray alloc] init];
    }
    [_confirmInfoArray removeAllObjects];
    [_confirmInfoArray addObjectsFromArray:confirmInfoArray];
    [self.purchaseConfirmTableView reloadData];
}

-(void)setHeadInfoArray:(NSMutableArray *)headInfoArray{
    if (_headInfoArray == Nil) {
        _headInfoArray = [[NSMutableArray alloc] init];
    }
    [_headInfoArray removeAllObjects];
    [_headInfoArray addObjectsFromArray:headInfoArray];
    [self.purchaseConfirmTableView reloadData];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger vCount = self.confirmInfoArray.count;
    return vCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    PurchaseHeaderCell *vCell = [[[NSBundle mainBundle]loadNibNamed:@"PurchaseHeaderCell" owner:self options:Nil] objectAtIndex:0];
    return vCell.frame.size.height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PurchaseHeaderCell *vCell = [[[NSBundle mainBundle]loadNibNamed:@"PurchaseHeaderCell" owner:self options:Nil] objectAtIndex:0];
    [vCell.checkButton setHidden:YES];
    //将商家名向左移动
    [vCell.bunessName setFrame:CGRectMake(10, vCell.bunessName.frame.origin.y, vCell.bunessName.frame.size.width + 20, 21)];
    [vCell setCell:[self.headInfoArray objectAtIndex:section]];
    return vCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSMutableArray *vItemArray = [self.confirmInfoArray objectAtIndex:section];
    if (vItemArray.count > 0) {
        return vItemArray.count + 1;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"confirmCell";
    PurchaseConfirmCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == Nil) {
        vCell = [[[NSBundle mainBundle]loadNibNamed:@"PurchaseConfirmCell" owner:self options:Nil] objectAtIndex:0];
    }
    
    NSArray *vItemArray = [self.confirmInfoArray objectAtIndex:indexPath.section];
    if (indexPath.row == vItemArray.count) {
        UITextField *vFiled = [messageTextFieldArray objectAtIndex:indexPath.section];
        [vCell.contentView addSubview:vFiled];
        vCell.productName.text = @"留  言:";
        vCell.acount.hidden = YES;
        vCell.vipPrice.hidden = YES;
    }else{
        NSMutableArray *vItemArray = [self.confirmInfoArray objectAtIndex:indexPath.section];
        PurchaseCarInfo *vInfo = [vItemArray objectAtIndex:indexPath.row];
        vCell.productName.text = vInfo.name;
        vCell.acount.text = [NSString stringWithFormat:@"%@",vInfo.count ];
        vCell.vipPrice.text = [NSString stringWithFormat:@"费用 %@",vInfo.vipPrice ];
        if ([vInfo.serviceType intValue]== 12) {
            NSInteger vCost = [vInfo.vipPrice intValue] + [vInfo.price intValue];
            vCell.vipPrice.text = [NSString stringWithFormat:@"费用 %d",vCost ];
        }
    }
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 其他辅助功能
#pragma mark 获取最终订单数据结构
-(NSMutableArray *)getFinalPostOrderInfo{
    NSMutableArray *vSubmitOrderArray = [NSMutableArray array];
    for (NSInteger vIndex = 0; vIndex < self.confirmInfoArray.count; vIndex++) {
        NSMutableArray *vItemtArray = [self.confirmInfoArray objectAtIndex:vIndex];
        //用户留言信息
        UITextField *vFiled = [messageTextFieldArray objectAtIndex:vIndex];
        NSString *userComment = vFiled.text;
        IFISNIL(userComment);
        for (PurchaseCarInfo *vInfo in vItemtArray) {
            NSDictionary *vDic = @{@"businessId": vInfo.businessId,
                                   @"serviceType": vInfo.serviceType,
                                   @"standardServiceType": vInfo.standardServiceType,
                                   @"serviceId": vInfo.serviceId,
                                   @"count": vInfo.count,
                                   @"userComment":userComment,
                                   };
            [vSubmitOrderArray addObject:vDic];
        }
    }
    return vSubmitOrderArray;
}

#pragma mark - 其他业务点击事件
-(void)submitOrdersButtonTouchDown:(UIButton *)sender{
    NSMutableDictionary *vParemeter = [NSMutableDictionary dictionary];
    id userId = [UserManager instanceUserManager].userID;
    
    NSMutableArray *services = [self getFinalPostOrderInfo];
    [vParemeter setObject:userId forKey:@"userId"];
    [vParemeter setObject:services forKey:@"services"];
    
    [NetManager postDataFromWebAsynchronous:APPURL704 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *stateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (stateNumber != Nil) {
            if ([stateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                if ([_delegate respondsToSelector:@selector(didPurchaseConfirmVCSubmitSucces:)]) {
                    [_delegate didPurchaseConfirmVCSubmitSucces:Nil];
                }
                [self back];
                return ;
            }
        }
        
        [SVProgressHUD showErrorWithStatus:@"提交失败！"];
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"提交订单" Notice:@"正在提交"];
}


@end
