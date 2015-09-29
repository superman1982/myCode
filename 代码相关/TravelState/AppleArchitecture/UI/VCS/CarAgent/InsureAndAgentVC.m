//
//  InsureAndAgentVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "InsureAndAgentVC.h"
#import "NetManager.h"
#import "UserManager.h"
#import "AnimationTransition.h"

@interface InsureAndAgentVC ()

@end

@implementation InsureAndAgentVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"InsureAndAgentVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"InsureAndAgentVC" bundle:aBuddle];
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
    self.title = @"保险车务";
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
    [_IneedInsuranceNoticeView release];
    [_noticeContentView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.noticeContentView.layer.cornerRadius = 10;
    self.noticeContentView.clipsToBounds = YES;
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


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"办理车务";
        }else if (indexPath.row == 1){
            vCell.textLabel.text = @"办理投保";
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"我的保险";
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            [self dealCarAgent];
        }else if (indexPath.row == 1){
            [self dealInsurance];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self myInsurance];
        }
    }
}

#pragma mark - 其他业务点击事件
#pragma mark 车务
-(void)dealCarAgent{
    [ViewControllerManager createViewController:@"ChoseAgentCar"];
    [ViewControllerManager showBaseViewController:@"ChoseAgentCar" AnimationType:vaDefaultAnimation SubType:0];
}
#pragma mark 投保
-(void)dealInsurance{

    [ViewControllerManager createViewController:@"INeedInusranceVC"];
    [ViewControllerManager showBaseViewController:@"INeedInusranceVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 保险
-(void)myInsurance{
    [ViewControllerManager createViewController:@"MyInsuranceVC"];
    [ViewControllerManager showBaseViewController:@"MyInsuranceVC" AnimationType:vaDefaultAnimation SubType:0];
}

- (IBAction)needInsuranceButtonCLicked:(id)sender {
    [UIView animateChangeView:self.IneedInsuranceNoticeView AnimationType:vaFade SubType:vsFromBottom Duration:.2 CompletionBlock:^{
        [self.IneedInsuranceNoticeView removeFromSuperview];
    }];
    
}

- (void)viewDidUnload {
[self setIneedInsuranceNoticeView:nil];
    [self setNoticeContentView:nil];
[super viewDidUnload];
}
@end
