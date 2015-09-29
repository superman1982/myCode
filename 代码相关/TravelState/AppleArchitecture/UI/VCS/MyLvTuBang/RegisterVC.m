//
//  RegisterVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RegisterVC.h"
#import "ButtonHelper.h"
#import "AnimationTransition.h"
#import "NetManager.h"
#import "HttpDefine.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "ChoseProvinceVC.h"
#import "StringHelper.h"
#import "CustomAlertView.h"
#import "AgrementVC.h"
#import "CheckManeger.h"

@interface RegisterVC ()
{
    CGRect mOringRect;
    BOOL mIsAgreeAgrement;
    NSDictionary *mPlaceDic;
    BOOL isAllowedCharactor;
    
    SecrityButtonManeger *mSecButtonManeger;
    UIButton *mCodeButton;
}
@property (nonatomic,retain) UITextField *acountField;
@property (nonatomic,retain) UITextField *phoneNumberField;
@property (nonatomic,retain) UITextField *securityCodeField;
@property (nonatomic,retain) UITextField *passWordField;
@end

@implementation RegisterVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"RegisterVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"RegisterVC" bundle:aBuddle];
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
    self.title = @"注册";
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
    mIsAgreeAgrement = YES;
    self.isSelectedView = YES;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_registerTableView release];
    [_xieYiFooterView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.registerTableView.clickeDelegate = self;
    
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
    [super viewShouldUnLoad];
}
//----------
- (void)viewDidUnload {
    [self setRegisterTableView:nil];
    [self setXieYiFooterView:nil];
    [super viewDidUnload];
}

-(UITextField *)acountField{
    if (_acountField == nil) {
        _acountField = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, 150, 30)];
        _acountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _acountField.borderStyle = UITextBorderStyleRoundedRect;
        _acountField.returnKeyType = UIReturnKeyDone;
        _acountField.placeholder = @"建议使用字母和数字";
        _acountField.font = [UIFont systemFontOfSize:15];
        _acountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _acountField.delegate = self;
    }
    return _acountField;
}

-(UITextField *)phoneNumberField{
    if (_phoneNumberField == Nil) {
        _phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, 150, 30)];
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
        _securityCodeField = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, 150, 30)];
        _securityCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _securityCodeField.borderStyle = UITextBorderStyleRoundedRect;
        _securityCodeField.returnKeyType = UIReturnKeyDone;
        _securityCodeField.font = [UIFont systemFontOfSize:15];
        _securityCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _securityCodeField.delegate = self;
    }
    return _securityCodeField;
}

-(UITextField *)passWordField{
    if (_passWordField == Nil) {
        _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, 150, 30)];
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordField.borderStyle = UITextBorderStyleRoundedRect;
        _passWordField.returnKeyType = UIReturnKeyDone;
        _passWordField.secureTextEntry = YES;
        _passWordField.placeholder = @"请使用字母数字加符号组合";
        _passWordField.font = [UIFont systemFontOfSize:15];
        _passWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passWordField.delegate = self;
    }
    return _passWordField;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if(section == 1){
        return 2;
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
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //文字描述
            vCell.textLabel.text = @"用户名:";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.hidden = YES;
            //账号输入框
            [vCell.contentView addSubview:self.acountField];
            vCell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 1){
            //文字描述
            vCell.textLabel.text = @"手机号:";
            //电话号码输入框
            [vCell.contentView addSubview:self.phoneNumberField];
            vCell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 2){
            //文字描述
            vCell.textLabel.text = @"设置密码:";

            [vCell.contentView addSubview:self.passWordField];
            vCell.accessoryType = UITableViewCellAccessoryNone;
            
            UIButton *vShowPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            vShowPassWordButton.titleLabel.font = [UIFont systemFontOfSize:14];

            [vShowPassWordButton createButtonWithFrame:CGRectMake(320-70, 13, 59, 22) Title:@"" NormalImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] HelightImage:[UIImage imageNamed:@""]Target:self SELTOR:@selector(showPassWordButtonClicked:)];
            [vCell.contentView addSubview:vShowPassWordButton];
        }
        else if (indexPath.row == 3){
            //文字描述
            vCell.textLabel.text = @"所在地区:";
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"验证码:";

            [vCell.contentView addSubview:self.securityCodeField];
            vCell.accessoryType = UITableViewCellAccessoryNone;
            
            [vCell.contentView addSubview:mCodeButton];
        }else if (indexPath.row == 1){
            [vCell.contentView addSubview:self.xieYiFooterView];
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [self goToChosePlaceVC];
        }
    }
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.securityCodeField) {
        mOringRect = self.view.frame;
        CGRect vDestrect = CGRectMake(0, -50, 320, mOringRect.size.height);
        [UIView moveToView:self.view DestRect:vDestrect OriginRect:mOringRect duration:.2 IsRemove:NO Completion:Nil];
    }
}
//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.securityCodeField) {
        CGRect vOriginRect = self.view.frame;
        [UIView moveToView:self.view DestRect:mOringRect OriginRect:vOriginRect duration:.2 IsRemove:NO Completion:Nil];
    }
    
    if (textField == self.acountField) {
        if (textField.text.length > 0) {
            //检查账户名规范
            [self checkIfCharactorIsAllowed:textField.text];
        }
    }
}

#pragma mark 屏幕点击事件
-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.acountField.frame,vTouchPoint)
        &&!CGRectContainsPoint(self.phoneNumberField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.securityCodeField.frame, vTouchPoint)
        &&!CGRectContainsPoint(self.passWordField.frame, vTouchPoint)) {
        [self.acountField resignFirstResponder];
        [self.phoneNumberField resignFirstResponder];
        [self.passWordField resignFirstResponder];
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
        &&!CGRectContainsPoint(self.passWordField.frame, vTouchPoint)) {
        [self.acountField resignFirstResponder];
        [self.phoneNumberField resignFirstResponder];
        [self.passWordField resignFirstResponder];
        [self.securityCodeField resignFirstResponder];
    }
}

#pragma mark ChoseDistrctVCDelegate
-(void)didFinishChosedPlace:(NSDictionary *)sender{
    if (sender == Nil || sender.count == 0) {
        LOG(@"didFinishChosedPlace传入地区参数为空");
        return;
    }
    mPlaceDic = [[NSDictionary alloc] initWithDictionary:sender];
    NSString *vProinceStr = [[mPlaceDic objectForKey:@"province"] objectForKey:@"name"];
    IFISNIL(vProinceStr);
    NSString *vCityStr = [[mPlaceDic objectForKey:@"city"] objectForKey:@"name"];
    IFISNIL(vCityStr);
    NSString *vDistrictStr = [[mPlaceDic objectForKey:@"district"] objectForKey:@"name"];
    IFISNIL(vDistrictStr);
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *vCell = [self.registerTableView cellForRowAtIndexPath:vIndexPath];
    vCell.textLabel.text = [NSString stringWithFormat:@"所在地区: %@%@%@",vProinceStr,vCityStr,vDistrictStr];
    [ViewControllerManager backToViewController:@"RegisterVC" Animatation:vaDefaultAnimation SubType:0];
}

#pragma mark - 其他辅助功能
-(void)goToChosePlaceVC{
    [ViewControllerManager createViewController:@"ChoseProvinceVC"];
    NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"type",[NSNumber numberWithInt:0],@"id",nil];
    [NetManager postDataFromWebAsynchronous:APPURL103 Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
        //解析返回数据到数组
        NSDictionary *vDataDic = [[NetManager jsonToDic:responseObject] objectForKey:@"data"];
        NSMutableArray *vDataArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDataDic) {
            [vDataArray addObject:vDic];
        }
        if (vDataArray.count >0) {
            ChoseProvinceVC *vChosePlaceVC = (ChoseProvinceVC *)[ViewControllerManager getBaseViewController:@"ChoseProvinceVC"];
            vChosePlaceVC.placeArray = vDataArray;
            vChosePlaceVC.fromVCName = @"RegisterVC";
            vChosePlaceVC.isNeedChosedDistrict = YES;
            vChosePlaceVC.delegate = self;
            //显示地区
            [ViewControllerManager showBaseViewController:@"ChoseProvinceVC" AnimationType:vaDefaultAnimation SubType:0];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"获取省" Notice:@""];
}

#pragma mark 检查账户名是否符合规范
-(void)checkIfCharactorIsAllowed:(NSString *)aString{
    //检查首位是否为字母
    isAllowedCharactor = [StringHelper isLettersAtFirstCharactor:aString];
    if (!isAllowedCharactor) {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"注意" message:@"账号必须以字母开头，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
        [alert show];
        alert = Nil;
        SAFE_ARC_RELEASE(alert);
        return;
    }
    //检查是否包含不符合要求的字符
    isAllowedCharactor = [StringHelper isLettersAndNumbersAndUnderScore:aString];
    if (!isAllowedCharactor) {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"注意" message:@"账号必须是：字母、数字、下划线的组合，请重新输入！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
        [alert show];
        alert = Nil;
        SAFE_ARC_RELEASE(alert);
    }

}

#pragma mark 显示用户账户信息
-(void)showUserAcount:(NSString *)aAcount PassWord:(NSString *)aPassWord{
    NSString *vNoticeMeesage = [NSString stringWithFormat:@"注册成功“^o^”，你的账户是:%@，密码是：%@，请注意保管，登陆后请先完善您的个人资料，谢谢！",aAcount,aPassWord];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"注意" message:vNoticeMeesage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
    [alert show];
    alert = Nil;
    SAFE_ARC_RELEASE(alert);
}

#pragma mark - 其他业务点击事件
#pragma mark 取消注册
-(void)cancleButtonTouchDown:(id)sender{
    [ViewControllerManager backViewController:vaDefaultAnimation SubType:vsFromLeft];
}
#pragma mark 点击注册
-(void)finishButtonTouchDown:(id)sender{
    //开始注册
   /* if (mIsAgreeAgrement
        && self.acountField.text.length > 0
        && self.phoneNumberField.text.length > 0
        && self.passWordField.text.length > 0
        && self.securityCodeField.text.length > 0)*/
    
    if (self.acountField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的用户名！"];
        return;
    }
    
    if (self.phoneNumberField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的电话号码！"];
        return;
    }
    
    if (![CheckManeger checkIfIsAllowedPhoneNumber:self.phoneNumberField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号码！"];
        return;
    }
    
    if (self.passWordField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请设置您的账号密码！"];
        return;
    }
    
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *vCell = [self.registerTableView cellForRowAtIndexPath:vIndexPath];
    if ([vCell.textLabel.text isEqualToString:@"所在地区:"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择您所在的地区"];
        return;
    }
    if (self.securityCodeField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您收到的验证码！"];
        return;
    }
    
    if (!mIsAgreeAgrement) {
        [SVProgressHUD showErrorWithStatus:@"请同意注册协议，方可注册！"];
        return;
    }
    //检查是否符合账户名规范
    if (!isAllowedCharactor) {
        if (self.acountField.text > 0) {
            [self checkIfCharactorIsAllowed:self.acountField.text];
            return;
        }
    }
    //拼接请求参数
    NSDictionary *vDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.acountField.text,@"username",
                          self.phoneNumberField.text, @"phone",
                          self.passWordField.text,@"password",
                          self.securityCodeField.text,@"verifyCode",
                          [[mPlaceDic objectForKey:@"province"] objectForKey:@"id"],@"provinceId",
                          [[mPlaceDic objectForKey:@"city"] objectForKey:@"id"],@"cityId",
                          [[mPlaceDic objectForKey:@"district"] objectForKey:@"id"],@"districtId",
                          nil];
    //请求网络数据
    NSDictionary *vRegisterReturnDic = [UserManager registerUser:vDic];
    //传递网络数据更新界面
    if (vRegisterReturnDic != Nil) {
        //提示用户密码和账号
        [self showUserAcount:self.acountField.text PassWord:self.passWordField.text];
        //返回界面
        [ViewControllerManager backViewController:vaNoAnimation SubType:0];
        //更新数据和显示界面
        if ([_delegate respondsToSelector:@selector(didRegistAndLoginSuccess:)]) {
            [_delegate didRegistAndLoginSuccess:self.isSelectedView];
        }
    }else{
    }

}

#pragma mark SecrityButtonManegerDelegate
#pragma mark 获取验证码
-(NSString *)didSecrityButtonManegerButtonClicked:(id)sender{
    if (self.phoneNumberField.text.length > 0) {
        return self.phoneNumberField.text;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写手机号！"];
        return @"";
    }
    return @"";
}

#pragma mark 显示密码
-(void)showPassWordButtonClicked:(UIButton *)sender{
    if (self.passWordField.secureTextEntry) {
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_select"] forState:UIControlStateNormal];
        self.passWordField.secureTextEntry = NO;
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] forState:UIControlStateNormal];
        self.passWordField.secureTextEntry = YES;
    }
}

#pragma mark 同意协议check
- (IBAction)agreeAgrementClicked:(UIButton *)sender {
    if (!mIsAgreeAgrement) {
        mIsAgreeAgrement = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_select"] forState:UIControlStateNormal];
    }else{
        mIsAgreeAgrement = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_default"] forState:UIControlStateNormal];
    }
    
}

#pragma mark 点击协议
- (IBAction)agrementClicked:(id)sender {
    AgrementVC *vAgrementVC = [[AgrementVC alloc] init];
    vAgrementVC.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    UINavigationController *vNavi= [[UINavigationController alloc] initWithRootViewController:vAgrementVC];
    [vAgrementVC setAgrementType:atRegister];
    [self presentModalViewController:vNavi animated:YES];
    SAFE_ARC_RELEASE(vAgrementVC);
    SAFE_ARC_RELEASE(vNavi);
}
@end
