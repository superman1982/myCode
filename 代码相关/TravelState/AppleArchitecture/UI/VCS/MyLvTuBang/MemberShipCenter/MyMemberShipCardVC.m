//
//  UPGrandMemberShipVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyMemberShipCardVC.h"
#import "MemberShipCell.h"
#import "UserManager.h"
#import "NetManager.h"

@interface MyMemberShipCardVC ()

@property (nonatomic,retain) NSMutableArray *memberCardArray;

@end

@implementation MyMemberShipCardVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"MyMemberShipCardVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyMemberShipCardVC" bundle:aBuddle];
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
    self.title = @"会员中心";
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
    [_memberCardArray removeAllObjects];
    [_memberCardArray release];
    [_footerView release];
    [_upGrandTableView release];
    [_myVIpCardHeaderView release];
    [_cardLevel release];
    [_expireTime release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self postMyCard];
//    self.cardNo.text = @"";
//    self.cardLevel.text = @"";
//    self.expireTime.text = @"";;
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
    [self setUpGrandTableView:nil];
   [self setFooterView:nil];
    [self setMyVIpCardHeaderView:nil];
    [self setCardLevel:nil];
    [self setExpireTime:nil];
   [super viewDidUnload];
}


-(void)setMemberCardArray:(NSMutableArray *)memberCardArray{
    if (_memberCardArray == Nil) {
        _memberCardArray = [[NSMutableArray alloc] init];
    }
    [_memberCardArray addObjectsFromArray:memberCardArray];
    [self.upGrandTableView reloadData];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.memberCardArray.count > 0) {
            return self.myVIpCardHeaderView.frame.size.height;
        }
    }else if(section == 1){
        if (self.memberCardArray.count > 0) {
            return 40;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        if (self.memberCardArray.count > 0) {
            return self.footerView.frame.size.height;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return self.footerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
            return self.myVIpCardHeaderView;
    }else if (section == 1){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
        UILabel *vTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 21)];
        vTitleLable.backgroundColor = [UIColor clearColor];
        [vTitleLable setFont:[UIFont systemFontOfSize:15]];
        vTitleLable.textColor = [UIColor darkGrayColor];
        
        vTitleLable.text = @"我的会员卡";
        [headerView addSubview:vTitleLable];
        
        SAFE_ARC_AUTORELEASE(vTitleLable);
        SAFE_ARC_AUTORELEASE(headerView);
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        MemberShipCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"MemberShipCell" owner:self options:nil] objectAtIndex:0];
        return vCell.frame.size.height;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (section == 0) {
        return 0;
    }else if (section == 1){
        NSInteger vRowCount = self.memberCardArray.count;
        if (vRowCount > 0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        return  vRowCount;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"memCell";
    MemberShipCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"MemberShipCell" owner:self options:nil] objectAtIndex:0];
    }

    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 其他辅助功能
#pragma mark 我的会员卡
-(void)postMyCard{
    NSMutableDictionary *vParemeter = [NSMutableDictionary dictionary];
    id vUserID = [UserManager instanceUserManager].userID;
    [vParemeter setObject:vUserID forKey:@"userId"];
    [NetManager postDataFromWebAsynchronous:APPURL809 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            self.cardLevel.text = [vDataDic objectForKey:@"cardLevel"];
            IFISNIL(self.cardLevel.text);
            self.cardLevel.text = [NSString stringWithFormat:@"会员级别：%@",self.cardLevel.text];
            
            self.expireTime.text = [vDataDic objectForKey:@"expireTime"];
            IFISNIL(self.expireTime.text);
            self.expireTime.text = [NSString stringWithFormat:@"到期时间：%@",self.expireTime.text];
            //
            id vCardNo = [vDataDic objectForKey:@"cardNo"];
            [self postMyCardDetail:vCardNo];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"我的会员卡" Notice:@""];
}

#pragma mark
#pragma mark 会员卡福利
-(void)postMyCardDetail:(id)cardNo{
    NSMutableDictionary *vParemeter = [NSMutableDictionary dictionary];
    id vUserID = [UserManager instanceUserManager].userID;
    [vParemeter setObject:vUserID forKey:@"userId"];
    [vParemeter setObject:cardNo forKey:@"cardNo"];;
    [NetManager postDataFromWebAsynchronous:APPURL810 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vDataArray = [NSMutableArray array];
        if (vDataDic.count > 0) {
            for (NSDictionary *vDic in vDataDic) {
                [vDataArray addObject:vDic];
            }
        }
        self.memberCardArray = vDataArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"会员卡详情" Notice:@""];
}

#pragma mark - 其他业务点击事件
- (IBAction)upGrandButtonClicked:(id)sender {
    [ViewControllerManager  createViewController:@"UpGrandMemberVC"];
    [ViewControllerManager showBaseViewController:@"UpGrandMemberVC" AnimationType:vaDefaultAnimation SubType:0];
}

@end
