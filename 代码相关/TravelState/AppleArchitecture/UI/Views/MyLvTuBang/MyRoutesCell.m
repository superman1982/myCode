//
//  MyRoutesCell.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-5.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyRoutesCell.h"
#import "UIImageView+AFNetworking.h"
#import "ActiveBookVC.h"
#import "ActivityRouteManeger.h"
#import "ActiveCommentVC.h"
#import "UserManager.h"

@implementation MyRoutesCell

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

-(void)setCellButtonType:(MyActiveButtonType)cellButtonType{
    _cellButtonType = cellButtonType;
    if (_cellButtonType == btMyActiveBook) {
        [self.BookAndDownLoadButton setTitle:@"补充报名" forState:UIControlStateNormal];
    }else if (_cellButtonType == btMyActiveEnd){
        [self.BookAndDownLoadButton setTitle:@"活动结束" forState:UIControlStateNormal];
    }
}

-(void)setCell:(ActiveInfo *)aActiInfo{
    if (aActiInfo == Nil) {
        return;
    }
    self.activeInfo = aActiInfo;
    
    NSInteger vIsOffical = [aActiInfo.isOfficial intValue];
    if (vIsOffical == 1) {
        self.officalImageView.hidden = NO;
    }
    [self setLableCount:aActiInfo];
    
    self.routeTitle.text = aActiInfo.activeTitle;
    self.startTimeLable.text = [NSString stringWithFormat:@"出发时间:%@",aActiInfo.activeTime];

    [self.activeImageView setImageWithURL:[NSURL URLWithString:aActiInfo.activeImages] placeholderImage:[UIImage imageNamed:@"lvtubangretangle.png"]];
//    if (self.activeInfo.type == atActiveRoutes) {
//        //查看路数是否过期，过期直接为活动结束
//        if (mDateFormatter == Nil) {
//            mDateFormatter = [[NSDateFormatter alloc] init];
//            [mDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        }
//        NSDate *vActiveEndDate = [mDateFormatter dateFromString:aActiInfo.signupEndDate];
//        NSDate *vEarlyDate = [vActiveEndDate earlierDate:[NSDate date]];
//        if ([vEarlyDate isEqualToDate:vActiveEndDate]) {
//            self.cellButtonType = btMyActiveEnd;
//        }else{
//            self.cellButtonType = btMyActiveBook;
//        }
//    }
}

-(void)setLableCount:(ActiveInfo *)aInfo{
    NSString *vPingStr = [NSString stringWithFormat:@"%@ 评",aInfo.comentCount];
    self.pingLable.text = vPingStr;
    NSString *vZanStr = [NSString stringWithFormat:@"%@ 赞",aInfo.praiseCount ];
    self.zanLable.text = vZanStr;
    NSString *vShareStr = [NSString stringWithFormat:@"%@ 享",aInfo.shareCount];
    self.shareLable.text = vShareStr;
}


#pragma mark 其他业务点击事件
- (IBAction)bookAndDownLoadButtonClicked:(id)sender {

    if (self.cellButtonType == btMyActiveBook) {
        
        [ViewControllerManager createViewController:@"ActiveBookVC"];
        ActiveBookVC *vVC = (ActiveBookVC *)[ViewControllerManager getBaseViewController:@"ActiveBookVC"];
        vVC.activinfo = self.activeInfo;
        //添加报名
        vVC.signupType = 1;
        [ViewControllerManager showBaseViewController:@"ActiveBookVC" AnimationType:vaDefaultAnimation SubType:0];
        
        //获取单次报名总人数
        NSNumber *vActiviID = self.activeInfo.ActivityId;
        NSString *vActiviIDStr = [NSString stringWithFormat:@"%@",vActiviID];
        id vtotalSignup = self.activeInfo.totalSignup;
        //服务器在我的行程中没有返回单次报名人数，因此暂定为10
        if ([vtotalSignup intValue] ==0) {
            vtotalSignup = [NSNumber numberWithInt:10];
        }
        //储存单次报名总人数
        NSDictionary *vSingnupDic = [NSDictionary dictionaryWithObjectsAndKeys:vtotalSignup,BOOKEDPEOPLEKEY, nil];
        //根据不同活动ID储存相应报名人数信息
        [[ActivityRouteManeger shareActivityManeger].bookPeopleDic setObject:vSingnupDic forKey:vActiviIDStr];
        LOG(@"本次报名房差:%@,允许的最大报名人数:%@,保单价:%@",self.activeInfo.lodingMoney,vtotalSignup,self.activeInfo.insuranceMone);
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



@end
