//
//  DriverLifeVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "DriverLifeVC.h"
#import "UserManager.h"
#import "RegulationSeachVC.h"

@interface DriverLifeVC ()
{
    BunessDetailMapVC *mDetailmap;
}
@property (nonatomic,assign) BOOL  isAddedMap;
@end

@implementation DriverLifeVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"DriverLifeVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"DriverLifeVC" bundle:aBuddle];
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
    self.title = @"车主生活";
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
    [mDetailmap release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
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
    mDetailmap = Nil;
    [super viewShouldUnLoad];
}
//----------
-(void)back{
    if (self.isAddedMap) {
        self.title = @"车主生活";
        [mDetailmap.view removeFromSuperview];
        self.isAddedMap = NO;
    }else{
        [super back];
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }else if (section == 2){
        return 4;
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
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        //设置介绍
        UILabel *vLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 11, 200, 21)];
        [vLable setBackgroundColor:[UIColor clearColor]];
        vLable.font = [UIFont systemFontOfSize:15];
        vLable.textColor = [UIColor darkGrayColor];
        vLable.textAlignment = NSTextAlignmentRight;
        vLable.tag = 101;
        vLable.hidden = YES;
        [vCell.contentView addSubview:vLable];
        SAFE_ARC_RELEASE(vLable);
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"停车场";
        }else if (indexPath.row == 1){
            vCell.textLabel.text = @"加油站";
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"违章查询";
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            vCell.textLabel.text = @"救援";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            vLable.text = @"23453253242";
        }else if (indexPath.row == 1){
            vCell.textLabel.text = @"代驾";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            vLable.text = @"23453253242";
        }
        else if (indexPath.row == 2){
            vCell.textLabel.text = @"汽车租赁";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            vLable.text = @"23453253242";
        }else if (indexPath.row == 3){
            vCell.textLabel.text = @"票务服务";
            UILabel *vLable = (UILabel *)[vCell.contentView viewWithTag:101];
            vLable.hidden = NO;
            vLable.text = @"23453253242";
        }
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            [self findStopStation:Nil];
        }else if (indexPath.row == 1){
            [self findGasStation:Nil];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self searchRegulations:Nil];
        }
    }else if (indexPath.section == 2){
        [self phoneCalFunction:Nil];
    }
}

#pragma mark BunessDtailMapVCDelegate
-(void)BunessDetailMapDidBack:(id)sender{
}

#pragma mark - 预先加载百度地图
-(void)addBaiduMap{
    //先加载一次地图，不然地图无法显示。
    BMKMapView *vMapView = [[BMKMapView alloc] init];
    [vMapView setFrame:CGRectMake(-40, -40, 0, 0)];
    [vMapView setHidden:YES];
    [self.view addSubview:vMapView];
}

#pragma mark 初始化地图
-(void)initMap{
    if (mDetailmap == Nil) {
        mDetailmap = [[BunessDetailMapVC alloc] init];
    }
}

#pragma mark - 其他业务点击事件
#pragma mark 查询停车场
- (IBAction)findStopStation:(id)sender {
    self.title = @"停车场";
    self.isAddedMap = YES;
    [self initMap];
    [self.view addSubview:mDetailmap.view];
    [mDetailmap searchGasAndStopStation:stStopstation];
}

#pragma mark 查询加油站
- (IBAction)findGasStation:(id)sender {
    self.isAddedMap = YES;
    self.title = @"加油站";
    [self initMap];
    [self.view addSubview:mDetailmap.view];
    [mDetailmap searchGasAndStopStation:stGasstation];
}

#pragma mark 查询违章
- (IBAction)searchRegulations:(id)sender {
    [ViewControllerManager createViewController:@"RegulationSeachVC"];
    RegulationSeachVC *vVC = (RegulationSeachVC *)[ViewControllerManager getBaseViewController:@"RegulationSeachVC"];
    [vVC initWebDataSuccess:^(NSURLResponse *response, id responseObject) {
           [ViewControllerManager showBaseViewController:@"RegulationSeachVC" AnimationType:vaDefaultAnimation SubType:0];
    }];
}

#pragma mark 查询电话
- (IBAction)phoneCalFunction:(UIButton *)sender {
    [TerminalData phoneCall:self.view PhoneNumber:CUSTOMRSERVICEPHONENUMBER];
}


@end
