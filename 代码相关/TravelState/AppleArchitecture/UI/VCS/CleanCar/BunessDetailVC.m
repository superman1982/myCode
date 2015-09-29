//
//  BunessDetailVC.m
//  CTBNewProject
//
//  Created by klbest1 on 13-12-9.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import "BunessDetailVC.h"
#import "ImageViewHelper.h"
#import "BunessDetailStorePhotoVC.h"
#import "BuneesCommentVC.h"
#import "NetManager.h"
#import "BunessIntroductionVC.h"
#import "CleanCarDetailCell.h"
#import "ElectronicBunessDetailCell.h"
#import "ElectronicBunessDetailNoTimeCell.h"
#import "ActivityRouteManeger.h"
#import "AgentBunessDetailCell.h"
#import "ActivityRouteManeger.h"
#import "UserManager.h"
#import "BunessDetailProductInfo.h"
#import "ShoppingCartVC.h"

@interface BunessDetailVC ()
{
    NSDictionary *mBunessDataDic;   //商家信息
    CGRect mTableRect;
    BunessDetailMapVC *mBunessDetailMapVC;
}

@property (nonatomic,retain) NSMutableArray *serviceArray;
@property (nonatomic,assign)     BOOL         isAddedMap;

@end

@implementation BunessDetailVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
     self = [super initWithNibName:@"BunessDetailVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"BunessDetailVC" bundle:aBuddle];
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
    self.title = @"商家详情";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"购物车" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 60, 44)];
    [vRightButton addTarget:self action:@selector(purchaseCarButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

//初始化数据
-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_serviceArray removeAllObjects],[_serviceArray release];
    [mBunessDataDic release];
    [_detailTableView release];
    [_distanceLable release];
    [_bunessName release];
    [_renZhenImageView release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView: (BOOL) aPortait {
    [self clearUI];
    [self setBUnessDetailUI];
    mTableRect = self.detailTableView.frame;
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
    }else{
    }
}

//------------------------------------------------

-(void)back{
    if (self.isAddedMap) {
        UIView *vView = [self.view viewWithTag:1000];
        [vView removeFromSuperview];
        self.isAddedMap = NO;
    }else{
        //商家详情页面返回，通知地图刷新
        if ([_delegate respondsToSelector:@selector(didBunessDetailVCBackClicked:)]) {
            [_delegate didBunessDetailVCBackClicked:Nil];
        }
        [super back];
    }
}
-(void)setBunessDetailData:(NSDictionary *)aData{
    
    mBunessDataDic = Nil;
    mBunessDataDic = [[NSDictionary alloc] initWithDictionary:aData];
//    dispatch_async(dispatch_get_main_queue(), ^{
    
//    });
}

-(void)setServiceArray:(NSMutableArray *)serviceArray{
    if (_serviceArray == Nil) {
        _serviceArray = [[NSMutableArray alloc] init];
    }
    [_serviceArray addObjectsFromArray:serviceArray];
//    [self.detailTableView reloadData];
}

-(void)setIsAddedMap:(BOOL)isAddedMap{
    _isAddedMap = isAddedMap;
    if (isAddedMap) {
        self.title = self.shangJiaInfo.name;
    }else{
        self.title = @"商家详情";
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   if(section == 0){
        return 10;
    }else if(section == 1){
        return 10;
    }else if(section == 2){
        return 10;
    }else if(section == 3){
        return 40;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3){
        BunessDetailProductInfo *vInfo = [self.serviceArray objectAtIndex:indexPath.row];
        ElectronicBunessDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ElectronicBunessDetailCell" owner:self options:nil] objectAtIndex:0];
        float vHeihgt = [cell setHeigtOfCell:vInfo];
        return vHeihgt;
        
    }
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 3){
        return @"商品/服务";
    }
    return @"";
}

#pragma mark tableview headerview背景
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    UILabel *vTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 21)];
    vTitleLable.backgroundColor = [UIColor clearColor];
    [vTitleLable setFont:[UIFont systemFontOfSize:15]];
    vTitleLable.textColor = [UIColor darkGrayColor];
     if (section == 3){
        vTitleLable.text = @"商品/服务";
        [headerView addSubview:vTitleLable];
    }
    SAFE_ARC_AUTORELEASE(vTitleLable);
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        if (self.serviceArray.count == 0) {
            [tableView setFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, 320, 44*3+30)];
            [tableView setScrollEnabled:NO];
        }else{
            [tableView setFrame:CGRectMake(self.detailTableView.frame.origin.x, self.detailTableView.frame.origin.y, 320, mTableRect.size.height)];
            [tableView setScrollEnabled:YES];
        }
        return self.serviceArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 3) {
        
        static NSString *vCellIdentify = @"myCell";
        UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
        if (vCell == nil) {
            vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
            vCell.textLabel.font = [UIFont systemFontOfSize:15];
            vCell.textLabel.textColor = [UIColor darkGrayColor];
            vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        if (indexPath.section == 0){
            if (indexPath.row == 0) {
                vCell.textLabel.text = @"商家介绍";
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                vCell.textLabel.text = @"相册";
               
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                vCell.textLabel.text = @"商家评价";
                
            }
        }
        return vCell;
    }else if (indexPath.section == 3){
        BunessDetailProductInfo *vInfo = [self.serviceArray objectAtIndex:indexPath.row];
        ElectronicBunessDetailCell *cell = Nil;
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ElectronicBunessDetailCell" owner:self options:nil] objectAtIndex:0];
            }
            [cell setCell:vInfo];
            cell.delegate = self;
            return cell;
        }
    return Nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self gotoBunessIntroductionVC];
    }else if (indexPath.section == 1){
        [self gotoBunessPhtotos];
    }else if (indexPath.section == 2){
        [self gotoBunessCommentVC];
    }
}

#pragma mark ElectronicBunessDetailCellDelegate
-(void)didElectronicBunessDetailCellOrderAmountChanged:(BunessDetailProductInfo *)aInfo{
    [self replaceProductsInfoOnRow:aInfo];
}

#pragma mark ElectronicBunessDetailNoTimeCellDelegate
#pragma mark 订购数量发生变化，更新列表中得数据
-(void)didElectronicBunessDetailNoTimeCellOrderAmountChanged:(BunessDetailProductInfo *)aInfo{
      [self replaceProductsInfoOnRow:aInfo];
}

#pragma mark - 其他辅助功能
#pragma mark 分解产品信息
-(BunessDetailProductInfo *)getProductInfo:(NSDictionary *)aDic{
    BunessDetailProductInfo *vProInfo = [[BunessDetailProductInfo alloc] init];
    vProInfo.serviceType = [aDic objectForKey:@"serviceType"];
    IFISNILFORNUMBER(vProInfo.serviceType);
    
    vProInfo.standardServiceType = [aDic objectForKey:@"standardServiceType"];
    IFISNILFORNUMBER(vProInfo.standardServiceType);
    
    vProInfo.serviceId = [aDic objectForKey:@"serviceId"];
    IFISNIL(vProInfo.serviceId);
    
    vProInfo.servicePhoto = [aDic objectForKey:@"servicePhoto"];
    IFISNIL(vProInfo.servicePhoto);
    
    vProInfo.serviceName = [aDic objectForKey:@"serviceName"];
    IFISNIL(vProInfo.serviceName);
    
    vProInfo.serviceDesc = [aDic objectForKey:@"serviceDesc"];
    IFISNIL(vProInfo.serviceDesc);
    
    vProInfo.price = [aDic objectForKey:@"price"];
    IFISNILFORNUMBER(vProInfo.price);
    
    vProInfo.vipPrice = [aDic objectForKey:@"vipPrice"];
    IFISNILFORNUMBER(vProInfo.vipPrice);
    
    vProInfo.returnMoney = [aDic objectForKey:@"returnMoney"];
    IFISNILFORNUMBER(vProInfo.returnMoney);
    
    vProInfo.isDiscount = [aDic objectForKey:@"isDiscount"];
    IFISNILFORNUMBER(vProInfo.isDiscount);
    
    vProInfo.beginDateTime = [aDic objectForKey:@"beginDateTime"];
    IFISNIL(vProInfo.beginDateTime);
    
    vProInfo.endDateTime = [aDic objectForKey:@"endDateTime"];
    IFISNIL(vProInfo.endDateTime);
    
    vProInfo.orderNumber = [NSNumber numberWithInt:1];
    
    SAFE_ARC_AUTORELEASE(vProInfo);
    return vProInfo;
}

-(void)replaceProductsInfoOnRow:(BunessDetailProductInfo *)aInfo{
    NSNumber *vReplaceIndex = Nil;
    for (NSInteger vIndex  = 0; vIndex < self.serviceArray.count; vIndex ++) {
        BunessDetailProductInfo *vInfo = [self.serviceArray objectAtIndex:vIndex];
        if ([vInfo.serviceId isEqualToString:aInfo.serviceId]) {
            vReplaceIndex = [NSNumber numberWithInt:vIndex];
        }
    }
    if (vReplaceIndex != Nil) {
        [self.serviceArray replaceObjectAtIndex:[vReplaceIndex intValue] withObject:aInfo];
        [self.detailTableView reloadData];
    }
}

#pragma mak 清空UI
-(void)clearUI{
    
    self.bunessName.text = @"";
    self.phoneLable.text = @"";
    //商家地址
    self.addressLable.text = @"";
    //距离
    self.distanceLable.text = @"";;
}
-(void)setBUnessDetailUI{
    //门头照
    NSString *headURLStr = [mBunessDataDic objectForKey:@"photo"];
    [_bunessHeadPhotoImageView setImageWithURL:[NSURL URLWithString:headURLStr] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
    self.bunessName.text = [mBunessDataDic objectForKey:@"name"];
    IFISNIL(self.bunessName.text);
    //是否认证
    id isauthenticate = [mBunessDataDic objectForKey:@"isauthenticate"];
    if ([isauthenticate intValue] == 0) {
        self.renZhenImageView.hidden = YES;
    }else{
        self.renZhenImageView.hidden = NO;
    }
    //星级
    id startStr = [mBunessDataDic objectForKey:@"stars"];
    [ActivityRouteManeger addStarsToView:self.startImageView StarNumber:[startStr intValue]];
    
    [self.startImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%@",startStr]]];
    //电话
    NSString *phoneStr = [mBunessDataDic objectForKey:@"phone"];
    phoneStr = phoneStr.length > 0 ? phoneStr : @"";
    _phoneLable.text = phoneStr;
    
    //地址
    NSString *addressStr = [mBunessDataDic objectForKey:@"address"];
    addressStr = addressStr.length > 0 ? addressStr : @"";
    _addressLable.text = addressStr;
    //距离
    NSInteger vDistance = self.shangJiaInfo.distance;
    if (vDistance > 1000) {
        NSString *distanceStr = [NSString stringWithFormat:@"%.2f公里",vDistance/1000.0];
        self.distanceLable.text = distanceStr;
    }else
    {
        NSString *distanceStr = [NSString stringWithFormat:@"%d米",vDistance];
        self.distanceLable.text = distanceStr;
    }
    //获取服务项目
    NSDictionary *vServiceDic = [mBunessDataDic objectForKey:@"business_service"];
    NSMutableArray *vServiceArray = [NSMutableArray array];
    for (NSDictionary *vDic in vServiceDic) {
        BunessDetailProductInfo *vInfo = [self getProductInfo:vDic];
        vInfo.businessId = [mBunessDataDic objectForKey:@"businessId"];
        [vServiceArray addObject:vInfo];
    }
    self.serviceArray = vServiceArray;
}

#pragma mark - 业务点击事件
#pragma mark 商家相册
-(void)gotoBunessPhtotos{
    [ViewControllerManager createViewController:@"BunessDetailStorePhotoVC"];
    BunessDetailStorePhotoVC *vBunessDetailStorePhtotVC = (BunessDetailStorePhotoVC *)[ViewControllerManager getBaseViewController:@"BunessDetailStorePhotoVC"];
    vBunessDetailStorePhtotVC.shangJiaInfo = self.shangJiaInfo;
    [ViewControllerManager showBaseViewController:@"BunessDetailStorePhotoVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 查看商家评论
-(void)gotoBunessCommentVC{
    [ViewControllerManager createViewController:@"BuneesCommentVC"];
    BuneesCommentVC *vBunessCommentVC = (BuneesCommentVC *)[ViewControllerManager getBaseViewController:@"BuneesCommentVC"];
    vBunessCommentVC.shangJiaInfo = self.shangJiaInfo;
    [ViewControllerManager showBaseViewController:@"BuneesCommentVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 查看商家介绍
-(void)gotoBunessIntroductionVC{
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys: self.shangJiaInfo.bunessId,@"businessId",nil];
    [NetManager postDataFromWebAsynchronous:APPURL902 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSString *vURLStr = @"";
        if (vDataDic.count > 0) {
            vURLStr = [vDataDic objectForKey:@"content"];
        }
        [ViewControllerManager createViewController:@"BunessIntroductionVC"];
        BunessIntroductionVC *vBunessIntroductionVC = (BunessIntroductionVC *)[ViewControllerManager getBaseViewController:@"BunessIntroductionVC"];
        vBunessIntroductionVC.introductionURLStr = vURLStr;
        [ViewControllerManager showBaseViewController:@"BunessIntroductionVC" AnimationType:vaDefaultAnimation SubType:0];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"请求商家介绍" Notice:@""];
}

#pragma mark - 业务点击事件

- (IBAction)phoneButtonClicked:(id)sender {
    UIWebView *lWeb = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [lWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneLable.text]]]];
    lWeb.hidden = YES;
    [self.view addSubview:lWeb];
    lWeb = nil;
}

- (IBAction)routeLineButtonClicked:(id)sender {
    
    double vLongtitude = [[mBunessDataDic objectForKey:@"longitude"] doubleValue];
    double vLatitude = [[mBunessDataDic objectForKey:@"latitude"] doubleValue];
    CLLocationCoordinate2D vBunesspt = CLLocationCoordinate2DMake(vLatitude, vLongtitude);
    CLLocationCoordinate2D vUserPt = [UserManager instanceUserManager].userCoord;
    [ActivityRouteManeger gotoBaiMapApp:vUserPt EndLocation:vBunesspt];
}

- (IBAction)addressButtonClicked:(id)sender {
    self.isAddedMap = YES;
    if (mBunessDetailMapVC == Nil) {
        mBunessDetailMapVC = [[BunessDetailMapVC alloc] init];
        [mBunessDetailMapVC.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        mBunessDetailMapVC.delegate = self;
        [mBunessDetailMapVC.view setTag:1000];
    }
    [mBunessDetailMapVC setBunessMapData:self.shangJiaInfo SearchType:self.searchType];
    [self.view addSubview:mBunessDetailMapVC.view];

}

-(void)BunessDetailMapDidBack:(id)sender{
}

-(void)purchaseCarButtonTouchDown:(id)sender{
    [ViewControllerManager createViewController:@"ShoppingCartVC"];
    ShoppingCartVC *vVC = (ShoppingCartVC *)[ViewControllerManager getBaseViewController:@"ShoppingCartVC"];
    vVC.isNeedToResetUI = YES;
    [ViewControllerManager showBaseViewController:@"ShoppingCartVC" AnimationType:vaDefaultAnimation SubType:0];
}
- (void)viewDidUnload {
    [self setStartImageView:nil];
    [self setPhoneLable:nil];
    [self setAddressLable:nil];
    [self setDetailTableView:nil];
    [self setDistanceLable:nil];
    [self setBunessName:nil];
    [self setRenZhenImageView:nil];
    [super viewDidUnload];
}
@end
