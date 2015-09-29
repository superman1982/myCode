//
//  FillPeopleInfoVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "FillPeopleInfoVC.h"
#import "SVProgressHUD.h"
#import "NetManager.h"
#import "ActivityRouteManeger.h"
#import "UserManager.h"
#import "CheckManeger.h"

@interface FillPeopleInfoVC ()
{
    NSMutableArray *mInfoArray;  //保存报名人员信息
    NSInteger mPeopleCount;   //剩余报名人数
    id mUserID;  //用户ID
    BOOL isSaveAndContinueClicked;  //是否点击了保存继续
}
@property (nonatomic,retain) UITextField *phoneNumberField;
@property (nonatomic,retain) UITextField *nameFiled;
@property (nonatomic,retain) UITextField *sexField;
@property (nonatomic,retain) UITextField *IDCardField;
@property (nonatomic,retain) UITextField *qqField;
@property (nonatomic,retain) UITextField *emailField;
@end

@implementation FillPeopleInfoVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"FillPeopleInfoVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"FillPeopleInfoVC" bundle:aBuddle];
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
    self.title = @"填写活动人员信息";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"完成" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(peopleInfoFinishButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mInfoArray = [[NSMutableArray alloc] init];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [self.phoneNumberField release];
    [self.sexField release];
    [self.IDCardField release];
    [self.qqField release];
    [self.emailField release];
    [mInfoArray removeAllObjects],mInfoArray = Nil;
    [_headerView release];
    [_footerView release];
    [_fillInfoTableView release];
    [_peopleCountLable release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.fillInfoTableView.clickeDelegate = self;
    self.fillInfoTableView.scrollEnabled = NO;
    //初始化单次可报名最大人数
    NSString *vKey = [NSString stringWithFormat:@"%@",self.activeInfo.ActivityId];
    NSDictionary *vSingupDic = [[ActivityRouteManeger shareActivityManeger].bookPeopleDic objectForKey:vKey];
    mPeopleCount = [[vSingupDic objectForKey:BOOKEDPEOPLEKEY] intValue];
    self.peopleCountLable.text = [NSString stringWithFormat:@"一次活动报名，最多可以添加%d个参与人员",mPeopleCount];
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
    self.phoneNumberField = Nil;
    self.sexField = Nil;
    self.IDCardField = Nil;
    self.qqField = Nil;
    self.emailField = Nil;
    [super viewShouldUnLoad];
}
//----------

-(void)back{
    if (mInfoArray.count > 0) {
        [_delegate didFinishPeopleInfo:mInfoArray];
        [mInfoArray removeAllObjects];
        //跟新报名最大人数
        NSDictionary *vSignupDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mPeopleCount],BOOKEDPEOPLEKEY, nil];
        NSString *vKey = [NSString stringWithFormat:@"%@",self.activeInfo.ActivityId];
        [[ActivityRouteManeger shareActivityManeger].bookPeopleDic setObject:vSignupDic forKey:vKey];
    }
    [super back];
}
-(UITextField *)phoneNumberField{
    if (_phoneNumberField == Nil) {
        _phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _phoneNumberField.returnKeyType = UIReturnKeyDone;
        _phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumberField.font = [UIFont systemFontOfSize:13];
        _phoneNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumberField.delegate = self;
        _phoneNumberField.placeholder = @"可选填";
    }
    return _phoneNumberField;
}

-(UITextField *)nameFiled{
    if (_nameFiled == Nil) {
        _nameFiled = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _nameFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameFiled.borderStyle = UITextBorderStyleRoundedRect;
        _nameFiled.returnKeyType = UIReturnKeyDone;
        _nameFiled.font = [UIFont systemFontOfSize:13];
        _nameFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameFiled.delegate = self;
    }

    
    return _nameFiled;
}

-(UITextField *)sexField{
    if (_sexField == Nil) {
        _sexField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _sexField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _sexField.borderStyle = UITextBorderStyleRoundedRect;
        _sexField.returnKeyType = UIReturnKeyDone;
        _sexField.font = [UIFont systemFontOfSize:13];
        _sexField.delegate = self;
        _sexField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _sexField.userInteractionEnabled= NO;
    }

    return _sexField;
}

-(UITextField *)IDCardField{
    if (_IDCardField == Nil) {
        _IDCardField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _IDCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _IDCardField.borderStyle = UITextBorderStyleRoundedRect;
        _IDCardField.returnKeyType = UIReturnKeyDone;
        _IDCardField.font = [UIFont systemFontOfSize:13];
        _IDCardField.keyboardType = UIKeyboardTypePhonePad;
        _IDCardField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _IDCardField.delegate = self;
        
    }

    return _IDCardField;
}

-(UITextField *)qqField{
    if (_qqField == Nil) {
        _qqField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _qqField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _qqField.borderStyle = UITextBorderStyleRoundedRect;
        _qqField.returnKeyType = UIReturnKeyDone;
        _qqField.font = [UIFont systemFontOfSize:13];
        _qqField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _qqField.delegate = self;
        _qqField.placeholder = @"可选填";
    }

    return _qqField;
}

-(UITextField *)emailField{
    if (_emailField == Nil) {
        _emailField = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 150, 30)];
        _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailField.borderStyle = UITextBorderStyleRoundedRect;
        _emailField.returnKeyType = UIReturnKeyDone;
        _emailField.font = [UIFont systemFontOfSize:13];
        _emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _emailField.delegate = self;
        _emailField.placeholder = @"可选填";
    }
    

    return _emailField;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 15;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma mark table背景颜色
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.headerView.frame.size.height;
        }
    }
    
    if (indexPath.section == 1) {
            return self.footerView.frame.size.height;
    
    }
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
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
        vCell.textLabel.font = [UIFont systemFontOfSize:14];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [vCell.contentView addSubview:self.headerView];
        }
        if (indexPath.row == 1) {
            //文字描述
            vCell.textLabel.text = @"手机号码:";
            //手机号输入框
            [vCell.contentView addSubview:self.phoneNumberField];
            
            UIButton *vAcountInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [vAcountInfoButton setFrame:CGRectMake(320-80, 0, 80, 44)];
            [vAcountInfoButton setBackgroundImage:[UIImage imageNamed:@"eventPerson_autoFill_btn_default"] forState:UIControlStateNormal];
            [vAcountInfoButton setBackgroundImage:[UIImage imageNamed:@"eventPerson_autoFill_btn_select"] forState:UIControlStateNormal];
            [vAcountInfoButton addTarget:self action:@selector(automaticFillButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [vCell.contentView addSubview:vAcountInfoButton];
        }else if (indexPath.row == 2){
            //文字描述
            vCell.textLabel.text = @"姓　　名:";
            //姓名输入框
            [vCell.contentView addSubview:self.nameFiled];
        }else if (indexPath.row == 3){
            //文字描述
            vCell.textLabel.text = @"性　　别:";
            //性别输入框
            [vCell.contentView addSubview:self.sexField];
        }else if (indexPath.row == 4){
            //文字描述
            vCell.textLabel.text = @"身份证号:";
            //身份证输入框
            [vCell.contentView addSubview:self.IDCardField];
        }else if (indexPath.row == 5){
            //文字描述
            vCell.textLabel.text = @"Q　　Q:";
            //QQ输入框
            [vCell.contentView addSubview:self.qqField];
        }else if (indexPath.row == 6){
            //文字描述
            vCell.textLabel.text = @"邮　　箱:";
            //邮箱输入框
            [vCell.contentView addSubview:self.emailField];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [vCell.contentView addSubview:self.footerView];
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [self choseSexClicked];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            [self saveAndContinueClicked];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (mPeopleCount == 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat: @"该活动单次最多能添加%@人",self.activeInfo.totalSignup ]];
        [textField resignFirstResponder];
        return;
    }
    [super textFieldDidBeginEditing:textField];
    isSaveAndContinueClicked = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //检查是否添加过该人员
    BOOL isAdded = [self checkIfAddedInfo:self.phoneNumberField.text];
    //如果已经添加提示已经添加
    if (isAdded) {
        [SVProgressHUD showErrorWithStatus:@"已经添加过该人员信息!"];
        self.phoneNumberField.text = @"";
        return;
    }
    [super textFieldDidEndEditing:textField];
}
#pragma mark - 其他业务点击事件
-(void)saveInfo{
    if (mPeopleCount <= 0) {
        LOG(@"人数超过限制,不保存信息");
        return;
    }
    IFISNIL(mUserID);
    id vQQStr = self.qqField.text;
    IFISNIL(vQQStr);
    id vEmailStr = self.emailField.text;
    IFISNIL(vEmailStr);
    
    NSDictionary *vPeopleInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    mUserID,@"userId",
                                    self.phoneNumberField.text,@"phone",
                                   self.nameFiled.text,@"name",
                                    self.sexField.text,@"sex",
                                    self.IDCardField.text,@"idNumber",
                                    vQQStr,@"QQ",
                                    vEmailStr,@"email",
                                    nil];
    [mInfoArray addObject:vPeopleInfoDic];
    
    mPeopleCount--;
    NSLog(@"还可继续报名人数：%d",mPeopleCount);
    self.peopleCountLable.text = [NSString stringWithFormat:@"本次活动报名，还可以添加%d个参与人员",mPeopleCount];
    //跟新报名最大人数
    NSDictionary *vSignupDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mPeopleCount],BOOKEDPEOPLEKEY, nil];
    NSString *vKey = [NSString stringWithFormat:@"%@",self.activeInfo.ActivityId];
    [[ActivityRouteManeger shareActivityManeger].bookPeopleDic setObject:vSignupDic forKey:vKey];
    
    
}

-(void)clearInfo{
    self.phoneNumberField.text =@"";
    self.nameFiled.text = @"";
    self.sexField.text = @"";
    self.IDCardField.text = @"";
    self.qqField.text = @"";
    self.emailField.text = @"";
}

-(BOOL)checkIfAddedInfo:(NSString *)aPhoneNumber{
    if (mInfoArray.count >= 1) {
        for (NSDictionary *vDic in mInfoArray) {
            NSString *vPhoneStr = [vDic objectForKey:@"phone"];
            if ([aPhoneNumber isEqualToString:vPhoneStr]) {
                return YES;
            }
        }
    }
    //报名已经包括自己，但有填写自己的电话时，为重复报名
    if ([aPhoneNumber isEqualToString:[UserManager instanceUserManager].userInfo.phone]) {
        return YES;
    }
    return NO;
}

#pragma mark 提示用户填写信息
-(BOOL)noticeUser{
    
    //如果没有添加，添加保存人员信息
//    if (self.phoneNumberField.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"请填写您的手机号！"];
//        return NO;
//    }
//    
//    if (![CheckManeger checkIfIsAllowedPhoneNumber:self.phoneNumberField.text]) {
//        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号！"];
//        return NO;
//    }
    if (self.nameFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的姓名！"];
        return NO;
    }
    
    if (self.sexField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择您的性别！"];
        return NO;
    }
    if (self.IDCardField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的身份证号码！"];
        return NO;
    }
    
    return YES;
}

#pragma mark - 其他业务点击事件
-(void) peopleInfoFinishButtonTouchDown:(id)sender{
    if ([_delegate respondsToSelector:@selector(didFinishPeopleInfo:)]) {
        //没有点击“保存继续”按钮
        if (!isSaveAndContinueClicked) {
            //检查用户填写信息
            if (![self noticeUser]) {
                return;
            }
            [self saveInfo];
        }
        [self back];
        
    }
}

#pragma mark 自动完善信息
-(void)automaticFillButtonClicked:(id)sender{
    if (self.phoneNumberField.text.length > 0) {
        NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNumberField.text,@"phone", nil];
        [NetManager postDataFromWebAsynchronous:APPURL409 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
            NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
            NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
            if (vDataDic.count > 0) {
                mUserID = [[NSString alloc] initWithString:[vDataDic objectForKey:@"userId"]];
                self.phoneNumberField.text = [vDataDic objectForKey:@"phone"];
                self.nameFiled.text = [vDataDic objectForKey:@"name"];
                self.sexField.text = [vDataDic objectForKey:@"sex"];
                self.IDCardField.text = [vDataDic objectForKey:@"idNumber"];
                self.qqField.text = [vDataDic objectForKey:@"QQ"];
                self.emailField.text = [vDataDic objectForKey:@"email"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"该用户不存在！"];
            }
        } Failure:^(NSURLResponse *response, NSError *error) {
        } RequestName:@"获取旅途邦会员信息" Notice:@""];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请填写手机号码！"];
    }
    
}

#pragma mark 保存并继续
- (IBAction)saveAndContinueClicked:(id)sender {
    if (mPeopleCount <= 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat: @"该活动单次最多能添加%@人",self.activeInfo.totalSignup ]];
        return;
    }
    //检查用户填写信息
    if (![self noticeUser]) {
        return;
    }
    isSaveAndContinueClicked = YES;
    //没有添加则添加该人员信息
    [self saveInfo];
    //清除UI上的信息
    [self clearInfo];
    

}

#pragma mark 选择性别
//选择性别
-(void)choseSexClicked{
    if (self.peopleChoseSexView == Nil) {
        self.peopleChoseSexView = [[ChosePickerVC alloc] init];
        self.peopleChoseSexView.delegate = self;
    }
    if (self.peopleChoseSexView.view.superview == nil) {
        [self.view addSubview:self.peopleChoseSexView.view];
    }
}
#pragma mark  性别数据源
-(NSArray *)pickerDataSource:(id)sender{
    NSArray *vSexArray = [NSArray arrayWithObjects:@"男",@"女",nil];
    return vSexArray;
}
#pragma mark 性别确定
-(void)didConfirmPicker:(id)sender{
 self.sexField.text = sender;
}

- (void)viewDidUnload {
[self setHeaderView:nil];
[self setFooterView:nil];
    [self setFillInfoTableView:nil];
    [self setPeopleCountLable:nil];
[super viewDidUnload];
}

@end
