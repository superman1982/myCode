//
//  AddPayPasswordVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-17.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AddPayPasswordVC.h"
#import "ButtonHelper.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "NetManager.h"
#import "ActivityRouteManeger.h"

@interface AddPayPasswordVC ()
{
    BOOL isShowChanese;
    BOOL isNeedToMoveFrame;
    SecrityButtonManeger *mSecButtonManeger;
    UIButton *mCodeButton;
}
@property (nonatomic,retain) UITextField *idCardTextField;
@property (nonatomic,retain) UITextField *passWordField;
@property (nonatomic,retain) UITextField *payPassWordField;
@property (nonatomic,retain) UITextField *securityCodeField;

@end

@implementation AddPayPasswordVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"AddPayPasswordVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"AddPayPasswordVC" bundle:aBuddle];
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
    self.title = @"添加支付密码";
    
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(confirmPayPassWordButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}


-(void)viewWillAppear:(BOOL)animated{
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_addPayPasswordTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.addPayPasswordTableView.clickeDelegate = self;
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
    [self setAddPayPasswordTableView:nil];
    [super viewDidUnload];
}

-(UITextField *)idCardTextField{
    if (_idCardTextField == Nil) {
        _idCardTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, 160, 30)];
        _idCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _idCardTextField.borderStyle = UITextBorderStyleRoundedRect;
        _idCardTextField.returnKeyType = UIReturnKeyDone;
        _idCardTextField.font = [UIFont systemFontOfSize:13];
        _idCardTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _idCardTextField.delegate = self;
    }

    return _idCardTextField;
}

-(UITextField *)passWordField{
    if (_passWordField == Nil) {
        _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, 160, 30)];
        _passWordField.secureTextEntry = YES;
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordField.borderStyle = UITextBorderStyleRoundedRect;
        _passWordField.returnKeyType = UIReturnKeyDone;
        _passWordField.font = [UIFont systemFontOfSize:13];
        _passWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passWordField.delegate = self;
    }

    return _passWordField;
}

-(UITextField *)payPassWordField{
    if (_payPassWordField == Nil) {
        _payPassWordField = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, 130, 30)];
        _payPassWordField.secureTextEntry = YES;
        _payPassWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _payPassWordField.borderStyle = UITextBorderStyleRoundedRect;
        _payPassWordField.returnKeyType = UIReturnKeyDone;
        _payPassWordField.font = [UIFont systemFontOfSize:13];
        _payPassWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _payPassWordField.delegate = self;
    }
    
    return _payPassWordField;
}

-(UITextField *)securityCodeField{
    if (_securityCodeField == Nil) {
        _securityCodeField = [[UITextField alloc] initWithFrame:CGRectMake(106, 7, 130, 30)];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 33;
    }else if (section == 1) {
        return 10;
    }else if (section == 2){
        return 33;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"身份证号用于找回您的支付密码,请如实填写";
    }
    if (section==2) {
        return @"为了您密码安全，请输入登录密码";
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
    
    if (section == 0) {
        vTitleLable.text = @"身份证号用于找回您的支付密码,请如实填写";
        [headerView addSubview:vTitleLable];
    }else if (section == 2){
        vTitleLable.text = @"为了您密码安全，请输入登录密码";
        [headerView addSubview:vTitleLable];
    }
    SAFE_ARC_AUTORELEASE(vTitleLable);
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryNone;
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;

        //设置图片
        UIImageView *vCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 14, 60, 60)];
        vCellImageView.tag = 101;
        vCellImageView.hidden = YES;
        [vCellImageView setBackgroundColor:[UIColor redColor]];
        [vCell.contentView addSubview:vCellImageView];
        SAFE_ARC_RELEASE(vCellImageView);
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            vCell.textLabel.text = @"身份证号:";
            
            [vCell.contentView addSubview:self.idCardTextField];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            vCell.textLabel.text = @"登录密码:";
            
            [vCell.contentView addSubview:self.passWordField];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"设置支付密码:";
            
            [vCell.contentView addSubview:self.payPassWordField];
            
            UIButton *vShowPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vShowPassWordButton createButtonWithFrame:CGRectMake(320-70, 13, 59, 22) Title:@"" NormalImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] HelightImage:Nil Target:self SELTOR:@selector(showPayPassWordButtonClicked:)];
            [vCell.contentView addSubview:vShowPassWordButton];
        }else if (indexPath.row == 1){
            vCell.textLabel.text = @"手机验证码:";
            [vCell.contentView addSubview:self.securityCodeField];
            
            [vCell.contentView addSubview:mCodeButton];
        }
    }
    return vCell;
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置_talkBarView的frame跟随键盘的frame , 对中文键盘处理
    static CGFloat normalKeyboardHeight = 216.0f;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    //如果显示了中文，则变为英文输入时，重新移动
    if (isShowChanese) {
        isShowChanese = NO;
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 36, self.view.frame.size.width, self.view.frame.size.height);
        }];
        return;
    }
    
    if (isNeedToMoveFrame && distanceToMove > 0 ) {
        isShowChanese = YES;
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - distanceToMove, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    if (IS_IOS7) {
        rect = CGRectMake(0.0f, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}



#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#define CARENGINFILDHIGHT 70
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
            if (IS_IPHONE_5) {
                if (textField == self.securityCodeField) {
                    rect.origin.y = rect.origin.y - 33;
                }
            }else{
                if (textField == self.passWordField ) {
                    rect.origin.y = rect.origin.y - 12;
                }
            }
            isNeedToMoveFrame = YES;
        }
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

#pragma mark 屏幕点击事件
-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.idCardTextField.frame,vTouchPoint)
        && !CGRectContainsPoint(self.payPassWordField.frame,vTouchPoint)
        && !CGRectContainsPoint(self.passWordField.frame,vTouchPoint)) {
        [self.idCardTextField resignFirstResponder];
        [self.payPassWordField resignFirstResponder];
        [self.passWordField resignFirstResponder];
    }
}

#pragma mark - 其他业务点击事件
-(void)confirmPayPassWordButtonTouchDown:(id)sender{
    NSMutableDictionary *vParemeter = [NSMutableDictionary dictionary];
    
    id vUserId = [UserManager instanceUserManager].userID;
    IFISNIL(vUserId);
    [vParemeter setObject:vUserId forKey:@"userId"];
    
    NSString *vIdNumberStr = self.idCardTextField.text;
    if (vIdNumberStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号！"];
        return;
    }
    [vParemeter setObject:vIdNumberStr forKey:@"idNumber"];
    
    NSString *vPassWordStr = self.passWordField.text;
    if (vPassWordStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码！"];
        return;
    }
    [vParemeter setObject:vPassWordStr forKey:@"password"];
    
    NSString *vPayPasWord = self.payPassWordField.text;
    if (vPayPasWord.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请设置支付密码！"];
        return;
    }
    [vParemeter setObject:vPayPasWord forKey:@"newPayPassword"];
    
    NSString *verifyCode = self.securityCodeField.text;
    if (verifyCode.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写手机验证码！"];
        return;
    }
    [vParemeter setObject:verifyCode forKey:@"verifyCode"];
    
    
    [NetManager postDataFromWebAsynchronous:APPURL827 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        NSString *vReturnMessage = [vReturnDic objectForKey:@"stateMessage"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"设置成功！"];
                //更新设支付密码状态
                [UserManager instanceUserManager].userInfo.isSetPayPassword = [NSNumber numberWithInt:1];
                [self back];
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:vReturnMessage];
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"添加支付密码！" Notice:@""];
}

#pragma mark 获取验证码
-(NSString *)didSecrityButtonManegerButtonClicked:(id)sender{
    NSString *vUserPhone = [UserManager instanceUserManager].userInfo.phone;
    IFISNIL(vUserPhone);
    return vUserPhone;
}

#pragma mark 显示密码
-(void)showPayPassWordButtonClicked:(UIButton *)sender{
    if (self.payPassWordField.secureTextEntry) {
        self.payPassWordField.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_select"] forState:UIControlStateNormal];
    }else{
        self.payPassWordField.secureTextEntry = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_showPwd_btn_default.png"] forState:UIControlStateNormal];
    }
}
@end
