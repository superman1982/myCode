//
//  PayOrderVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-8.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "PayOrderVC.h"
#import "NetManager.h"
#import "UserManager.h"
#import "ActivityRouteManeger.h"

@interface PayOrderVC ()
@property (nonatomic,retain) UITextField *payAmountFiled;
@property (nonatomic,retain) UITextField *payPassWordField;
@end

@implementation PayOrderVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"PayOrderVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"PayOrderVC" bundle:aBuddle];
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
    self.title = @"支付订单";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定支付" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 80, 44)];
    [vRightButton addTarget:self action:@selector(payConfirmButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
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
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.payAmountFiled.text = [NSString stringWithFormat:@"%@",self.oderInfo.totalprice ];
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

-(UITextField *)payAmountFiled{
    if (_payAmountFiled == nil) {
        _payAmountFiled = [[UITextField alloc] initWithFrame:CGRectMake(93, 7, 150, 30)];
        _payAmountFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _payAmountFiled.borderStyle = UITextBorderStyleNone;
        _payAmountFiled.returnKeyType = UIReturnKeyDone;
        _payAmountFiled.keyboardType = UIKeyboardTypePhonePad;
        _payAmountFiled.font = [UIFont systemFontOfSize:14];
        _payAmountFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _payAmountFiled.delegate = self;
        _payAmountFiled.userInteractionEnabled = NO;
        [_payAmountFiled setTextColor:[UIColor orangeColor]];
    }
    return _payAmountFiled;
}

-(UITextField *)payPassWordField{
    if (_payPassWordField == nil) {
        _payPassWordField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _payPassWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _payPassWordField.borderStyle = UITextBorderStyleRoundedRect;
        _payPassWordField.returnKeyType = UIReturnKeyDone;
        _payPassWordField.secureTextEntry = YES;
        _payPassWordField.font = [UIFont systemFontOfSize:13];
        _payPassWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _payPassWordField.delegate = self;
    }
    return _payPassWordField;
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
        
    }
    if (indexPath.row == 0) {
        vCell.textLabel.text = @"应付途币：";
        [vCell.contentView addSubview:self.payAmountFiled];
    }else if (indexPath.row == 1){
        vCell.textLabel.text = @"支付密码：";
        [vCell.contentView addSubview:self.payPassWordField];
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 其他业务点击事件
-(void)payConfirmButtonTouchDown:(UIButton *)sender{
    if (self.payPassWordField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的支付密码！"];
        return;
    }
    NSDictionary *vParemeter = @{@"orderId": self.oderInfo.orderId,
                                 @"userId": [UserManager instanceUserManager].userInfo.usertId,
                                 @"payPassword": self.payPassWordField.text,
                                 };
    [NetManager postDataFromWebAsynchronous:APPURL833 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [ActivityRouteManeger refreshPayRelatedUI];
                [self back];
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"支付订单" Notice:@""];
}

@end
