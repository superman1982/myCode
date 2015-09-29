//
//  SelfDriveCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "SelfDriveCell.h"
//#import "UIImageView+AFNetworking.h"
#import "ElectronicBookManeger.h"
#import "ConfigFile.h"
#import "ActiveBookVC.h"
#import "ActivityRouteManeger.h"
#import "ElectronicRouteBookVC.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "SelfTravelVC.h"
#import "ActiveCommentVC.h"
#import "LoginVC.h"
#import "RootTabBarVC.h"
#import "StringHelper.h"
#import "ActiveDetailVC.h"
#import "ImageViewHelper.h"

@implementation SelfDriveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellButtonType:(ButtonType)cellButtonType{
    _cellButtonType = cellButtonType;
    if (_cellButtonType == btBook) {
        [self.BookAndDownLoadButton setTitle:@"报名" forState:UIControlStateNormal];
    }else if (_cellButtonType == btCheckRoutes){
        [self.BookAndDownLoadButton setTitle:@"查看路书" forState:UIControlStateNormal];
    }else if (_cellButtonType == btDownload)
    {
        [self.BookAndDownLoadButton setTitle:@"下载路书" forState:UIControlStateNormal];
    }else if (_cellButtonType == btDownloading){
        [self.BookAndDownLoadButton setTitle:@"下载中..." forState:UIControlStateNormal];
    }else if (_cellButtonType == btActiveEnd){
        [self.BookAndDownLoadButton setTitle:@"活动结束" forState:UIControlStateNormal];
    }
}

-(void)setCell:(ActiveInfo *)aActiInfo{
    if (aActiInfo == Nil) {
        return;
    }
    self.activeInfo = aActiInfo;
    
    [self addNotification];
    NSInteger vIsOffical = [aActiInfo.isOfficial intValue];
    if (vIsOffical == 1) {
        self.officalImageView.hidden = NO;
    }
    [self setLableCount:aActiInfo];
    
    self.routeTitle.text = aActiInfo.activeTitle;
    self.startTimeLable.text = [NSString stringWithFormat:@"出发时间:%@",aActiInfo.activeTime];
    self.lvTuBangPriceLable.text = [NSString stringWithFormat:@"%@",aActiInfo.memberPrice ];
    self.OriginPriceLable.text = [NSString stringWithFormat:@"%@",aActiInfo.listingPrice];
    self.bookPeopleLable.text = [NSString stringWithFormat:@"已报名: %@人",aActiInfo.singupNumber];
//    [self.activeImageView setImageWithURL:[NSURL URLWithString:aActiInfo.activeImages] placeholderImage:[UIImage imageNamed:@"lvtubangretangle.png"]];
    [self.activeImageView setImageWithURL:[NSURL URLWithString:aActiInfo.activeImages] PlaceHolder:[UIImage imageNamed:@"lvtubangretangle.png" ]];
    self.roadBookUrl = aActiInfo.rouadBookURL;
    
    if (self.activeInfo.type == atActiveRoutes) {
        self.cellButtonType = btBook;
        //已报名，改为补充报名
        if ([aActiInfo.isSignup intValue] == 1) {
            [self.BookAndDownLoadButton setTitle:@"补充报名" forState:UIControlStateNormal];
        }
        //查看路数是否过期，过期直接为活动结束
        if (mDateFormatter == Nil) {
            mDateFormatter = [[NSDateFormatter alloc] init];
            [mDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        NSDate *vActiveEndDate = [mDateFormatter dateFromString:aActiInfo.signupEndDate];
        NSDate *vEarlyDate = [vActiveEndDate earlierDate:[NSDate date]];
        if ([vEarlyDate isEqualToDate:vActiveEndDate]) {
            self.cellButtonType = btActiveEnd;
        }
        
        //没有登录显示为报名
        if (![UserManager isLogin]) {
            self.cellButtonType = btBook;
        }
    }else{
        self.cellButtonType = btDownload;
        //查看配置文件，检查路书是否被下载，如果已下载显示查看路书
        NSDictionary *vConfigDic = [ConfigFile readConfigDictionary];
        NSString *vKey = [NSString stringWithFormat:@"%@",aActiInfo.ActivityId];
        NSString *vIfIsDownLoad = [vConfigDic objectForKey:vKey];
        if (vIfIsDownLoad != nil) {
            self.cellButtonType = btCheckRoutes;
        }
    }
}

-(void)setLableCount:(ActiveInfo *)aInfo{
    NSString *vPingStr = [NSString stringWithFormat:@"%@ 评",aInfo.comentCount];
    self.pingLable.text = vPingStr;
    NSString *vZanStr = [NSString stringWithFormat:@"%@ 赞",aInfo.praiseCount ];
    self.zanLable.text = vZanStr;
    NSString *vShareStr = [NSString stringWithFormat:@"%@ 享",aInfo.shareCount];
    self.shareLable.text = vShareStr;
}

#pragma mark - 其他辅助功能
#pragma mark 添加通知
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(electronicBookDidDownloadSucces:) name:@"electronicBookDidDownloadSucces" object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(electronicBookDidDownloadFailure:) name:@"electronicBookDidDownloadFailure" object:Nil];
}

#pragma mark 移除通知
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 通知方法
#pragma mark 下载成功
-(void)electronicBookDidDownloadSucces:(NSNotification *)aNotifi{
    //下载完成，改变下载button为查看
    if ([aNotifi.name isEqualToString:@"electronicBookDidDownloadSucces"]) {
        NSString *vNotifiObject =aNotifi.object;
        NSString *vActiviID = [NSString stringWithFormat:@"%@",self.activeInfo.ActivityId];
        if ([vNotifiObject isEqualToString:vActiviID]) {
            _isDownloading = NO;
            self.cellButtonType = btCheckRoutes;
            
           ActiveDetailVC *vVC =(ActiveDetailVC *) [ViewControllerManager getBaseViewController:@"ActiveDetailVC"];
            vVC.cellButtonType = btCheckRoutes;
        }
    }
}

#pragma mark 下载失败
-(void)electronicBookDidDownloadFailure:(NSNotification *)aNotifi{
    //下载失败，改变正在下载button为下载
    if ([aNotifi.name isEqualToString:@"electronicBookDidDownloadFailure"]) {
        if (self.cellButtonType == btDownloading) {
            _isDownloading = NO;
            self.cellButtonType = btDownload;
            ActiveDetailVC *vVC =(ActiveDetailVC *) [ViewControllerManager getBaseViewController:@"ActiveDetailVC"];
            vVC.cellButtonType = btDownload;
        }
    }
}

#pragma mark 推荐路数界面调整
-(void)setRecommendRoutesUI{
    self.lvTuBangPriceLable.hidden = YES;
    self.OriginPriceLable.hidden = YES;
    self.startTimeLable.hidden = YES;
    self.bookPeopleLable.hidden = YES;
    
    [self.routeTitle setNumberOfLines:0];
    CGSize vTitleSize = [StringHelper caluateStrLength:self.routeTitle.text Front:self.routeTitle.font ConstrainedSize:CGSizeMake(self.routeTitle.frame.size.width, 45)];
    [self.routeTitle setFrame:CGRectMake(self.routeTitle.frame.origin.x, 10, self.routeTitle.frame.size.width, vTitleSize.height)];
    self.lvtuBangPriceDescLable.hidden = YES;
    self.priceLineImageView.hidden = YES;
}

#pragma mark 活动路书界面调整
-(void)setActiveRoteUI{
    self.lvTuBangPriceLable.hidden = NO;
    self.OriginPriceLable.hidden = NO;
    self.startTimeLable.hidden = NO;
    self.bookPeopleLable.hidden = NO;
    
    [self.routeTitle setNumberOfLines:1];
    [self.routeTitle setFrame:CGRectMake(self.routeTitle.frame.origin.x, 0, self.routeTitle.frame.size.width,21)];
    self.lvtuBangPriceDescLable.hidden = NO;
    self.priceLineImageView.hidden = NO;
}

#pragma mark 其他业务点击事件
- (IBAction)bookAndDownLoadButtonClicked:(id)sender {
    if (_cellButtonType == btBook) {
        if (![ActivityRouteManeger checkIfIsLogin]) {
            return;
        }
        [ViewControllerManager createViewController:@"ActiveBookVC"];
        ActiveBookVC *vVC = (ActiveBookVC *)[ViewControllerManager getBaseViewController:@"ActiveBookVC"];
        vVC.activinfo = self.activeInfo;
        [ViewControllerManager showBaseViewController:@"ActiveBookVC" AnimationType:vaDefaultAnimation SubType:0];
        //设置代理，以便报名成功后更新列表，变报名为下载按钮
        SelfTravelVC *vSelfTVC = (SelfTravelVC *)[ViewControllerManager getBaseViewController:@"SelfTravelVC"];
        vVC.delegate = vSelfTVC;
        
        //获取单次报名总人数
        NSNumber *vActiviID = self.activeInfo.ActivityId;
        NSString *vActiviIDStr = [NSString stringWithFormat:@"%@",vActiviID];
        id vtotalSignup = self.activeInfo.totalSignup;
        //如果报名可以包含自己，那么单次报名总人数减1
        if ([self.activeInfo.isIncludeSelf intValue] == 1) {
            NSInteger vTotalInteger = [vtotalSignup intValue];
            vTotalInteger--;
            vtotalSignup = [NSNumber numberWithInt:vTotalInteger];
        }
        IFISNIL(vtotalSignup);
        //储存单次报名总人数
        NSDictionary *vSingnupDic = [NSDictionary dictionaryWithObjectsAndKeys:vtotalSignup,BOOKEDPEOPLEKEY, nil];
        //根据不同活动ID储存相应报名人数信息
        [[ActivityRouteManeger shareActivityManeger].bookPeopleDic setObject:vSingnupDic forKey:vActiviIDStr];
        LOG(@"本次报名房差:%@,允许的最大报名人数:%@,保单价:%@",self.activeInfo.lodingMoney,vtotalSignup,self.activeInfo.insuranceMone);
        
    }else if (_cellButtonType == btCheckRoutes){
        //获得电子路书路线信息
        NSDictionary *vElectronicDic = [ElectronicBookManeger getElectronicBookInfo:self.roadBookUrl];
        NSDictionary *vRouteDic = [vElectronicDic objectForKey:ROUTEDICKEY];
        if (vRouteDic != Nil) {
            [ViewControllerManager createViewController:@"ElectronicRouteBookVC"];
            ElectronicRouteBookVC *vVC = (ElectronicRouteBookVC *)[ViewControllerManager getBaseViewController:@"ElectronicRouteBookVC"];
            //设置电子路书路线
            vVC.electronicDic = vElectronicDic;
            vVC.routesType = self.activeInfo.type;
            vVC.leaderPhone = self.activeInfo.leaderPhone;
            [ViewControllerManager showBaseViewController:@"ElectronicRouteBookVC" AnimationType:vaDefaultAnimation SubType:0];
        }else{
            [SVProgressHUD showErrorWithStatus:@"电子路书路径Json解析失败！"];
        }
    }else if (_cellButtonType == btDownload){
        self.isDownloading = YES;
        self.cellButtonType = btDownloading;
        [ElectronicBookManeger downLoadElectroniBook:self.roadBookUrl IsSynchronous:NO ModifyTime:self.activeInfo.roadBookModifyTime];
    }

}

#pragma mark 评论
- (IBAction)commentButtonClicked:(id)sender {
    [ViewControllerManager createViewController:@"ActiveCommentVC"];
        ActiveCommentVC *vVC = (ActiveCommentVC *)[ViewControllerManager getBaseViewController:@"ActiveCommentVC"];
    vVC.activeInfo = self.activeInfo;
    [ViewControllerManager showBaseViewController:@"ActiveCommentVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark 点赞
- (IBAction)zanButtonClicked:(id)sender {
    if (![ActivityRouteManeger checkIfIsLogin]) {
        return;
    }
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vPagemeter = [NSDictionary dictionaryWithObjectsAndKeys:vUserID,@"userId",self.activeInfo.ActivityId,@"activityId", nil];
    [ActivityRouteManeger postSharePraseCommentData:APPURL403 Paremeter:vPagemeter Prompt:@"" RequestName:@"赞" ];
}

#pragma mark 分享
- (IBAction)shareButtonClicked:(id)sender {
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:self.activeInfo.ActivityId,@"activityId", nil];
    NSString *vContentStr = [NSString stringWithFormat:@"旅途邦：%@ %@",self.activeInfo.activeTitle,self.activeInfo.activityURL];
    [ActivityRouteManeger showShare:@"旅途邦" Content:vContentStr Paremeter:vParemeter ShareType:stActivity];
}

- (IBAction)cellClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(didSelfDriveCellClicked:)]) {
        [_delegate didSelfDriveCellClicked:[NSNumber numberWithInt:self.tag]];
    }
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [self removeNotification];
    [self.activeInfo release];
    [_BookAndDownLoadButton release];
    [_view release];
    [_zanButton release];
    [_shareButton release];
    [_routeTitle release];
    [_startTimeLable release];
    [_lvTuBangPriceLable release];
    [_OriginPriceLable release];
    [_bookPeopleLable release];
    [_activeImageView release];
    [_officalImageView release];
    [_pingButton release];
    [super dealloc];
}
#endif
@end
