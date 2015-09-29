//
//  ScenicDetailVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-24.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectronicSiteInfo.h"

@protocol ScenicDetailVCDelegate <NSObject>
//返回时重新刷新地图
-(void)didBackToVCClicked:(BOOL)sender;

@end

@interface ScenicDetailVC : BaseViewController<UIWebViewDelegate>

//到这里去button
@property (retain, nonatomic) IBOutlet UIButton *comeToThePlaceButton;
@property (retain, nonatomic) IBOutlet UIButton *nearByBunessButton;

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIWebView *detailWebView;

//保存活动详情信息
@property (nonatomic,retain) ElectronicSiteInfo *electronicInfo;

@property (nonatomic,assign) id <ScenicDetailVCDelegate> delegate;

@end
