//
//  ChanePassWordVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-17.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChanePassWordVC.h"
#import "ButtonHelper.h"
#import "NetManager.h"
#import "UserManager.h"

@interface ChanePassWordVC ()

@property (nonatomic,retain) UITextField *originPasswordTextField;
@property (nonatomic,retain) UITextField *newPassWordTextField;
@end

@implementation ChanePassWordVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ChanePassWordVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChanePassWordVC" bundle:aBuddle];
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
    self.title = @"修改登录密码";
    
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
        _originPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _originPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _originPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _originPasswordTextField.returnKeyType = UIReturnKeyDone;
        _originPasswordTextField.font = [UIFont systemFontOfSize:13];
        _originPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _originPasswordTextField.secureTextEntry = YES;
        _originPasswordTextField.delegate = self;
    }

    return _originPasswordTextField;
}

-(UITextField *)newPassWordTextField{
    if (_newPassWordTextField == Nil) {
        _newPassWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
        _newPassWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newPassWordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _newPassWordTextField.returnKeyType = UIReturnKeyDone;
        _newPassWordTextField.font = [UIFont systemFontOfSize:13];
        _newPassWordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _newPassWordTextField.secureTextEntry = YES;
        _newPassWordTextField.delegate = self;
    }
    
    return _newPassWordTextField;
}

#pragma mark UITableViewDelegate
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
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            vCell.textLabel.text = @"原密码:";
            self.originPasswordTextField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.originPasswordTextField];
        }else if (indexPath.row == 1){
            vCell.textLabel.text = @"新密码:";
            
            self.newPassWordTextField.center = vCell.contentView.center;
            [vCell.contentView addSubview:self.newPassWordTextField];
            
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
-(void)confirmPassWordNumberButtonTouchDown:(id)sender{
    NSString *password = self.originPasswordTextField.text;
    if (password.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入原密码！"];
        return;
    }
    
    NSString *newPassword = self.newPassWordTextField.text;
    if (newPassword.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码！"];
        return;
    }
    
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                password,@"password",
                                newPassword,@"newPassword",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL825 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
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

#pragma mark 显示密码
-(void)showPayPassWordButtonClicked:(UIButton *)sender{
    if (self.newPassWordTextField.secureTextEntry == YES) {
        self.newPassWordTextField.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_select"] forState:UIControlStateNormal];
    }else{
        self.newPassWordTextField.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] forState:UIControlStateNormal];
    }
}

@end
