//
//  ChongZhiVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChongZhiVC.h"
#import "ProductInfo.h"
#import "AliPayManeger.h"
#import "UserManager.h"
#import "NetManager.h"

@interface ChongZhiVC ()
{
    AliPayManeger *mPayManeger ;
}
//账号
@property (nonatomic,retain) UITextField *acountField;
//数量
@property (nonatomic,retain) UITextField *amountField;
//金额
@property (nonatomic,retain) UILabel *costLable;

@end

@implementation ChongZhiVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"ChongZhiVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChongZhiVC" bundle:aBuddle];
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
    self.title = @"积分充值";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"充值付款" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 80, 44)];
    [vRightButton addTarget:self action:@selector(chongZhiButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
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
    [mPayManeger release];
    [_acountField release];
    [_amountField release];
    [_costLable release];
    [_chongZhiTableView release];
    [_chongZhiFooterView release];
    [_chongZhiMoneyLable release];
    [_giveMoneyLable release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.chongZhiTableView.clickeDelegate = self;
    self.acountField.text = [UserManager instanceUserManager].userInfo.phone;
    self.chongZhiMoneyLable.text = [NSString stringWithFormat:@"%@",[UserManager instanceUserManager].userInfo.rechargeMoney];
    self.giveMoneyLable.text = [NSString stringWithFormat:@"%@",[UserManager instanceUserManager].userInfo.giveMoney];
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
    _acountField = nil;
    _amountField = nil;
    _costLable = nil;
    [super viewShouldUnLoad];
}
//----------

-(UITextField *)acountField{
    if (_acountField == nil) {
        _acountField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _acountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _acountField.borderStyle = UITextBorderStyleNone;
        _acountField.returnKeyType = UIReturnKeyDone;
        _acountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _acountField.delegate = self;
    }
    
    return _acountField;
}

-(UITextField *)amountField{
    if (_amountField == nil) {
        _amountField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _amountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _amountField.borderStyle = UITextBorderStyleRoundedRect;
        _amountField.returnKeyType = UIReturnKeyDone;
        _amountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        _amountField.keyboardType = UIKeyboardTypeDecimalPad;
        _amountField.delegate = self;
    }
    return _amountField;
}

-(UILabel *)costLable{
    if (_costLable == nil) {
        _costLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 160, 21)];
        _costLable.font = [UIFont systemFontOfSize:14];
        _costLable.backgroundColor = [UIColor clearColor];
    }
    return _costLable;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1)
      return 35;
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"充值数量不少于100";
    }
    return @"";
}

#pragma mark tableview headerview背景
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    UILabel *vTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 21)];
    vTitleLable.backgroundColor = [UIColor clearColor];
    [vTitleLable setFont:[UIFont systemFontOfSize:15]];
    vTitleLable.textColor = [UIColor darkGrayColor];
    
    if (section == 1) {
        vTitleLable.text = @"充值数量不少于100";
        [headerView addSubview:vTitleLable];
    }
    
    SAFE_ARC_AUTORELEASE(vTitleLable);
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(270, 11, 20, 21)];
        vLable.font = [UIFont systemFontOfSize:15];
        vLable.textColor = [UIColor darkGrayColor];
        vLable.tag = 100;
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //文字描述
            vCell.textLabel.text = @"充值账号:";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.hidden = YES;
            //账号输入框
            self.acountField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.acountField];
        }else if (indexPath.row == 1){
            //文字描述
            vCell.textLabel.text = @"充值数量:";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.text = @"个";
            //数量输入框
            self.amountField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.amountField];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [vCell.contentView addSubview:self.chongZhiFooterView];
        }
    }
    return vCell;
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
}
//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //计算金额
    if (textField == self.amountField) {
        
    }
}

#pragma mark 屏幕点击事件

-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.acountField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.amountField.frame, vTouchPoint)) {
        [self.amountField resignFirstResponder];
        [self.acountField resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.acountField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.amountField.frame, vTouchPoint)) {
        [self.amountField resignFirstResponder];
        [self.acountField resignFirstResponder];
    }
}

#pragma mark - 其他辅助功能
-(void)payMoney:(id)aOrderId Mount:(float)aMount{
    if (aOrderId == Nil) {
        return;
    }
    ProductInfo *vProductInfo = [[ProductInfo alloc] init];
    vProductInfo.subject = @"充值途币";
    vProductInfo.body = @"充值途币";
    vProductInfo.price =  aMount;
    vProductInfo.orderId = aOrderId;
    
    if (mPayManeger == Nil) {
        mPayManeger = [[AliPayManeger alloc] init];
    }
    [mPayManeger payAliProduct:vProductInfo];
    SAFE_ARC_AUTORELEASE(vProductInfo);
}

#pragma mark - 其他业务点击事件
-(void)chongZhiButtonTouchDown:(UIButton *)sender{
    
    NSString *paymentAmountStr = self.amountField.text;
    if (paymentAmountStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写充值数量！"];
        return;
    }
    float vAmount = [paymentAmountStr floatValue];
    if (vAmount < 100) {
        [SVProgressHUD showErrorWithStatus:@"充值金额不小于100"];
        return;
    }
    //获取充值订单
    id userId = [UserManager instanceUserManager].userID;
    id orderType = [NSNumber numberWithInt:1];
    id payType = [NSNumber numberWithInt:1];
    id paymentAmount = [NSNumber numberWithFloat:vAmount];
    NSDictionary *vParemeterForID = [NSDictionary dictionaryWithObjectsAndKeys:
                                     userId,@"userId",
                                     orderType,@"orderType",
                                     payType,@"payType",
                                     paymentAmount,@"paymentAmount",
                                     nil];
    [SVProgressHUD showWithStatus:@"正在请求订单"];
    [NetManager postDataFromWebAsynchronous:APPURL805 Paremeter:vParemeterForID Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            [self payMoney:[vDataDic objectForKey:@"orderNumber"] Mount:vAmount];
        }
        [SVProgressHUD dismiss];
    } Failure:^(NSURLResponse *response, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    } RequestName:@"请求充值途币订单" Notice:@""];
    
}

#pragma mark AliPayManegerDelegate 
//#pragma mark 充值成功回调
//-(void)didAliPayManegerPaySucess:(ProductInfo *)sender{
//    id userId = [UserManager instanceUserManager].userID;
//    id orderNumber = sender.orderId;
//    
//    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
//                                userId,@"userId",
//                                orderNumber,@"orderNumber",
//                                nil];
//    [NetManager postDataFromWebAsynchronous:APPURL805 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
//        
//    } Failure:^(NSURLResponse *response, NSError *error) {
//        
//    } RequestName:@"充值成功回调"];
//}


- (void)viewDidUnload {
[self setChongZhiTableView:nil];
    [self setChongZhiFooterView:nil];
    [self setChongZhiMoneyLable:nil];
    [self setGiveMoneyLable:nil];
[super viewDidUnload];
}
@end
