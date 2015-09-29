//
//  ChoseAgentCar.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChoseAgentCar.h"
#import "AgentChoseCarCell.h"
#import "AgentBunessVC.h"
#import "NetManager.h"
#import "ChoseProvinceVC.h"
#import "AgentBunessVC.h"
#import "UserManager.h"

@interface ChoseAgentCar ()
{
    NSMutableArray *mCarInfoArray;
    NSInteger mSeltedCarRow;
    NSMutableArray *mCells;
}
@end

@implementation ChoseAgentCar

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ChoseAgentCar_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChoseAgentCar" bundle:aBuddle];
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
    self.title = @"选择代办车辆";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mCarInfoArray = [[NSMutableArray alloc] init];
    mCells = [[NSMutableArray alloc] init];
    //当没有默认车辆时，默认第一行为选中车辆
    mSeltedCarRow = 0;
    [self getMyCars];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mCells removeAllObjects],[mCells release];
    [mCarInfoArray removeAllObjects],[mCarInfoArray release];
    [_headerLable release];
    [_headerView release];
    [_agentCarTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.footerVew.layer.borderWidth = 1;
    self.footerVew.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
    [self addBaiduMap];
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
    if (section == 0) {
        return self.headerView.frame.size.height;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (mCarInfoArray.count > 0) {
            self.headerLable.text = @"代办车辆";

        }else{
           self.headerLable.text = @"您还没有车务代办的车辆信息,请添加车辆！";
        }
        return self.headerView;
    }else if (section == 1){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
        SAFE_ARC_AUTORELEASE(headerView);
        return headerView;
    }
    return Nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return self.footerVew.frame.size.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return self.footerVew;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (mCarInfoArray.count > 0) {
            NSInteger vRowMax = mCarInfoArray.count;
            if (vRowMax > 6) {
                vRowMax = 6;
            }
            [tableView setFrame:CGRectMake(0, 0, 320, 100 + 44 * vRowMax)];
  
            return mCarInfoArray.count;
        }else{
            [tableView setFrame:CGRectMake(0, 0, 320, 140)];
        }
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    AgentChoseCarCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"AgentChoseCarCell" owner:self options:Nil] objectAtIndex:0];
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //设置图片
        UIImageView *vCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 14, 15, 15)];
        vCellImageView.tag = 100;
        vCellImageView.hidden = YES;
        vCellImageView.image = [UIImage imageNamed:@"carDetail_star_btn"];
        [vCellImageView setBackgroundColor:[UIColor clearColor]];
        [vCell.contentView addSubview:vCellImageView];
        SAFE_ARC_RELEASE(vCellImageView);
        
    }
    if (indexPath.section == 0) {
        if (mCarInfoArray.count > 0) {
            vCell.carLisenceLable.text =[[mCarInfoArray objectAtIndex:indexPath.row] objectForKey:@"carNumber"];
            IFISNIL(vCell.carLisenceLable.text);
            
            UIImageView *vImageView = (UIImageView *)[vCell.contentView viewWithTag:100];
            //设置默认车辆或第一行为选中状态
            if (indexPath.row == mSeltedCarRow) {
                [vCell.checkButton setBackgroundImage:[UIImage imageNamed:@"needShare_check_btn_select"] forState:UIControlStateNormal];
                vImageView.hidden = NO;
            }else{
                vImageView.hidden = YES;
            }
            [mCells addObject:vCell];
        }else{
            vCell.checkButton.hidden = YES;
            vCell.carLisenceLable.text = @"添加办理车辆";
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            vCell.checkButton.hidden = YES;
            vCell.carLisenceLable.text= @"代办地区";
            vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if (mCarInfoArray.count == 0) {
            [self addCarClicked];
        }else{
            //保存选中的车辆行数
            mSeltedCarRow = indexPath.row;
            //取消其他Cell的选中状态
            [self clearOtherCarCheckState];
            //设置为选中状态
            AgentChoseCarCell *vCell = (AgentChoseCarCell *)[tableView cellForRowAtIndexPath:indexPath];
            [vCell.checkButton setBackgroundImage:[UIImage imageNamed:@"needShare_check_btn_select"] forState:UIControlStateNormal];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
        }
    }
}

#pragma mark 车辆添加成功
-(void)didAddCarAndCarInfoFinished:(id)sender{
    [self getMyCars];
}

#pragma mark - 其他辅助功能

#pragma mark - 预先加载百度地图
-(void)addBaiduMap{
    //先加载一次地图，不然地图无法显示。
    BMKMapView *vMapView = [[BMKMapView alloc] init];
    [vMapView setFrame:CGRectMake(-40, -40, 0, 0)];
    [vMapView setHidden:YES];
    [self.view addSubview:vMapView];
}

-(void)goToChosePlaceVC{
    [ViewControllerManager createViewController:@"ChoseProvinceVC"];
    NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"type",[NSNumber numberWithInt:0],@"id",nil];
    
    [NetManager postDataFromWebAsynchronous:APPURL103 Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
        //解析返回数据到数组
        NSDictionary *vDataDic = [[NetManager jsonToDic:responseObject] objectForKey:@"data"];
        NSMutableArray *vDataArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDataDic) {
            [vDataArray addObject:vDic];
        }
        if (vDataArray.count > 0) {
            ChoseProvinceVC *vChosePlaceVC = (ChoseProvinceVC *)[ViewControllerManager getBaseViewController:@"ChoseProvinceVC"];
            vChosePlaceVC.placeArray = vDataArray;
            vChosePlaceVC.isNeedChosedDistrict = YES;
            vChosePlaceVC.delegate = self;
            vChosePlaceVC.fromVCName = @"ChoseAgentCar";
            //显示地区
            [ViewControllerManager showBaseViewController:@"ChoseProvinceVC" AnimationType:vaDefaultAnimation SubType:0];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"获取省" Notice:@""];
}

#pragma mark 获取我的车辆
-(void)getMyCars{
    id vUserID = [UserManager instanceUserManager].userID;
    IFISNIL(vUserID);
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:vUserID,@"userId",nil];
    [NetManager postDataFromWebAsynchronous:APPURL816 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vCarArray = [NSMutableArray array];
        NSDictionary *vDefalutCarDic = Nil;
        for (NSDictionary *vDic in vDataDic) {
            //寻找默认车辆
            if ([[vDic objectForKey:@"isDefault"] intValue] == 1) {
                vDefalutCarDic = vDic;
            }
            [vCarArray addObject:vDic];
        }
        [mCarInfoArray removeAllObjects];
        [mCarInfoArray  addObjectsFromArray:vCarArray];
        //设置默认车辆为默认选中车辆
        if (vDefalutCarDic != Nil) {
            mSeltedCarRow = [mCarInfoArray indexOfObject:vDefalutCarDic];
        }
        [self.agentCarTableView reloadData];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"查看我的爱车" Notice:@""];
}

#pragma mark - 其他业务点击事件
#pragma mark 添加车辆
-(void)addCarClicked{
    [ViewControllerManager createViewController:@"AddCarAndCarInfo"];
    AddCarAndCarInfo *vAddCarInfo = (AddCarAndCarInfo *)[ViewControllerManager getBaseViewController:@"AddCarAndCarInfo"];
            vAddCarInfo.isAddCar = YES;
    vAddCarInfo.delegate = self;
    [ViewControllerManager showBaseViewController:@"AddCarAndCarInfo" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 保存cell到数组
-(void)addCell:(id)aCell{
    BOOL vIsHaveInfo = NO;
    //检查是否已经储存过该cell
    for (id cellIndex in mCells) {
        if (aCell == cellIndex) {
            vIsHaveInfo = YES;
        }
    }
    //保存cell
    if (!vIsHaveInfo) {
        [mCells addObject:aCell];
    }
}

#pragma mark 取消其他车辆cell的选中状态
-(void)clearOtherCarCheckState{
    for (AgentChoseCarCell *vCell in mCells) {
        [vCell.checkButton setBackgroundImage:[UIImage imageNamed:@"needShare_check_btn_default"] forState:UIControlStateNormal];
    }
}

#pragma mark 选择地区
- (IBAction)choseAeraClicked:(id)sender {
    [self goToChosePlaceVC];
}


#pragma mark ChoseDistrctVCDelegate
-(void)didFinishChosedPlace:(NSDictionary *)sender{
    if (sender == Nil || sender.count == 0) {
        LOG(@"didFinishChosedPlace传入地区参数为空");
        return;
    }
    [ViewControllerManager backToViewController:@"ChoseAgentCar" Animatation:vaNoAnimation SubType:0];
    
    [ViewControllerManager createViewController:@"AgentBunessVC"];
    AgentBunessVC *vAgentVC = (AgentBunessVC *)[ViewControllerManager getBaseViewController:@"AgentBunessVC"];
    vAgentVC.placeDic = sender;
    vAgentVC.isSearchType = NO;
    [ViewControllerManager showBaseViewController:@"AgentBunessVC" AnimationType:vaDefaultAnimation SubType:0];

}

- (void)viewDidUnload {
   [self setHeaderView:nil];
   [self setHeaderLable:nil];
[self setAgentCarTableView:nil];
[super viewDidUnload];
}

@end
