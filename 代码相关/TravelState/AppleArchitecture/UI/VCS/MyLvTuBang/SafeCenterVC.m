//
//  SafeCenterVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-17.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "SafeCenterVC.h"
#import "UserManager.h"

@interface SafeCenterVC ()
{
    BOOL isNoticeWithMessage;
}
@end

@implementation SafeCenterVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"SafeCenterVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"SafeCenterVC" bundle:aBuddle];
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
    self.title = @"账号密码管理";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    isNoticeWithMessage = YES;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_safeCenterTableView release];
    [_safeFooterView release];
    [_checkButton release];
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
    [super viewShouldUnLoad];
}

//----------
- (void)viewDidUnload {
    [self setSafeCenterTableView:nil];
    [self setSafeFooterView:nil];
    [self setCheckButton:nil];
    [super viewDidUnload];
}


#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    [vFootView setBackgroundColor:[UIColor whiteColor]];
    return vFootView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:14];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 150, 21)];
        vLable.font = [UIFont systemFontOfSize:14];
        vLable.textAlignment = NSTextAlignmentRight;
        vLable.textColor = [UIColor blueColor];
        vLable.tag = 100;
        //如果是添加车辆隐藏右边文字
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            vCell.textLabel.text = @"手机号:";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.text = @"修改";
        }
        else if (indexPath.row == 1) {
            vCell.textLabel.text = @"登录密码:";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
            vLable.text = @"修改";

        }else if (indexPath.row == 2){
            vCell.textLabel.text = @"支付密码:";
            
            id isSetPayPassWord = [UserManager instanceUserManager].userInfo.isSetPayPassword;
            if ([isSetPayPassWord intValue] == 0) {
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
                vLable.text = @"添加";
            }else{
                UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:100];
                vLable.text = @"修改";
            }
        }else if (indexPath.row == 3){
            vCell.selectionStyle = UITableViewCellSelectionStyleNone;
            vCell.accessoryType = UITableViewCellAccessoryNone;
            [vCell.contentView addSubview:self.safeFooterView];
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self changePhoneNumber];
    }else if (indexPath.row == 1){
        [self changePassWord];
    }else if (indexPath.row == 2){
        [self changePayPassword];
    }
}
#pragma mark - 其他辅助功能
-(BOOL)checkIfHasPayPassword{
    id vPayPassword = [UserManager instanceUserManager].userInfo.isSetPayPassword;
    if ([vPayPassword intValue] == 1) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -  其他业务点击事件
-(void)changePhoneNumber{
    [ViewControllerManager createViewController:@"ChangePhoneNumberVC"];
    [ViewControllerManager showBaseViewController:@"ChangePhoneNumberVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 修改登录密码
-(void)changePassWord{
    [ViewControllerManager createViewController:@"ChanePassWordVC"];
    [ViewControllerManager showBaseViewController:@"ChanePassWordVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 修改支付密码
-(void)changePayPassword{
    if (![self checkIfHasPayPassword]) {
        [ViewControllerManager createViewController:@"AddPayPasswordVC"];
        [ViewControllerManager showBaseViewController:@"AddPayPasswordVC" AnimationType:vaDefaultAnimation SubType:0];
    }else{
        [ViewControllerManager createViewController:@"ChangePayPasswordVC"];
        [ViewControllerManager showBaseViewController:@"ChangePayPasswordVC" AnimationType:vaDefaultAnimation SubType:0];
    }

}
- (IBAction)noticeWithMessageButtonClicked:(UIButton *)sender {
    if (!isNoticeWithMessage) {
        isNoticeWithMessage = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_select.png"] forState:UIControlStateNormal];
    }else{
        isNoticeWithMessage = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_default.png"] forState:UIControlStateNormal];
    }
}
@end
