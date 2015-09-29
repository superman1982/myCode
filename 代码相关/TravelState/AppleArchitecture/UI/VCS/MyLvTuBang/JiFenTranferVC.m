//
//  JiFenTranferVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-12.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "JiFenTranferVC.h"
#import "AnimationTransition.h"
#import "NetManager.h"
#import "UserManager.h"

@interface JiFenTranferVC ()
{
    id inUserId;
}
//账号
@property (nonatomic,retain) UITextField *inAcountField;
//数量
@property (nonatomic,retain) UITextField *amountField;
//支付密码
@property (nonatomic,retain) UITextField *passWordField;

//昵称
@property (nonatomic,retain) UITextField *nickNameField;

//电话
@property (nonatomic,retain) UITextField *phoneNumberField;

@end

@implementation JiFenTranferVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"JiFenTranferVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"JiFenTranferVC" bundle:aBuddle];
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
    [vRightButton setTitle:@"确认" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(confirmTranferButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
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
    [inUserId release];
    [_couldUserJiFen release];
    [_jiFenHeaderView release];
    [_jiFenTranferTableView release];
    [_xunWenView release];
    [_tuBiLable release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.jiFenTranferTableView.clickeDelegate = self;
    id vTuBi= [UserManager instanceUserManager].userInfo.rechargeMoney;
    NSString *vTuBiStr = [NSString stringWithFormat:@"%@",vTuBi];
    self.tuBiLable.text = vTuBiStr;
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
    [self setCouldUserJiFen:nil];
    [self setJiFenHeaderView:nil];
    [super viewShouldUnLoad];
}
//----------

-(UITextField *)inAcountField{
    if (_inAcountField == nil) {
        _inAcountField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _inAcountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inAcountField.borderStyle = UITextBorderStyleRoundedRect;
        _inAcountField.returnKeyType = UIReturnKeyDone;
        _inAcountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _inAcountField.placeholder = @"手机号";
        _inAcountField.delegate = self;
    }
    
    return _inAcountField;
}

-(UITextField *)amountField{
    if (_amountField == nil) {
        _amountField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _amountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _amountField.borderStyle = UITextBorderStyleRoundedRect;
        _amountField.returnKeyType = UIReturnKeyDone;
        _amountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _amountField.keyboardType = UIKeyboardTypeNumberPad;
        _amountField.delegate = self;
    }
    return _amountField;
}

-(UITextField *)passWordField{
    if (_passWordField == nil) {
        _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordField.borderStyle = UITextBorderStyleRoundedRect;
        _passWordField.returnKeyType = UIReturnKeyDone;
        _passWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passWordField.secureTextEntry = YES;
        _passWordField.delegate = self;
    }
    return _passWordField;
}

-(UITextField *)nickNameField{
    if (_nickNameField == nil) {
        _nickNameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _nickNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickNameField.borderStyle = UITextBorderStyleNone;
        _nickNameField.returnKeyType = UIReturnKeyDone;
        _nickNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nickNameField.userInteractionEnabled = NO;
        _nickNameField.delegate = self;
    }
    return _nickNameField;
}

-(UITextField *)phoneNumberField{
    if (_phoneNumberField == nil) {
        _phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberField.borderStyle = UITextBorderStyleNone;
        _phoneNumberField.returnKeyType = UIReturnKeyDone;
        _phoneNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumberField.userInteractionEnabled = NO;
        _phoneNumberField.delegate = self;
    }
    return _phoneNumberField;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1)
        return self.jiFenHeaderView.frame.size.height;
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.jiFenHeaderView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
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
            vCell.textLabel.text = @"转账账号:";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.hidden = YES;
            //账号输入框
            self.inAcountField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.inAcountField];
            
            UIButton *vAcountInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vAcountInfoButton setFrame:CGRectMake(320-80, 0, 80, 44)];
            vAcountInfoButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [vAcountInfoButton setImage:[UIImage imageNamed:@"recharge_check_btn_default"] forState:UIControlStateNormal];
            [vAcountInfoButton setImage:[UIImage imageNamed:@"recharge_check_btn_select"] forState:UIControlStateHighlighted];

            [vAcountInfoButton addTarget:self action:@selector(acountInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [vCell.contentView addSubview:vAcountInfoButton];
            
        }else if (indexPath.row == 1){
            //文字描述
            vCell.textLabel.text = @"姓    名:";
            //数量输入框
            self.nickNameField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.nickNameField];
        }else if (indexPath.row == 2){
            //文字描述
            vCell.textLabel.text = @"电话号码:";
            //数量输入框
            self.phoneNumberField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.phoneNumberField];
        }else if (indexPath.row == 3){
            //文字描述
            vCell.textLabel.text = @"转账数量:";
            //数量输入框
            self.amountField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.amountField];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"支付密码:";
            self.passWordField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.passWordField];
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
    CGRect frame = [textField convertRect:textField.frame toView:self.view.window];
    int offset = frame.origin.y + 32 - (mHeight + 20 - 216.0-36);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    isNeedToMoveFrame = NO;
    if(offset > 0){
        CGRect vViewFrame = self.view.frame;
        CGRect rect = CGRectMake(0.0f,vViewFrame.origin.y -offset ,width,height);
        
        if (!isShowChanese){
            rect.origin.y = rect.origin.y + 36;
            //根据本页面作特殊调整
            if (textField == self.amountField ) {
                rect.origin.y = rect.origin.y - 22;
            }
            isNeedToMoveFrame = YES;
        }
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}
//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //计算金额
    if (textField == self.amountField) {
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
#pragma mark 其他辅助功能
-(void)setScuretyCharactor:(NSString *)aNameStr Phone:(NSString *)aPhoneStr{
    if (aPhoneStr.length > 0) {
        NSRange vRange = NSMakeRange(3,4);
        aPhoneStr = [aPhoneStr stringByReplacingCharactersInRange:vRange withString:@"****"];
    }
    
    if (aNameStr.length >0) {
        if (aNameStr.length > 2) {
            NSRange vRange = NSMakeRange(0,1);
            aNameStr = [aNameStr stringByReplacingCharactersInRange:vRange withString:@"*"];
        }else if (aNameStr.length > 3){
            NSRange vRange = NSMakeRange(0,2);
            aNameStr = [aNameStr stringByReplacingCharactersInRange:vRange withString:@"**"];
        }
    }
    self.phoneNumberField.text = aPhoneStr;
    self.nickNameField.text = aNameStr;
}

#pragma mark - 其他业务点击事件
-(void)confirmTranferButtonTouchDown:(UIButton *)sender{
//    if (self.xunWenView.superview == nil) {
//        [self.view addSubview:self.xunWenView];
//    }
//    CGRect vDestRect = self.xunWenView.frame;
//    vDestRect = CGRectMake(0, mHeight - vDestRect.size.height -44, vDestRect.size.width, vDestRect.size.height);
//    CGRect vOriginRect = CGRectMake(0, mHeight, vDestRect.size.width, vDestRect.size.height);
//    [UIView moveToView:self.xunWenView DestRect:vDestRect OriginRect:vOriginRect duration:.2 IsRemove:NO Completion:Nil];
    if (inUserId == Nil) {
        UIAlertView *vAlerView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"为确保您的转出积分准确无误，请点击自动获取，以确定账号身份正确！" delegate:Nil cancelButtonTitle:@"知道了" otherButtonTitles:Nil, nil];
        [vAlerView show];
        SAFE_ARC_RELEASE(vAlerView);
        vAlerView = Nil;
        return;
    }else{
        NSMutableDictionary *vParemeter = [NSMutableDictionary dictionary];
        id vUserId = [UserManager instanceUserManager].userID;
        [vParemeter setObject:vUserId forKey:@"userId"];
        
        [vParemeter setObject:inUserId forKey:@"inUserId"];
        
        NSString *transferScore = self.amountField.text;
        if (transferScore.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写您的转人金额"];
            return;
        }
        NSNumber *vTransferNumber = [NSNumber numberWithInt:[transferScore intValue]];
        [vParemeter setObject:vTransferNumber forKey:@"transferScore"];
        
        NSString *vPayPassWord = self.passWordField.text;
        if (vPayPassWord.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写您的支付密码！"];
            return;
        }
        [vParemeter setObject:vPayPassWord forKey:@"payPassword"];
        
        [NetManager postDataFromWebAsynchronous:APPURL806 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
            NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
            NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
            NSString *vMessage = [vReturnDic objectForKey:@"stateMessage"];
            if (vStateNumber != Nil) {
                if ([vStateNumber intValue] == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"转账成功！"];
                    [self back];
                    return ;
                }
            }
            [SVProgressHUD showErrorWithStatus:vMessage];
        } Failure:^(NSURLResponse *response, NSError *error) {
        } RequestName:@"转账请求" Notice:@""];
    }
}
#pragma mark 充值
- (IBAction)chongZhiButtonClicked:(id)sender {
    [ViewControllerManager  createViewController:@"ChongZhiVC"];
    [ViewControllerManager showBaseViewController:@"ChongZhiVC" AnimationType:vaDefaultAnimation SubType:0];
}
- (IBAction)confirmZhuanChuButtonClicked:(id)sender {
    CGRect vDestRect = self.xunWenView.frame;
    vDestRect = CGRectMake(0, mHeight - vDestRect.size.height -44, vDestRect.size.width, vDestRect.size.height);
    CGRect vOriginRect = CGRectMake(0, mHeight, vDestRect.size.width, vDestRect.size.height);
    [UIView moveToView:self.xunWenView DestRect:vOriginRect OriginRect:vDestRect duration:.2 IsRemove:NO Completion:Nil];
}

- (IBAction)cancleZhuanChuButtonClicked:(id)sender {
    CGRect vDestRect = self.xunWenView.frame;
    vDestRect = CGRectMake(0, mHeight - vDestRect.size.height -44, vDestRect.size.width, vDestRect.size.height);
    CGRect vOriginRect = CGRectMake(0, mHeight, vDestRect.size.width, vDestRect.size.height);
    [UIView moveToView:self.xunWenView DestRect:vOriginRect OriginRect:vDestRect duration:.2 IsRemove:NO Completion:Nil];
}

#pragma mark 点击账号信息
-(void)acountInfoButtonClicked:(id)sender{
    if (self.inAcountField.text.length > 0) {
        NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:self.inAcountField.text,@"phone", nil];
        NSData *vReturnData = [NetManager postToURLSynchronous:APPURL409 Paremeter:vParemeter timeout:30 RequestName:@"获取旅途邦会员信息"];
        NSDictionary *vReturnDic = [NetManager jsonToDic:vReturnData];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            inUserId = [[NSString alloc] initWithString:[vDataDic objectForKey:@"userId"]];
            NSString *vPhoneStr = [vDataDic objectForKey:@"phone"];
            NSString *vNameStr = [vDataDic objectForKey:@"name"];
            [self setScuretyCharactor:vNameStr Phone:vPhoneStr];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请检查手机号是否输入正确！"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入账号或手机号!"];
    }

}

#pragma mark 屏幕点击事件

-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.inAcountField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.amountField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.passWordField.frame, vTouchPoint)) {
        [self.inAcountField resignFirstResponder];
        [self.passWordField resignFirstResponder];
        [self.amountField resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.inAcountField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.amountField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.passWordField.frame, vTouchPoint)) {
        [self.inAcountField resignFirstResponder];
        [self.passWordField resignFirstResponder];
        [self.amountField resignFirstResponder];
    }
}


- (void)viewDidUnload {
[self setCouldUserJiFen:nil];
[self setJiFenHeaderView:nil];
    [self setJiFenTranferTableView:nil];
    [self setXunWenView:nil];
    [self setTuBiLable:nil];
[super viewDidUnload];
}
@end
