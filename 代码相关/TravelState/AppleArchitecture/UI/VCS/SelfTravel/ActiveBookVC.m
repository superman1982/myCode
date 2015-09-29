//
//  ActiveBookVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ActiveBookVC.h"
#import "BookPeopleCell.h"
#import "BookHotelCell.h"
#import "BookHotelHouseCell.h"
#import "BookCarCell.h"
#import "BookInsuranceCell.h"
#import "NetManager.h"
#import "BookInsuranceCell.h"
#import "ActivityRouteManeger.h"
#import "UserManager.h"
#import "AgrementVC.h"

@interface ActiveBookVC ()
{
    BookTableFirstRowVC *mBookTableFirstRowVC;  //参与人员表
    NSMutableDictionary *mParemeterDic;  //报名参数
    BookCarCell *mBookCarCellOne;  //提供拼车cell
    BookCarCell *mBookCarCellTwo;   //需要拼车cell
    BookHotelCell *mBookHotelCellSigle;   //单人间cell
    BookHotelCell *mBookHotelCellDouble;  //双人间cell
    BookHotelHouseCell *mBookHouserCell;  //提供拼房cell
    BookInsuranceCell *mBookInuranceCell;  //保险cell
    BOOL         mIsAllowAgrement;      //是否同意活动协议
    NSMutableArray *msignupUsers;   //报名人员
    NSDictionary *mprovideCar;    //提供车辆信息
    NSDictionary *mneedCar;    //需求车辆信息
    BOOL       isCheckMakeHouse;  //是否同意拼房
    bool       isClickedMakeHoseNotice;
}
@end

@implementation ActiveBookVC

- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ActiveBookVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ActiveBookVC" bundle:aBuddle];
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
    self.title = @"活动报名";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"完成" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(bookInfoFinishButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mParemeterDic = [[NSMutableDictionary alloc] init];
    msignupUsers = [[NSMutableArray alloc] init];
    mIsAllowAgrement = YES;
    isCheckMakeHouse = YES;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [msignupUsers removeAllObjects],[msignupUsers release];
    [mprovideCar removeAllObjects],[mprovideCar release];
    [mneedCar removeAllObjects],[mneedCar release];
    [mParemeterDic removeAllObjects],[mParemeterDic release];
    [self.activinfo release];
    [mParemeterDic release];
    [mBookTableFirstRowVC release];
    [_footerViewForBookTable release];
    [_activeBookTableView release];
    [_headerViewFormakeHotel release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    mBookTableFirstRowVC = [[BookTableFirstRowVC alloc] init];
    mBookTableFirstRowVC.delegate = self;
    mBookTableFirstRowVC.activeInfo = self.activinfo;
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
    mBookTableFirstRowVC = Nil;
    [super viewShouldUnLoad];
}
//------------------------
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 10;
    }else if (section == 2){
        return 15;
    }else if (section == 3){
        return 0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 0;
    }else if (section == 4){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //返回第一行动态变化的高度
            [mBookTableFirstRowVC setViewFrame];
            return mBookTableFirstRowVC.view.frame.size.height;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (!isClickedMakeHoseNotice) {
                NSLog(@"33");
                [self.headerViewFormakeHotel setFrame:CGRectMake(0, 0, 320, 33)];
                return 33;
            }else{
                [self.headerViewFormakeHotel setFrame:CGRectMake(0, 0, 320, 113)];
                return 113;
            }
        }
    }
    if (indexPath.section == 3) {
        return 0;
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            return self.footerViewForBookTable.frame.size.height;
        }
    }
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"选订住宿";
    }else if (section == 3){
        return @"此活动参与人员提供一份意外保险";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        static NSString *vCellIdentify = @"firstRow";
        UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
        if (vCell == Nil) {
            vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        }
        [mBookTableFirstRowVC.view removeFromSuperview];
        [vCell.contentView addSubview:mBookTableFirstRowVC.view];
        vCell.clipsToBounds = YES;
        return vCell;
        
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:@"firstRow"];
            if (vCell == Nil) {
                vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstRow"];
            }
      
            [vCell.contentView addSubview:self.headerViewFormakeHotel];
            return vCell;
        }else{
            static NSString *vCellIdentify = @"houseCell";
            BookHotelHouseCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
            if (vCell == Nil) {
                vCell = [[[NSBundle mainBundle] loadNibNamed:@"BookHotelHouseCell" owner:self options:Nil] objectAtIndex:0];
                mBookHouserCell = vCell;
                [vCell.contentView setBackgroundColor:[UIColor whiteColor]];
                vCell.isCheck = YES;
            }
            vCell.activeInfo = self.activinfo;
            vCell.delegate = self;
            return vCell;
        }

    }
    
    if (indexPath.section == 2) {
        static NSString *vCellIdentify = @"carCell";
        BookCarCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
        if (vCell == Nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"BookCarCell" owner:self options:Nil] objectAtIndex:0];
        }
        if (indexPath.row == 0) {
            mBookCarCellOne = vCell;
            mBookCarCellOne.produceCarOrNeedCarLable.text = @"提供拼车";
            mBookCarCellOne.carBrandLable.text = @"可选填";
            mBookCarCellOne.carLisenceLable.text= @"";
            mBookCarCellOne.peopleNumberLable.text = @"";
            [self setProuceCarUI];
        }else{
            mBookCarCellTwo = vCell;
            mBookCarCellTwo.produceCarOrNeedCarLable.text = @"需要拼车";
            mBookCarCellTwo.carBrandLable.text = @"可选填";
            mBookCarCellTwo.carLisenceLable.text= @"";
            mBookCarCellTwo.peopleNumberLable.text = @"";
            [self setNeedCarUI];
        }
        return vCell;
    }
    
    if (indexPath.section == 3) {
        static NSString *vCellIdentify = @"insureCell";
        BookInsuranceCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
        if (vCell == Nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"BookInsuranceCell" owner:self options:Nil] objectAtIndex:0];
            vCell.delegate = self;
            vCell.numberOfInurance = 0;
            vCell.inurancePrice = [self.activinfo.insuranceMone intValue];
        }
        vCell.numberOfInuranceLable.text = [NSString stringWithFormat:@"%d",vCell.numberOfInurance];
        vCell.insurancePriceLable.text = [NSString stringWithFormat:@"%d",[self.activinfo.insuranceMone intValue] * vCell.numberOfInurance];
        mBookInuranceCell = vCell;
        return vCell;
    }
    
    if (indexPath.section == 4 ) {
        static NSString *vCellIdentify = @"lastRow";
        UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
        if (vCell == Nil) {
            vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        }
        [vCell.contentView addSubview:self.footerViewForBookTable];
        return vCell;
        
    }
    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            isClickedMakeHoseNotice = !isClickedMakeHoseNotice;
            [tableView reloadData];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self gotProvideCarVC];
        }else if(indexPath.row == 1){
            [self goToNeedCarVC];
        }
    }
}

#pragma mark BookFirstRowVCDelegate
//更新报名列表，变宽添加人员信息
-(void)didFinishFillFirstRow:(NSMutableArray *)sender{
    if (![sender isKindOfClass:[NSArray class]]) {
        LOGERROR(@"didFinishFillFirstRow");
        return;
    }
    [self.activeBookTableView reloadData];
    [msignupUsers removeAllObjects];
    [msignupUsers addObjectsFromArray:sender];
    NSInteger vLodgingMoney = sender.count * [self.activinfo.lodingMoney intValue];
    mBookHouserCell.lodgingMoney.text = [NSString stringWithFormat:@"%d",vLodgingMoney];
    [self performSelector:@selector(reloadTable) withObject:Nil afterDelay:.2];
}
//
-(void)reloadTable{
    [self.activeBookTableView reloadData];
}

#pragma mark ProviceCarVCDelegate
#pragma mark 提供拼车选择完毕
-(void)didProvideCarFinished:(NSDictionary *)sender{
    if (sender == Nil) {
        LOGERROR(@"didProvideCarFinished");
        return;
    }
    mprovideCar = [[NSDictionary alloc] initWithDictionary:sender];
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.activeBookTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark NeedCarVCDelegate
#pragma mark 需要拼车选择完毕
-(void)didNeedCarFinished:(id)sender{
    if (sender == Nil) {
        LOGERROR(@"didNeedCarFinished");
        return;
    }
    mneedCar = [[NSDictionary alloc] initWithDictionary:sender];
    NSIndexPath *vIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    [self.activeBookTableView reloadRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark BookHotelHouseCellDelegate
#pragma mark 选择是否拼房
-(void)BookHotelHouseCellDidSeleted:(BOOL)sender{
    isCheckMakeHouse = sender;
    [self.activeBookTableView reloadData];
}


#pragma mark 保险数量改变
-(void)didBookInsuranceCellChanged:(NSNumber *)sender{
    [self.activeBookTableView reloadData];
}

#pragma mark 其他辅助功能
-(void)gotProvideCarVC{
    [ViewControllerManager createViewController:@"ProvideCar"];
    ProvideCar *vVC = (ProvideCar *)[ViewControllerManager getBaseViewController:@"ProvideCar"];
    vVC.delegate = self;
    [ViewControllerManager showBaseViewController:@"ProvideCar" AnimationType:vaDefaultAnimation SubType:0];
}

-(void)setProuceCarUI{
    if (mprovideCar.count > 0) {
        //车型
        id vCarBrand = [mprovideCar objectForKey:@"carModel"];
        IFISNIL(vCarBrand);
        mBookCarCellOne.carBrandLable.text = vCarBrand;
        //车牌
        id vCarLisence = [mprovideCar objectForKey:@"carBrand"];
        IFISNIL(vCarBrand);
        mBookCarCellOne.carLisenceLable.text= vCarLisence;
        //可拼人数
        id vPeoplerStr = [mprovideCar objectForKey:@"seatQuantity"];
        IFISNIL(vPeoplerStr);
        vPeoplerStr = [NSString stringWithFormat:@"可拼%@人",vPeoplerStr];
        mBookCarCellOne.peopleNumberLable.text = vPeoplerStr;
    }
}

-(void)setNeedCarUI{
    if (mneedCar.count > 0) {
        id vPeopleNumberStr = [mneedCar objectForKey:@"needSeat"];
        IFISNIL(vPeopleNumberStr);
        mBookCarCellTwo.carBrandLable.text = @"拼车座位";
        
        mBookCarCellTwo.peopleNumberLable.hidden = YES;
        mBookCarCellTwo.carLisenceLable.text = [NSString stringWithFormat:@"%@",vPeopleNumberStr];
    }
}

#pragma mark 需要拼车
-(void)goToNeedCarVC{
    //拼接请求数据，获取活动ID
    NSNumber *vActivId = [self.activinfo ActivityId];
    vActivId = [vActivId intValue] > 0 ? vActivId : [NSNumber numberWithInt:0];
    id userId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",vActivId,@"activityId", nil];
    //请求网络数据
    [NetManager postDataFromWebAsynchronous:APPURL410 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        //分析数据
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vDataArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDataDic) {
            [vDataArray addObject:vDic];
        }
        //切换页面
        [ViewControllerManager createViewController:@"NeedCarVC"];
        NeedCarVC *vVC = (NeedCarVC *)[ViewControllerManager getBaseViewController:@"NeedCarVC"];
        vVC.delegate = self;
        if (vDataArray.count > 0) {
            vVC.needCarInfo = vDataArray;
        }
        vVC.activeInfo = self.activinfo;
        [ViewControllerManager showBaseViewController:@"NeedCarVC" AnimationType:vaDefaultAnimation SubType:0];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"获取拼车列表" Notice:@""];
}

-(void)postToWebForBook:(NSString *)aPayPassWord{
    if (aPayPassWord.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写支付密码！"];
        return;
    }
    [mParemeterDic setObject:aPayPassWord forKey:@"payPassword"];
    
    //获取userID
    id vUserId = [UserManager instanceUserManager].userID;
    IFISNIL(vUserId);
    [mParemeterDic setObject:vUserId forKey:@"userId"];
    
    //获取活动ID
    id vActivityId = self.activinfo.ActivityId;
    IFISNIL(vActivityId);
    [mParemeterDic setObject:vActivityId  forKey:@"activityId"];
    
    //检查报名人员
    [mParemeterDic setObject:msignupUsers forKey:@"signupUsers"];
    if (msignupUsers.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写参与人员信息！"];
        return;
    }
    
    //是否正常添加报名
    if ([self.activinfo.isSignup intValue] == 1) {
        self.signupType = 1;
    }
    [mParemeterDic setObject:[NSNumber numberWithInt:self.signupType] forKey:@"signupType"];
    
    BOOL visWishSpell = mBookHouserCell.isCheck;
    //是否愿意拼房
    [mParemeterDic setObject:[NSNumber numberWithInt:visWishSpell] forKey:@"isWishSpell"];
    //设置房间数量
    if (visWishSpell) {
        NSInteger vdoubleQuantity = msignupUsers.count/2 + msignupUsers.count%2;
        [mParemeterDic setObject:[NSNumber numberWithInt:vdoubleQuantity] forKey:@"doubleQuantity"];
        [mParemeterDic setObject:[NSNumber numberWithInt:0] forKey:@"singleQuantity"];
    }else{
        NSInteger vsingleQuantity = msignupUsers.count;
        [mParemeterDic setObject:[NSNumber numberWithInt:0] forKey:@"doubleQuantity"];
        [mParemeterDic setObject:[NSNumber numberWithInt:vsingleQuantity] forKey:@"singleQuantity"];
    }
    
    if (mprovideCar == Nil) {
        mprovideCar = [NSMutableDictionary dictionary];
    }
    //设置车辆需求
    [mParemeterDic setObject:mprovideCar forKey:@"provideCar"];
    mneedCar = mneedCar == Nil ? [NSMutableDictionary dictionary] : mneedCar;
    [mParemeterDic setObject:mneedCar forKey:@"needCar"];
    
    //检查保险数量
    NSInteger vinsuranceCount = mBookInuranceCell.numberOfInurance;
    if (vinsuranceCount == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择保险数量!"];
    }
    //设置保险数量
    [mParemeterDic setObject:[NSNumber numberWithInt:vinsuranceCount] forKey:@"insuranceCount"];
    
    [ActivityRouteManeger postSharePraseCommentData:APPURL407 Paremeter:mParemeterDic Prompt:@"报名成功" RequestName:@"活动报名"];
    [self back];
    if ([_delegate respondsToSelector:@selector(didActiveBookVCSucess:)]) {
        [_delegate didActiveBookVCSucess:Nil];
    }

}

#pragma mark 获取保险金额
-(NSInteger )getInsuranceCost{
    NSInteger vInsuranceNumber = mBookInuranceCell.numberOfInurance;
    int vTotalCost = vInsuranceNumber * [self.activinfo.insuranceMone integerValue];
    if ([self.activinfo.isIncludeInsurance intValue]) {
        //如果活动费用已经包含保险费用，保险数量大于1，那么加上增加的保险
        if (vInsuranceNumber > 1) {
            vTotalCost = vTotalCost - [self.activinfo.insuranceMone intValue];
        }else{
            vTotalCost = 0;
        }
    }
    
    return vTotalCost;
}

#pragma mark 获取报名总金额
-(NSInteger) getTotalCost{
    NSInteger vTotalCost = [self getInsuranceCost];
    vTotalCost += [self.activinfo.memberPrice intValue];
    if (!isCheckMakeHouse) {
        vTotalCost -= [self.activinfo.insuranceMone intValue];
    }
    return vTotalCost;
}

#pragma mark 输入支付密码
-(void)showInputPassWordUI:(NSString *)aMessage{
    UIAlertView *vAlert = [[UIAlertView alloc] initWithTitle:@"支付密码" message:aMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [vAlert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [[vAlert textFieldAtIndex:0] setPlaceholder:@"支付密码"];
    [vAlert show];
    vAlert = Nil;

}
#pragma mark 支付密码确定
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *vPayPasswordStr = [alertView textFieldAtIndex:0].text;
        if (vPayPasswordStr.length == 0) {
            return;
        }
        //开始报名
        [self postToWebForBook:vPayPasswordStr];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([alertView textFieldAtIndex:0].text.length == 0) {
            [self showInputPassWordUI:alertView.message];
        }
    }
}

#pragma mark - 其他业务点击事件
-(void)bookInfoFinishButtonTouchDown:(id)sender{
    if (mIsAllowAgrement) {
        //支付密码
        NSInteger vTotalCostMoney = [self getTotalCost];
        NSString *vTotalMoney = [NSString stringWithFormat:@"所需途币: %d",vTotalCostMoney];
        [self showInputPassWordUI:vTotalMoney];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请同意活动协议方可报名！"];
    }
}

#pragma mark 通用活动协议
- (IBAction)checkButtonClicked:(UIButton *)sender {
    if (!mIsAllowAgrement) {
        mIsAllowAgrement = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_select"] forState:UIControlStateNormal];
    }else{
        mIsAllowAgrement = NO;
       [sender setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_default"] forState:UIControlStateNormal];
    }
}

- (IBAction)agrementClicked:(id)sender {
    AgrementVC *vAgrementVC = [[AgrementVC alloc] init];
    vAgrementVC.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    UINavigationController *vNavi= [[UINavigationController alloc] initWithRootViewController:vAgrementVC];
    [vAgrementVC setAgrementType:atBook];
    [self presentModalViewController:vNavi animated:YES];
    SAFE_ARC_RELEASE(vAgrementVC);
    SAFE_ARC_RELEASE(vNavi);
}

- (void)viewDidUnload {
[self setFooterViewForBookTable:nil];
    [self setActiveBookTableView:nil];
    [self setHeaderViewFormakeHotel:nil];
[super viewDidUnload];
}
@end
