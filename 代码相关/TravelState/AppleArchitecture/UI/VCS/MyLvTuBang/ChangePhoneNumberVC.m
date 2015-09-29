//
//  ChangePhoneNumberVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-17.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChangePhoneNumberVC.h"
#import "ButtonHelper.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "NetManager.h"
#import "SecrityButtonManeger.h"
#import "CheckManeger.h"

@interface ChangePhoneNumberVC ()
{
    SecrityButtonManeger *mSectityManeger;
    UIButton *mCodeButton;
}
@property (nonatomic,retain) UITextField *phoneNumberTextField;
@property (nonatomic,retain) UITextField *securityPhoneCodeField;
@property (nonatomic,retain) UITextField *acountPasswordField;
@end

@implementation ChangePhoneNumberVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ChangePhoneNumberVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChangePhoneNumberVC" bundle:aBuddle];
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
    self.title = @"修改手机号";
    
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(confirmPhoneNumberButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
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
    [mSectityManeger release];
    [mCodeButton release];
    [_changePhoneTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.changePhoneTableView.clickeDelegate = self;
    if (mSectityManeger == Nil) {
        mSectityManeger = [[SecrityButtonManeger alloc] init];
        mSectityManeger.delegate = self;
    }
    if (mCodeButton == Nil) {
        mCodeButton = [mSectityManeger creatSecrityCodeButton];
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

#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}

//----------
- (void)viewDidUnload {
    [self setChangePhoneTableView:nil];
    [super viewDidUnload];
}


-(UITextField *)phoneNumberTextField{
    if (_phoneNumberTextField == nil) {
        _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
        _phoneNumberTextField.returnKeyType = UIReturnKeyDone;
        _phoneNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumberTextField.delegate = self;
    }
    
    return _phoneNumberTextField;
}

-(UITextField *)securityPhoneCodeField{
    if (_securityPhoneCodeField == Nil) {
        _securityPhoneCodeField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _securityPhoneCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _securityPhoneCodeField.borderStyle = UITextBorderStyleRoundedRect;
        _securityPhoneCodeField.returnKeyType = UIReturnKeyDone;
        _securityPhoneCodeField.font = [UIFont systemFontOfSize:13];
        _securityPhoneCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _securityPhoneCodeField.delegate = self;
    }
    return _securityPhoneCodeField;
}

-(UITextField *)acountPasswordField{
    if (_acountPasswordField == Nil) {
        _acountPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _acountPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _acountPasswordField.borderStyle = UITextBorderStyleRoundedRect;
        _acountPasswordField.returnKeyType = UIReturnKeyDone;
        _acountPasswordField.secureTextEntry = YES;
        _acountPasswordField.placeholder = @"请使用字母数字加符号组合";
        _acountPasswordField.font = [UIFont systemFontOfSize:13];
        _acountPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _acountPasswordField.delegate = self;
    }
    return _acountPasswordField;
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:14];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryNone;
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            vCell.textLabel.text = @"新手机号:";
            
            self.phoneNumberTextField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.phoneNumberTextField];
        }
        else if (indexPath.row == 1) {
            vCell.textLabel.text = @"验证码:";
            
            self.securityPhoneCodeField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.securityPhoneCodeField];
   
            [vCell.contentView addSubview:mCodeButton];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            vCell.textLabel.text = @"账号密码 :";
            
            self.acountPasswordField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.acountPasswordField];
            
            UIButton *vShowPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vShowPassWordButton createButtonWithFrame:CGRectMake(320-70, 13, 59, 22) Title:@"" NormalImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] HelightImage:Nil Target:self SELTOR:@selector(showPayPassWordButtonClicked:)];
            [vCell.contentView addSubview:vShowPassWordButton];
        }
    }
    return vCell;
}

#pragma mark UItextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {}

- (void)textFieldDidEndEditing:(UITextField *)textField {}

#pragma mark 屏幕点击事件
-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.phoneNumberTextField.frame,vTouchPoint)
        && !CGRectContainsPoint(self.securityPhoneCodeField.frame,vTouchPoint)
        && !CGRectContainsPoint(self.acountPasswordField.frame,vTouchPoint)) {
        [self.phoneNumberTextField resignFirstResponder];
        [self.securityPhoneCodeField resignFirstResponder];
        [self.acountPasswordField resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.phoneNumberTextField.frame,vTouchPoint)
        && !CGRectContainsPoint(self.securityPhoneCodeField.frame,vTouchPoint)
        && !CGRectContainsPoint(self.acountPasswordField.frame,vTouchPoint)) {
        [self.phoneNumberTextField resignFirstResponder];
        [self.securityPhoneCodeField resignFirstResponder];
        [self.acountPasswordField resignFirstResponder];
    }
}

#pragma mark SecrityButtonManegerDelegate
-(NSString *)didSecrityButtonManegerButtonClicked:(id)sender{
    if (self.phoneNumberTextField.text.length > 0) {
        return self.phoneNumberTextField.text;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写手机号！"];
        return @"";
    }
    return @"";
}

#pragma mark 其他业务点击事件
-(void)confirmPhoneNumberButtonTouchDown:(id)sender{
    NSString *newPhone = self.phoneNumberTextField.text;
    if (newPhone.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的新手机号！"];
        return;
    }
    //手机合法检测
    if (![CheckManeger checkIfIsAllowedPhoneNumber:self.phoneNumberTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    
    NSString *verifyCode = self.securityPhoneCodeField.text;
    if (verifyCode.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码！"];
        return;
    }
    
    NSString *password = self.acountPasswordField.text;
    if (password.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的密码！"];
        return;
    }
    
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                newPhone,@"newPhone",
                                verifyCode,@"verifyCode",
                                password,@"password",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL824 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self back];
                //改变之前的电话号码
                [UserManager instanceUserManager].userInfo.phone = newPhone;
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:@"修改失败！"];
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"修改手机号" Notice:@""];
}

#pragma mark 显示密码
-(void)showPayPassWordButtonClicked:(UIButton *)sender{
    if (self.acountPasswordField.secureTextEntry) {
        self.acountPasswordField.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_select"] forState:UIControlStateNormal];
    }else{
        self.acountPasswordField.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] forState:UIControlStateNormal];
    }
}
@end
