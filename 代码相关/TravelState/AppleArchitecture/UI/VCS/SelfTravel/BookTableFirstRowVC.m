//
//  BookTableFirstRowVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BookTableFirstRowVC.h"
#import "BookPeopleCell.h"
#import "ActivityRouteManeger.h"
#import "SVProgressHUD.h"
#import "UserManager.h"

@interface BookTableFirstRowVC ()
{
    NSMutableArray *mBookPeopleArray;
    NSInteger       mSelectedIndex;
}
@end

@implementation BookTableFirstRowVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*    NSDictionary *vPeopleInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
 mUserID,@"userId",
 self.phoneNumberField.text,@"phone",
 self.nameFiled.text,@"name",
 self.sexField.text,@"sex",
 self.IDCardField.text,@"idNumber",
 vQQStr,@"QQ",
 vEmailStr,@"email",
 nil];
 [mInfoArray addObject:vPeopleInfoDic];*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, 320, 44);
    mBookPeopleArray = [[NSMutableArray alloc] init];
    //正常报名时是否包括自己
    if ([self.activeInfo.isSignup intValue] == 0) {
        //如果活动包含自己，把自己加上报名名单
        if ([self.activeInfo.isIncludeSelf intValue] == 1) {
            UserInfo *vUserInfo = [UserManager instanceUserManager].userInfo;
            NSDictionary *vSelfDic = @{@"userId":vUserInfo.usertId,
                                       @"phone":vUserInfo.phone,
                                       @"name":vUserInfo.realName,
                                       @"sex":vUserInfo.sex,
                                       @"idNumber":vUserInfo.idNumber,
                                       @"QQ":vUserInfo.QQ,
                                       @"email":vUserInfo.email,
                                       };
            [self didFinishPeopleInfo:@[vSelfDic]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mBookPeopleArray release];
    [_firstRowTableView release];
    [super dealloc];
}
#endif

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1 && mBookPeopleArray.count > 0){
        return 15;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return mBookPeopleArray.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"活动报名人员";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"peopleCell";
    BookPeopleCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == Nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"BookPeopleCell" owner:self options:Nil] objectAtIndex:0];
    }
    if (indexPath.section == 0 ) {
    }
    
    if (indexPath.section == 1) {
        NSString *vPhoneStr = [[mBookPeopleArray objectAtIndex:indexPath.row] objectForKey:@"phone"];
        IFISNIL(vPhoneStr);
        NSString *vNameStr = [[mBookPeopleArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        IFISNIL(vNameStr);
        
        NSString *vSexStr = [[mBookPeopleArray objectAtIndex:indexPath.row] objectForKey:@"sex"];
        IFISNIL(vSexStr);
        
        NSString *vPeoPleStr = [NSString stringWithFormat:@"%@  %@  %@",vPhoneStr,vNameStr,vSexStr];
        vCell.peopleLable.text= vPeoPleStr;
        vCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //获取剩余可报名人数
            id vActivIDStr = [NSString stringWithFormat:@"%@",self.activeInfo.ActivityId];
            IFISNIL(vActivIDStr);
            NSDictionary *vSingupDic = [[ActivityRouteManeger shareActivityManeger].bookPeopleDic objectForKey:vActivIDStr];
            NSInteger vBookPeople = [[vSingupDic objectForKey:BOOKEDPEOPLEKEY] intValue];
            //有剩余人数才可以报名
            if (vBookPeople > 0) {
                [ViewControllerManager createViewController:@"FillPeopleInfoVC"];
                FillPeopleInfoVC *vPeopleVC =(FillPeopleInfoVC *)[ViewControllerManager getBaseViewController:@"FillPeopleInfoVC"];
                vPeopleVC.delegate = self;
                //活动信息
                vPeopleVC.activeInfo = self.activeInfo;
                [ViewControllerManager showBaseViewController:@"FillPeopleInfoVC" AnimationType:vaDefaultAnimation SubType:0];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat: @"该活动单次最多能添加%@人",self.activeInfo.totalSignup ]];
            }

        }
    }else{
        NSString *vPhoneStr = [[mBookPeopleArray objectAtIndex:indexPath.row] objectForKey:@"phone"];
        if (![vPhoneStr isEqualToString:[UserManager instanceUserManager].userInfo.phone]) {
            UIAlertView *vAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该人员吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [vAlertView show];
            vAlertView = Nil;
            mSelectedIndex = indexPath.row;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [mBookPeopleArray removeObjectAtIndex:mSelectedIndex];
        [self refreshUI];
    }
}

#pragma mark 更新UI
-(void)refreshUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.firstRowTableView reloadData];
        if ([_delegate respondsToSelector:@selector(didFinishFillFirstRow:)]) {
            [_delegate didFinishFillFirstRow:mBookPeopleArray];
        }
    });
}

#pragma mark FillPeopleVCDelegate
//人员信息填写完毕，更新表格，显示人员信息
-(void)didFinishPeopleInfo:(NSMutableArray *)sender{
    if (sender.count > 0) {
        [mBookPeopleArray addObjectsFromArray:sender];
        [self refreshUI];
    }
}

#pragma mark 设置Table大小
-(void)setViewFrame{
    [self.view setFrame:CGRectMake(0, 0, 320,44*mBookPeopleArray.count + 59)];
    if (mBookPeopleArray.count == 0) {
        [self.view setFrame:CGRectMake(0, 0, 320,44*mBookPeopleArray.count + 44)];
    }
}

- (void)viewDidUnload {
[self setFirstRowTableView:nil];
[super viewDidUnload];
}
@end
