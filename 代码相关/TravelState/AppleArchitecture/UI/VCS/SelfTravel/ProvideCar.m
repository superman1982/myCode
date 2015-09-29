//
//  ProvideCar.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ProvideCar.h"
#import "SVProgressHUD.h"
#import "AgrementVC.h"
#import "CheckManeger.h"
#import "MyCarVC.h"
#import "UserManager.h"

@interface ProvideCar ()
{
    BOOL mIsAgreeAgrement;
}
@property (nonatomic,retain) UITextField *carNumberField;
@property (nonatomic,retain) UITextField *carTypeField;
@property (nonatomic,retain) UITextField *driverField;
@property (nonatomic,retain) UITextField *phoneNumberField;
@property (nonatomic,retain) UITextField *numberOfPeopleField;

@end

@implementation ProvideCar

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
              self = [super initWithNibName:@"ProvideCar_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ProvideCar" bundle:aBuddle];
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
    self.title = @"填写拼车信息";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"完成" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(carInfoFinishButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mIsAgreeAgrement = YES;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [self.carNumberField release];
    [self.carTypeField release];
    [self.driverField release];
    [self.phoneNumberField release];
    [self.numberOfPeopleField release];
    [_carInfoTableView release];
    [_footerView release];
    [_checkButton release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.carInfoTableView.clickeDelegate = self;
    [self setDefaultCarInfo];
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
    self.carNumberField = Nil;
    self.carTypeField = Nil;
    self.driverField = Nil;
    self.phoneNumberField = Nil;
   self.numberOfPeopleField = Nil;
    [super viewShouldUnLoad];
}
//----------

-(UITextField *)carNumberField{
    if (_carNumberField == Nil) {
        _carNumberField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _carNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _carNumberField.returnKeyType = UIReturnKeyDone;
        _carNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carNumberField.font = [UIFont systemFontOfSize:13];
        _carNumberField.delegate = self;
    }

    
    return _carNumberField;
}

-(UITextField *)carTypeField{
    if (_carTypeField == Nil) {
        _carTypeField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _carTypeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carTypeField.borderStyle = UITextBorderStyleRoundedRect;
        _carTypeField.returnKeyType = UIReturnKeyDone;
        _carTypeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carTypeField.font = [UIFont systemFontOfSize:13];
        _carTypeField.delegate = self;
    }

    
    return _carTypeField;
}

-(UITextField *)driverField{
    if (_driverField == Nil) {
        _driverField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _driverField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _driverField.borderStyle = UITextBorderStyleRoundedRect;
        _driverField.returnKeyType = UIReturnKeyDone;
        _driverField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _driverField.font = [UIFont systemFontOfSize:13];
        _driverField.delegate = self;
    }
    
    return _driverField;
}

-(UITextField *)phoneNumberField{
    if (_phoneNumberField == Nil) {
        _phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _phoneNumberField.returnKeyType = UIReturnKeyDone;
        _phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumberField.font = [UIFont systemFontOfSize:13];
        _phoneNumberField.delegate = self;
    }

    
    return _phoneNumberField;
}

-(UITextField *)numberOfPeopleField{
    if (_numberOfPeopleField == Nil) {
        _numberOfPeopleField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _numberOfPeopleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberOfPeopleField.borderStyle = UITextBorderStyleRoundedRect;
        _numberOfPeopleField.returnKeyType = UIReturnKeyDone;
        _numberOfPeopleField.keyboardType = UIKeyboardTypeNumberPad;
        _numberOfPeopleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _numberOfPeopleField.font = [UIFont systemFontOfSize:13];
        _numberOfPeopleField.delegate = self;
    }
    
    return _numberOfPeopleField;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        return self.footerView.frame.size.height;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
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
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //文字描述
            vCell.textLabel.text = @"车       牌:";
            [vCell.contentView addSubview:self.carNumberField];
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            //文字描述
            vCell.textLabel.text = @"品       牌:";
            [vCell.contentView addSubview:self.carTypeField];
        }else if (indexPath.row == 2){
            //文字描述
            vCell.textLabel.text = @"司       机:";
            [vCell.contentView addSubview:self.driverField];
        }else if (indexPath.row == 3){
            //文字描述
            vCell.textLabel.text = @"电       话:";
            [vCell.contentView addSubview:self.phoneNumberField];
        }else if (indexPath.row == 4){
            //文字描述
            vCell.textLabel.text = @"可拼人数:";
            [vCell.contentView addSubview:self.numberOfPeopleField];
        }else if (indexPath.row == 5){
            [vCell.contentView addSubview:self.footerView];
            vCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [ViewControllerManager createViewController:@"AllMyCarVC"];
        AllMyCarVC *vVC = (AllMyCarVC *)[ViewControllerManager getBaseViewController:@"AllMyCarVC"];
        vVC.delegate = self;
        [ViewControllerManager showBaseViewController:@"AllMyCarVC" AnimationType:vaDefaultAnimation SubType:0];
    }
}

#define CARENGINFILDHIGHT 70
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //转换View位置坐标，因为IOS7取消View自动伸缩时，View位置坐标与IOS5不相同
    CGRect frame = [textField convertRect:textField.frame toView:self.view.window];
    //计算TextField多出键盘的高度，以中文键盘为标准
    int offset = frame.origin.y + 32 - (mHeight + 20 - 216.0-36);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    isNeedToMoveFrame = NO;
    if(offset > 0){
        //移动后的View位置
        CGRect vViewFrame = self.view.frame;
        CGRect rect = CGRectMake(0.0f,vViewFrame.origin.y -offset ,vViewFrame.size.width,vViewFrame.size.height);
        if (!isShowChanese){
            //不是中文键盘时，向下多移动36个像素，
            rect.origin.y = rect.origin.y + 36;
            //设置isNeedToMoveFrame = YES，英文变中文键盘时移动;
            //根据本页面作特殊调整
            if (textField == self.phoneNumberField ) {
                rect.origin.y = rect.origin.y - 22;
            }
            isNeedToMoveFrame = YES;
        }
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}
#pragma mark 车辆选择完毕
-(void)didAllMyCarVCSeleted:(NSDictionary *)sender{
    [self setUI:sender];
}

#pragma mark - 其他辅助gongn
#pragma mark 设置默认车辆信息
-(void)setDefaultCarInfo{
    MyCarVC *vMyCarVC = [[MyCarVC alloc] init];
    [vMyCarVC initWebDataComplete:^(id responseObject) {
        
        NSDictionary *vDefaultDic = Nil;
        for (NSDictionary *vDic in vMyCarVC.myCarArray) {
            if ([[vDic objectForKey:@"isDefault"] intValue] == 1) {
                vDefaultDic = vDic;
            }
        }
        
        if (vDefaultDic != nil) {
            [self setUI:vDefaultDic];
        }
    }];
    vMyCarVC = nil;
}

#pragma mark 设置UI
-(void)setUI:(NSDictionary *)aDic{
     MyCarVC *vMyCarVC = [[MyCarVC alloc] init];
    id vCarId = [aDic objectForKey:@"carId"];
    [vMyCarVC getCarDetail:vCarId Complete:^(NSDictionary  *responseObject) {
        self.carNumberField.text = [responseObject objectForKey:@"carNumber"];
        NSString *vCarTypeStr = [responseObject objectForKey:@"carModel"];
        vCarTypeStr = vCarTypeStr.length > 0 ? vCarTypeStr:@"";
        self.carTypeField.text = vCarTypeStr;
        self.driverField.text = [UserManager instanceUserManager].userInfo.realName;
        self.phoneNumberField.text = [UserManager instanceUserManager].userInfo.phone;
        NSNumber *vSeatNumber = [responseObject objectForKey:@"seatNumber"];
        if ([vSeatNumber intValue] > 0) {
            self.numberOfPeopleField.text = [NSString stringWithFormat:@"%@",vSeatNumber];
        }else{
            self.numberOfPeopleField.text = @"";
        }
    }];
    vMyCarVC = nil;
}

#pragma mark 其他业务点击事件
-(void)carInfoFinishButtonTouchDown:(id)sender{
    if (mIsAgreeAgrement) {
        if (self.carNumberField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写车牌号码！"];
            return;
        }
        
        if (![CheckManeger checkIfIsAllowedCarLisence:self.carNumberField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的车牌号！"];
            return;
        }
        
        if (self.carTypeField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写车辆品牌！"];
            return;
        }
        
        if (self.driverField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写司机姓名！"];
            return;
        }
        if (self.phoneNumberField.text == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写手机号码！"];
            return;
        }
        
        if (![CheckManeger checkIfIsAllowedPhoneNumber:self.phoneNumberField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请填入正确的手机号码"];
            return;
        }
        if (self.numberOfPeopleField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写车辆可拼人数！"];
            return;
        }
        
        if ([_delegate respondsToSelector:@selector(didProvideCarFinished:)]) {
                NSDictionary *vDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                              self.carNumberField.text,@"carBrand",
                                              self.carTypeField.text,@"carModel",
                                              self.driverField.text,@"driver",
                                              self.phoneNumberField.text,@"phone",
                                       [NSNumber numberWithInt:[self.numberOfPeopleField.text intValue] ],@"seatQuantity",
                                             nil];
        [_delegate didProvideCarFinished:vDic];
        [self back];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请同意拼车协议，方可拼车!"];
    }
}

- (IBAction)agreeCheckButtonClicked:(UIButton *)sender {
    if (!mIsAgreeAgrement) {
        mIsAgreeAgrement = YES;
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_select"] forState:UIControlStateNormal];
    }else{
        mIsAgreeAgrement = NO;
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_default"] forState:UIControlStateNormal];
    }
}

- (IBAction)agrementButtonClicked:(id)sender {
    AgrementVC *vAgrementVC = [[AgrementVC alloc] init];
    vAgrementVC.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    UINavigationController *vNavi= [[UINavigationController alloc] initWithRootViewController:vAgrementVC];
    [vAgrementVC setAgrementType:atMakeCar];
    [self presentModalViewController:vNavi animated:YES];
    SAFE_ARC_RELEASE(vAgrementVC);
    SAFE_ARC_RELEASE(vNavi);
}

- (void)viewDidUnload {
[self setCarInfoTableView:nil];
    [self setFooterView:nil];
    [self setCheckButton:nil];
[super viewDidUnload];
}
@end
