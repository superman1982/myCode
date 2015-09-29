//
//  FindPassWord.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "FindPassWord.h"
#import "ButtonHelper.h"
#import "NetManager.h"
#import "CheckManeger.h"

@interface FindPassWord ()
{
    SecrityButtonManeger *mSecButtonManeger;
    UIButton *mCodeButton;
}
@property (nonatomic,retain) UITextField *acountField;
@property (nonatomic,retain) UITextField *phoneNumberField;
@property (nonatomic,retain) UITextField *securityCodeField;
@property (nonatomic,retain) UITextField *newPassWordField;

@end

@implementation FindPassWord

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"FindPassWord_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"FindPassWord" bundle:aBuddle];
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
    self.title = @"找回密码";
    UIButton *vCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vCancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [vCancleButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vCancleButton addTarget:self action:@selector(cancleButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vCancleButton];
    self.navigationItem.leftBarButtonItem = vBarButtonItem;
    
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"完成" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(finishButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
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
    [_phoneNumberField release];
    [_securityCodeField release];
    [_newPassWordField release];
    [_acountField release];
    [_hotLineFooterView release];
    [_findPasswordTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.findPasswordTableView.clickeDelegate = self;
    //初始化获取验证码button
    if (mSecButtonManeger == Nil) {
        mSecButtonManeger = [[SecrityButtonManeger alloc] init];
        mSecButtonManeger.delegate = self;
    }
    if (mCodeButton == Nil) {
        mCodeButton = [mSecButtonManeger creatSecrityCodeButton];
    }
    //-----------
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
    _phoneNumberField = Nil;
    _securityCodeField = Nil;
    _newPassWordField = Nil;
    _acountField = Nil;
    [super viewShouldUnLoad];
}
//----------

-(UITextField *)acountField{
    if (_acountField == nil) {
        _acountField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _acountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _acountField.borderStyle = UITextBorderStyleRoundedRect;
        _acountField.returnKeyType = UIReturnKeyDone;
        _acountField.placeholder = @"填写注册时的用户名";
        _acountField.font = [UIFont systemFontOfSize:15];
        _acountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _acountField.delegate = self;
    }
    return _acountField;
}

-(UITextField *)phoneNumberField{
    if (_phoneNumberField == Nil) {
        _phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _phoneNumberField.returnKeyType = UIReturnKeyDone;
        _phoneNumberField.placeholder = @"将发送验证码至该手机";
        _phoneNumberField.font = [UIFont systemFontOfSize:15];
        _phoneNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumberField.delegate = self;
    }
    return _phoneNumberField;
}

-(UITextField *)securityCodeField{
    if (_securityCodeField == Nil) {
        _securityCodeField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _securityCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _securityCodeField.borderStyle = UITextBorderStyleRoundedRect;
        _securityCodeField.returnKeyType = UIReturnKeyDone;
        _securityCodeField.font = [UIFont systemFontOfSize:15];
        _securityCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _securityCodeField.delegate = self;
    }
    return _securityCodeField;
}

-(UITextField *)newPassWordField{
    if (_newPassWordField == Nil) {
        _newPassWordField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _newPassWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newPassWordField.borderStyle = UITextBorderStyleRoundedRect;
        _newPassWordField.returnKeyType = UIReturnKeyDone;
        _newPassWordField.secureTextEntry = YES;
        _newPassWordField.placeholder = @"请使用字母数字加符号组合";
        _newPassWordField.font = [UIFont systemFontOfSize:15];
        _newPassWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _newPassWordField.delegate = self;
    }
    return _newPassWordField;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return self.hotLineFooterView.frame.size.height;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.hotLineFooterView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

#pragma mark table背景颜色
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //文字描述
            vCell.textLabel.text = @"用户名:";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.hidden = YES;
            //账号输入框
            self.acountField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.acountField];
        }else if (indexPath.row == 1){
            //文字描述
            vCell.textLabel.text = @"手机号:";
            //电话号码输入框
            self.phoneNumberField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.phoneNumberField];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"验证码:";
            self.securityCodeField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.securityCodeField];
            
            [vCell.contentView addSubview:mCodeButton];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"新密码:";
            self.newPassWordField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.newPassWordField];
            
            UIButton *vShowPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vShowPassWordButton createButtonWithFrame:CGRectMake(320-70, 13, 59, 22) Title:@"" NormalImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] HelightImage:Nil Target:self SELTOR:@selector(showPassWordButtonClicked:)];
            [vCell.contentView addSubview:vShowPassWordButton];
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
}

#pragma mark 屏幕点击事件

-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.acountField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.phoneNumberField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.securityCodeField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.newPassWordField.frame, vTouchPoint)) {
        [self.acountField resignFirstResponder];
        [self.phoneNumberField resignFirstResponder];
        [self.newPassWordField resignFirstResponder];
        [self.securityCodeField resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.acountField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.phoneNumberField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.securityCodeField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.newPassWordField.frame, vTouchPoint)) {
        [self.acountField resignFirstResponder];
        [self.phoneNumberField resignFirstResponder];
        [self.newPassWordField resignFirstResponder];
        [self.securityCodeField resignFirstResponder];
    }
}

#pragma mark  - 其他业务点击事件
#pragma mark 完成
-(void)finishButtonTouchDown:(id)sender{
    if (self.acountField.text.length > 0
        && self.phoneNumberField.text.length > 0
        && self.securityCodeField.text.length > 0
        && self.newPassWordField.text.length > 0) {
        //拼接网络请求数据
        NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:self.acountField.text,@"username",self.phoneNumberField.text,@"phone",self.securityCodeField.text,@"verifyCode",self.newPassWordField.text,@"newPassword",nil];
        [NetManager postDataFromWebAsynchronous:APPURL303 Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            [self back];
        } Failure:^(NSURLResponse *response, NSError *error) {
            
        } RequestName:@"找回密码" Notice:@""];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写完整您的信息，以便我们帮您找回密码"];
    }
}

#pragma mark 取消
-(void)cancleButtonTouchDown:(id)sender{
    [ViewControllerManager backViewController:vaDefaultAnimation SubType:vsFromLeft];
}

#pragma mark 拨打电话
- (IBAction)phoneCallClicked:(id)sender {
    [TerminalData phoneCall:self.view PhoneNumber:CUSTOMRSERVICEPHONENUMBER];
}

#pragma mark SecrityButtonManegerDelegate
#pragma mark 获取验证码
-(NSString *)didSecrityButtonManegerButtonClicked:(id)sender{
    if (self.phoneNumberField.text.length > 0) {
        if (![CheckManeger checkIfIsAllowedPhoneNumber:self.phoneNumberField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号！"];
            return @"";
        }
        return self.phoneNumberField.text;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写手机号！"];
        return @"";
    }
    return @"";
}

#pragma mark 显示密码
-(void)showPassWordButtonClicked:(id)sender{
    if (self.newPassWordField.secureTextEntry) {
        self.newPassWordField.secureTextEntry = NO;
    }else{
        self.newPassWordField.secureTextEntry = YES;
    }
}

- (void)viewDidUnload {
 [self setFindPasswordTableView:nil];
    [self setHotLineFooterView:nil];
[super viewDidUnload];
}
@end
