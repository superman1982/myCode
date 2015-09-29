//
//  MyInsuranceVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyInsuranceVC.h"
#import "AddBunessInuranceVC.h"
#import "AddJiaoQiangXiangVC.h"
#import "UserManager.h"
#import "NetManager.h"
#import "InsuranceInfo.h"

@interface MyInsuranceVC ()
{
    NSString *mFirstRowLableStr;
    BOOL isSelectedBunessInsurance;
    NSInteger mSelectedRow;
    UIButton *mRightButton;
}
@property (nonatomic,retain) NSMutableArray *tableShowArray;
@end

@implementation MyInsuranceVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"MyInsuranceVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MyInsuranceVC" bundle:aBuddle];
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
    self.title = @"我的保险";
    //右边客服按钮
    if (mRightButton == Nil) {
        mRightButton = [[UIButton alloc] init];
        [mRightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [mRightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [mRightButton setFrame:CGRectMake(0, 0, 40, 44)];
        [mRightButton addTarget:self action:@selector(editButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    }

    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mFirstRowLableStr = @"添加商业险";
    isSelectedBunessInsurance = YES;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_insuranceTableView release];
    [_tableShowArray removeAllObjects],[_tableShowArray release];
    [_bunessButton release];
    [_jiaoQiangButton release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self bunessInsuranceButtonClicked:Nil];
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

-(void)setTableShowArray:(NSMutableArray *)tableShowArray{
    if (_tableShowArray == Nil) {
        _tableShowArray = [[NSMutableArray alloc] init];
    }
    [_tableShowArray removeAllObjects];
    [_tableShowArray addObjectsFromArray:tableShowArray];
    [self.insuranceTableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
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
        return _tableShowArray.count;
    }
    return 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        InsuranceInfo *vInfo = [self.tableShowArray objectAtIndex:row];
        [self deleteInsurance:vInfo NSIndexPath:indexPath];
    }
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
        
        //设置介绍
        UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 11, 200, 21)];
        [vLable setBackgroundColor:[UIColor clearColor]];
        vLable.font = [UIFont systemFontOfSize:15];
        vLable.textColor = [UIColor darkGrayColor];
        vLable.textAlignment = NSTextAlignmentRight;
        vLable.tag = 101;
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
    }
    if (indexPath.section == 0){
        InsuranceInfo *vInfo = [_tableShowArray objectAtIndex:indexPath.row];
        vCell.textLabel.text = vInfo.insuranceCompany;
        //右边介绍
        UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
        vLable.hidden = NO;
        vLable.text = [NSString stringWithFormat:@"%@到期",vInfo.expirationDate];
    }
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        mSelectedRow = indexPath.row;
        if (isSelectedBunessInsurance) {
            [self showBunessInsuranceDetail];
        }else{
            [self showJiaoQiangXian];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark AddBunessInsuranceDelegate
-(void)didAddBunessInuranceSucces:(id)sender{
    [self bunessInsuranceButtonClicked:Nil];
}

#pragma mark AddJiaoQiangXianDelegate
-(void)didAddJiaoQiangXiangFinished:(id)sender{
    [self jiaoQiangXiangButtonClicked:Nil];
}

#pragma mark ad
#pragma mark - 其他辅助功能
#pragma mark 请求数据
-(void)postToWeb:(BOOL)aIsBunessInsurance{
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                nil];
    NSString *vHttmURL = APPURL504;
    NSString *vDescriptionStr =@"交强保险";
    if (isSelectedBunessInsurance) {
        vHttmURL = APPURL502;
        vDescriptionStr =@"商业保险";
    }
    
    [NetManager postDataFromWebAsynchronous:vHttmURL Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vNoticeArray = [NSMutableArray array];
        if (vDataDic.count > 0) {
            for (NSDictionary *vDic in vDataDic) {
                InsuranceInfo *vInfo = [[InsuranceInfo alloc] init];
                vInfo.insuranceId = [vDic objectForKey:@"insuranceId"];
                IFISNIL(vInfo.insuranceId);
                vInfo.policyNumber = [vDic objectForKey:@"policyNumber"];
                IFISNIL(vInfo.policyNumber);
                vInfo.insuranceCompany = [vDic objectForKey:@"insuranceCompany"];
                IFISNIL(vInfo.insuranceCompany);
                vInfo.reportPhone = [vDic objectForKey:@"reportPhone"];
                IFISNIL(vInfo.reportPhone);
                vInfo.insuranceArea = [vDic objectForKey:@"insuranceArea"];
                IFISNIL(vInfo.insuranceArea);
                vInfo.effectiveDate = [vDic objectForKey:@"effectiveDate"];
                IFISNIL(vInfo.expirationDate);
                vInfo.expirationDate = [vDic objectForKey:@"expirationDate"];
                IFISNIL(vInfo.expirationDate);
                NSDictionary *policyImagDic = [vDic objectForKey:@"policyImg"];
                vInfo.isAudit = [vDic objectForKey:@"isAudit"];
                IFISNILFORNUMBER(vInfo.isAudit);
                
                NSMutableArray *vdataArray = [NSMutableArray array];
                for (NSDictionary *vPlicyDic in policyImagDic) {
                    [vdataArray  addObject:vPlicyDic];
                }
                vInfo.policyImg = vdataArray;
                [vNoticeArray addObject:vInfo];
            }
        }
        self.tableShowArray = vNoticeArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:vDescriptionStr Notice:@""];
}

#pragma mark 删除保险
-(void)deleteInsurance:(InsuranceInfo *)aInfo NSIndexPath:(NSIndexPath *)aPath{
    id userId = [UserManager instanceUserManager].userID;
    id type = Nil;
    if (isSelectedBunessInsurance) {
        type = [NSNumber numberWithInt:0];
    }else{
        type = [NSNumber numberWithInt:1];
    }
    
    id insuranceId = aInfo.insuranceId;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                userId,@"userId",
                                type,@"type",
                                insuranceId,@"insuranceId",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL540 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self.tableShowArray removeObject:aInfo];
                [self.insuranceTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:aPath]
                                 withRowAnimation:UITableViewRowAnimationAutomatic];
                //当没有信息时，结束编辑状态
                if (self.tableShowArray.count == 0) {
                    [self editButtonTouchDown:Nil];
                }
            }
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"删除保险" Notice:@""];
}

#pragma mark - 其他业务点击事件

- (IBAction)addInsuranceClicked:(id)sender {
    
    //如果选择的是商业保险，就添加商业保险
    if (isSelectedBunessInsurance) {
        [self addBunessInsurance];
    }else{
        [self addJiaoQiangXiang];
    }

}


#pragma mark 点击商业保险
- (IBAction)bunessInsuranceButtonClicked:(id)sender {
    isSelectedBunessInsurance = YES;
    mFirstRowLableStr = @"添加商业险";
    self.addInsuranceLable.text = mFirstRowLableStr;
    [self postToWeb:YES];
    [self.bunessButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
    [self.bunessButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    [self.jiaoQiangButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.jiaoQiangButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
}

#pragma mark 点击交强险
- (IBAction)jiaoQiangXiangButtonClicked:(id)sender {
    isSelectedBunessInsurance = NO;
     mFirstRowLableStr = @"添加交强险";
    self.addInsuranceLable.text = mFirstRowLableStr;
    [self postToWeb:NO];
    [self.jiaoQiangButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg"] forState:UIControlStateNormal];
    [self.jiaoQiangButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    [self.bunessButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.bunessButton setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
}

#pragma mark  添加商业保险
-(void)addBunessInsurance{
    [ViewControllerManager createViewController:@"AddBunessInuranceVC"];
    AddBunessInuranceVC *vAddBunessInuranceVC = (AddBunessInuranceVC *)[ViewControllerManager getBaseViewController:@"AddBunessInuranceVC"];
    vAddBunessInuranceVC.isAddBunessInsurance = YES;
    vAddBunessInuranceVC.delegate = self;
    [ViewControllerManager showBaseViewController:@"AddBunessInuranceVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 查看商业保险详细
-(void)showBunessInsuranceDetail{
    [ViewControllerManager createViewController:@"AddBunessInuranceVC"];
    AddBunessInuranceVC *vAddBunessInuranceVC = (AddBunessInuranceVC *)[ViewControllerManager getBaseViewController:@"AddBunessInuranceVC"];
    vAddBunessInuranceVC.isAddBunessInsurance = NO;
    vAddBunessInuranceVC.insuranceInfo = [_tableShowArray objectAtIndex:mSelectedRow];
    [ViewControllerManager showBaseViewController:@"AddBunessInuranceVC" AnimationType:vaDefaultAnimation SubType:0];
}
#pragma mark 添加交强险
-(void)addJiaoQiangXiang{
    [ViewControllerManager createViewController:@"AddJiaoQiangXiangVC"];
    AddJiaoQiangXiangVC *vAddJiaoQiangInuranceVC = (AddJiaoQiangXiangVC *)[ViewControllerManager getBaseViewController:@"AddJiaoQiangXiangVC"];
    vAddJiaoQiangInuranceVC.isAddJiaoQiangXian = YES;
    vAddJiaoQiangInuranceVC.delegate = self;
    [ViewControllerManager showBaseViewController:@"AddJiaoQiangXiangVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 查看交强险
-(void)showJiaoQiangXian{
    [ViewControllerManager createViewController:@"AddJiaoQiangXiangVC"];
    AddJiaoQiangXiangVC *vAddJiaoQiangInuranceVC = (AddJiaoQiangXiangVC *)[ViewControllerManager getBaseViewController:@"AddJiaoQiangXiangVC"];
    vAddJiaoQiangInuranceVC.isAddJiaoQiangXian = NO;
    vAddJiaoQiangInuranceVC.insuranceInfo = [_tableShowArray objectAtIndex:mSelectedRow];
    LOG(@"vAddJiaoQiangInuranceVC.insuranceInfo:%@",vAddJiaoQiangInuranceVC.insuranceInfo);
    [ViewControllerManager showBaseViewController:@"AddJiaoQiangXiangVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 列表编辑状态打开
-(void)editButtonTouchDown:(id)sender{
    if (!self.insuranceTableView.editing == YES) {
        [self.insuranceTableView setEditing:YES animated:YES];
        [mRightButton setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [self.insuranceTableView setEditing:NO animated:YES];
        [mRightButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload {
[self setInsuranceTableView:nil];
    [self setBunessButton:nil];
    [self setJiaoQiangButton:nil];
[super viewDidUnload];
}
@end
