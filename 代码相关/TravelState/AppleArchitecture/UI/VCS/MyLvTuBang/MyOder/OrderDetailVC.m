//
//  OrderDetailVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "OrderDetailVC.h"
#import "NetManager.h"
#import "OrderDetailCell.h"
#import "MyOrderCell.h"
#import "MyOrderHeaderCell.h"

@interface OrderDetailVC ()
{
    MyOrderCell *mCell;
}
@end

@implementation OrderDetailVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"OrderDetailVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"OrderDetailVC" bundle:aBuddle];
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
    self.title = @"订单详情";
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
    [oderDic removeAllObjects];
    [oderDic release];
    [_serviceArray removeAllObjects];
    [_serviceArray release];
    [_orderTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.amountLable.text = @"";
    self.totoalCostLable.text = @"";
    self.returnMoneyLable.text = @"";
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
    [self setOrderTableView:nil];
    [super viewDidUnload];
}

-(void)setOrderDetailArray:(NSMutableArray *)orderDetailArray{
    if (_orderDetailArray == Nil) {
        _orderDetailArray = [[NSMutableArray alloc] init];
    }
    [_orderDetailArray removeAllObjects];
    [_orderDetailArray addObjectsFromArray:orderDetailArray];
    [self.orderTableView reloadData];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.footerView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    [self setFooterUI];
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    MyOrderHeaderCell *vHeadCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderCell" owner:self options:nil] objectAtIndex:0];
    return  vHeadCell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyOrderHeaderCell *vHeadCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderCell" owner:self options:nil] objectAtIndex:0];
    OrderInfo *vInfo = [self.orderDetailArray lastObject];
    vHeadCell.serviceNameLable.text = vInfo.businessName;
    return  vHeadCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.orderDetailArray.count) {
        MyOrderCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil] objectAtIndex:0];
        OrderInfo *vOrderInfo = [self.orderDetailArray objectAtIndex:indexPath.row];
        NSInteger vHeight = [vCell setShowOderDetail:vOrderInfo];
        return vHeight;
    }else{
        OrderDetailCell *vCell  = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailCell" owner:self options:Nil] objectAtIndex:0];
        return vCell.frame.size.height;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderDetailArray.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.orderDetailArray.count) {
        static NSString *vCellIdentify = @"DetailCell";
        OrderDetailCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
        if (vCell == Nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailCell" owner:self options:Nil] objectAtIndex:0];
        }
        OrderInfo *vInfo = [self.orderDetailArray lastObject];
        [vCell setCell:vInfo];
        return vCell;
    }else{
        static NSString *vCellIdentify = @"orderCell";
        MyOrderCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
        if (vCell == nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil] objectAtIndex:0];
            
            UIView *vSeletedView = [[UIView alloc] initWithFrame:vCell.frame];
            [vSeletedView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:240.0/255 blue:255.0/255 alpha:1]];
            vCell.selectedBackgroundView = vSeletedView;
            SAFE_ARC_AUTORELEASE(vSeletedView);
        }
        [vCell setCell:[self.orderDetailArray objectAtIndex:indexPath.row]];
        [vCell setShowOderDetail:[self.orderDetailArray objectAtIndex:indexPath.row]];
        return vCell;
    }

    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 其他辅助功能
-(void)setFooterUI{
    OrderInfo *vInfo = [self.orderDetailArray lastObject];
    id vTotalAmount = vInfo.totalServices;
    IFISNILFORNUMBER(vTotalAmount);
    self.amountLable.text = [NSString stringWithFormat:@"数量: %@",vTotalAmount];
    
    id vTotalMoney = vInfo.totalprice;
    IFISNILFORNUMBER(vTotalMoney);
    self.totoalCostLable.text = [NSString stringWithFormat:@"%@",vTotalMoney];
    id vReturnMoney = vInfo.totalreturnMoney;
    IFISNILFORNUMBER(vReturnMoney);
    self.returnMoneyLable.text = [NSString stringWithFormat:@" %@",vReturnMoney];
    
    if (vInfo.orderState  == otCancle) {
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self.payOrCommentButton setTitle:@"已撤销" forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1]];
    }else if (vInfo.orderState == otDealing) {
        
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self.payOrCommentButton setTitle:@"撤销订单" forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1]];
        
    }else if (vInfo.orderState  == otConfirm) {
        //设置付款按钮
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"myOrder_pay_btn_default"] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"myOrder_pay_btn_select"] forState:UIControlStateHighlighted];
    }else if (vInfo.orderState == otPayed) {
        if ([vInfo.isEvaluate intValue] == 1) {
            self.payOrCommentButton.hidden = NO;
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            [self.payOrCommentButton setTitle:@"已评论" forState:UIControlStateNormal];
            [self.payOrCommentButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1]];
        }else{
            //设置评论按钮
            self.payOrCommentButton.hidden = NO;
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"orderDetail_comment_btn_default"] forState:UIControlStateNormal];
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"orderDetail_comment_bt_select"] forState:UIControlStateHighlighted];
        }
    }
}

- (IBAction)payButtonTouchDown:(id)sender {
    //撤销订单
    if (mCell == Nil) {
        mCell = [[MyOrderCell alloc] init];
    }
    OrderInfo *vInfo = [self.orderDetailArray lastObject];
    [mCell dealPayButton:vInfo];
}

@end
