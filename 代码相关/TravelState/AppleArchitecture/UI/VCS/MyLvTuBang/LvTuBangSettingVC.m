//
//  LvTuBangSettingVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "LvTuBangSettingVC.h"
#import "ActivityRouteManeger.h"

@interface LvTuBangSettingVC ()

@end

@implementation LvTuBangSettingVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"LvTuBangSettingVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"LvTuBangSettingVC" bundle:aBuddle];
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
    self.title = @"设置";
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
    [super viewShouldUnLoad];
}
//----------

-(void)back{
    [ViewControllerManager backViewController:vaMoveIn SubType:vsFromBottom];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
        return 3;
    }else if(section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //设置介绍
        UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 11, 200, 21)];
        [vLable setBackgroundColor:[UIColor clearColor]];
        vLable.font = [UIFont systemFontOfSize:15];
        vLable.textColor = [UIColor darkGrayColor];
        vLable.textAlignment = NSTextAlignmentRight;
        vLable.tag = 101;
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"关于旅途邦";
            vCell.imageView.image = [UIImage imageNamed:@"setting_about_btn"];
        }else if (indexPath.row == 1) {
            //文字描述
            vCell.textLabel.text = @"分享旅途邦";
            vCell.imageView.image = [UIImage imageNamed:@"setting_share_btn"];
        }else if (indexPath.row == 2){
            NSString *vCurrentViersion = [TerminalData getApplicationVersion];
            //文字描述
            vCell.textLabel.text = [NSString stringWithFormat:@"当前版本%@",vCurrentViersion];
            vCell.imageView.image = [UIImage imageNamed:@"setting_version_btn"];
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.text = @"检测新版本";
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //文字描述
            vCell.textLabel.text = @"意见反馈";
            vCell.imageView.image = [UIImage imageNamed:@"setting_feedback_btn"];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //文字描述
            vCell.textLabel.text = @"客服电话";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.text = CUSTOMRSERVICEPHONENUMBER;
            vCell.imageView.image = [UIImage imageNamed:@"setting_phone_btn"];
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [ViewControllerManager createViewController:@"AboutLvTuBangVC"];
            [ViewControllerManager showBaseViewController:@"AboutLvTuBangVC" AnimationType:vaDefaultAnimation SubType:0];
        }else if (indexPath.row == 1){
            [ActivityRouteManeger showShare:@"" Content:@"请下载旅途邦，谢谢！"  Paremeter:Nil ShareType:stLvTuBang];
        }else if (indexPath.row == 2){
            [[TerminalData instanceTerminalData] checkVersion:NO];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [ViewControllerManager createViewController:@"AdviceVC"];
            [ViewControllerManager showBaseViewController:@"AdviceVC" AnimationType:vaDefaultAnimation SubType:0];
        }
    }else if (indexPath.section == 2){
        [TerminalData phoneCall:self.view PhoneNumber:CUSTOMRSERVICEPHONENUMBER];
    }
}

@end
