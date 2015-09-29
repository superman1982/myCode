//
//  ChangePayPasswordVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-17.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChangePayPasswordVC.h"
#import "ButtonHelper.h"
#import "UserManager.h"
#import "NetManager.h"
#import "ActivityRouteManeger.h"

@interface ChangePayPasswordVC ()
{
    SecrityButtonManeger *mSecButtonManeger;
    UIButton *mCodeButton;
}
@property (nonatomic,retain) UITextField *originPasswordTextField;
@property (nonatomic,retain) UITextField *newPassWordTextField;
@property (nonatomic,retain) UITextField *securityCodeField;
@end

@implementation ChangePayPasswordVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ChangePayPasswordVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChangePayPasswordVC" bundle:aBuddle];
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
    self.title = @"修改支付密码";
    
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(confirmPassWordNumberButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
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
    _originPasswordTextField = Nil;
    _newPassWordTextField = Nil;
    [super viewShouldUnLoad];
}

//----------
- (void)viewDidUnload {
    [super viewDidUnload];
}


-(UITextField *)originPasswordTextField{
    if (_originPasswordTextField == Nil) {
        _originPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 7, 130, 30)];
        _originPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _originPasswordTextField.secureTextEntry = YES;
        _originPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _originPasswordTextField.returnKeyType = UIReturnKeyDone;
        _originPasswordTextField.font = [UIFont systemFontOfSize:13];
        _originPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _originPasswordTextField.delegate = self;
    }

    return _originPasswordTextField;
}

-(UITextField *)newPassWordTextField{
    if (_newPassWordTextField == Nil) {
        _newPassWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 7, 130, 30)];
        _newPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newPassWordTextField.secureTextEntry = YES;
        _newPassWordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _newPassWordTextField.returnKeyType = UIReturnKeyDone;
        _newPassWordTextField.font = [UIFont systemFontOfSize:13];
        _newPassWordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _newPassWordTextField.delegate = self;
    }
    return _newPassWordTextField;
}

-(UITextField *)securityCodeField{
    if (_securityCodeField == Nil) {
        _securityCodeField = [[UITextField alloc] initWithFrame:CGRectMake(120, 7, 120, 30)];
        _securityCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _securityCodeField.borderStyle = UITextBorderStyleRoundedRect;
        _securityCodeField.returnKeyType = UIReturnKeyDone;
        _securityCodeField.font = [UIFont systemFontOfSize:13];
        _securityCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _securityCodeField.delegate = self;
    }
    return _securityCodeField;
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 0;
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
            vCell.textLabel.text = @"原支付密码:";
            [vCell.contentView addSubview:self.originPasswordTextField];
        }else if (indexPath.row == 1){
            vCell.textLabel.text = @"设置新支付密码:";
            
            [vCell.contentView addSubview:self.newPassWordTextField];
            
            UIButton *vShowPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vShowPassWordButton createButtonWithFrame:CGRectMake(320-70, 13, 59, 22) Title:@"" NormalImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] HelightImage:Nil Target:self SELTOR:@selector(showPayPassWordButtonClicked:)];
            [vCell.contentView addSubview:vShowPassWordButton];
        }else if (indexPath.row == 2) {
            vCell.textLabel.text = @"手机验证码:";
            [vCell.contentView addSubview:self.securityCodeField];
        
            [vCell.contentView addSubview:mCodeButton];
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.newPassWordTextField.frame,vTouchPoint)
        && !CGRectContainsPoint(self.originPasswordTextField.frame,vTouchPoint)) {
        [self.newPassWordTextField resignFirstResponder];
        [self.originPasswordTextField resignFirstResponder];
    }
}

#pragma mark - 其他业务点击事件
#pragma mark 获取验证码
-(NSString *)didSecrityButtonManegerButtonClicked:(id)sender{
    NSString *vUserPhone = [UserManager instanceUserManager].userInfo.phone;
    IFISNIL(vUserPhone);
    return vUserPhone;
}

-(void)confirmPassWordNumberButtonTouchDown:(id)sender{
    NSString *password = self.originPasswordTextField.text;
    if (password.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入原支付密码！"];
        return;
    }
    
    NSString *newPassword = self.newPassWordTextField.text;
    if (newPassword .length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入新支付密码！"];
        return;
    }
    
    NSString *verifyCode = self.securityCodeField.text;
    if (verifyCode.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码！"];
        return;
    }
    
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                password,@"payPassword",
                                newPassword,@"newPayPassword",
                                verifyCode,@"verifyCode",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL826 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self back];
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:@"修改失败！"];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"修改登录密码" Notice:@""];
}

-(void)showPayPassWordButtonClicked:(UIButton *)sender{
    if (self.newPassWordTextField.secureTextEntry) {
        self.newPassWordTextField.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_select"] forState:UIControlStateNormal];
    }else{
        self.newPassWordTextField.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] forState:UIControlStateNormal];
    }
}

@end
