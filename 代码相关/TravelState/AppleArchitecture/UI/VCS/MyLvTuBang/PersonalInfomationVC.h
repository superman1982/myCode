//
//  PersonalInfomationVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ChoseDateVC.h"
//#import "TakePhotoTool.h"
#import "TakePhotoTool.h"
#import "NickNameVC.h"
#import "ChosePickerVC.h"
#import "UserInfo.h"
#import "FillSignatureVC.h"
#import "IDCardCell.h"

@protocol PersonalInfomationVCDelegate <NSObject>

-(void)didPersonalInfomationVCChanged:(id)sender;

@end

@interface PersonalInfomationVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,ChoseDateVCDelegate,TakePhotoToolDelegate,NickNameVCDelegate,ChosePickerVCDelegate,FillSignatureVCDelegate,IDCardCellDelegate>
//菜单tableView
@property (retain, nonatomic) IBOutlet UITableView *MPmenuTableView;
//选择性别
@property (retain, nonatomic) IBOutlet ChosePickerVC *choseSexView;
//选择时间
@property (retain, nonatomic) IBOutlet ChoseDateVC *choseDateVC;

@property (retain, nonatomic) IBOutlet UIView *hearViewForPersonInfo;

@property (nonatomic,retain) UserInfo *userInfo;

@property (nonatomic,assign) id<PersonalInfomationVCDelegate> delegate;
@end
