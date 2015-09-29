//
//  LoginVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "LoginVC.h"
#import "UserManager.h"
#import "ConfigFile.h"

@interface LoginVC ()
{
    BOOL mIsRememberUserAcount;
}
@end

@implementation LoginVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"LoginVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"LoginVC" bundle:aBuddle];
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
    self.title = @"旅途邦";
    
    UIButton *vCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vCancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [vCancleButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vCancleButton addTarget:self action:@selector(cancleButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vCancleButton];
    self.navigationItem.leftBarButtonItem = vBarButtonItem;
    
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"登录" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(loginButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    self.isSelectedView = YES;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_acountField release];
    [_passWordField release];
    [_checkPasswordButton release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    mIsRememberUserAcount = YES;
    //检查是否记住了用户密码
    NSDictionary *vUserDic = [ConfigFile readConfigDictionary];
    id vIsRememberUserAcount = [vUserDic objectForKey:ISREMEMBERUSERACOUNT];
    //如果用户点击记住密码，则显示用户账户
    if ([vIsRememberUserAcount intValue]== 1) {
        NSString *vUserStr = [vUserDic objectForKey:USER];
        NSString *vPassWordStr = [vUserDic objectForKey:PASSWORD];
        self.acountField.text = vUserStr.length > 0 ? vUserStr :@"";
        self.passWordField.text = vPassWordStr.length > 0 ? vPassWordStr:@"";
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
#pragma mark UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 屏幕点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.acountField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.passWordField.frame, vTouchPoint)) {
        [self.passWordField resignFirstResponder];
        [self.acountField resignFirstResponder];
    }
}

#pragma mark - 其他业务点击事件
#pragma mark 取消登录
-(void)cancleButtonTouchDown:(id)sender{
    [ViewControllerManager backViewController:vaDefaultAnimation SubType:vsFromLeft];
}

#pragma mark 登录
-(void)loginButtonTouchDown:(id)sender{
    if (self.acountField.text.length > 0 && self.passWordField.text.length > 0) {
       [UserManager login:self.acountField.text password:self.passWordField.text IsRemberUserAcount:mIsRememberUserAcount Notice:@"正在登录" Success:^(NSURLResponse *response, id responseObject) {
               //通知根页面更改为登录后
               if ([_delegate respondsToSelector:@selector(didLoginSuccess:)]) {
                   [_delegate didLoginSuccess:self.isSelectedView];
                   [self cancleButtonTouchDown:Nil];
           }
       }];
    }
}

#pragma mark 显示密码
- (IBAction)showPassWord:(UIButton *)sender {
    if (!self.passWordField.secureTextEntry) {
        self.passWordField.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_default"] forState:UIControlStateNormal];
    }else{
        self.passWordField.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_select"] forState:UIControlStateNormal];
    }
    
}
#pragma mark 找回密码
- (IBAction)findPassword:(id)sender {
    [ViewControllerManager createViewController:@"FindPassWord"];
    [ViewControllerManager showBaseViewController:@"FindPassWord" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 记住密码
- (IBAction)rememberPassword:(UIButton *)sender {
    if (!mIsRememberUserAcount) {
        mIsRememberUserAcount = YES;
        [self.checkPasswordButton setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_select"] forState:UIControlStateNormal];
    }else{
        mIsRememberUserAcount = NO;
        [self.checkPasswordButton setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_default"] forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload {
    [self setAcountField:nil];
    [self setPassWordField:nil];
    [self setCheckPasswordButton:nil];
[super viewDidUnload];
}
@end
