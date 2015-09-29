//
//  FillPeopleInfoVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChosePickerVC.h"
#import "ActiveInfo.h"

@protocol FillPeopleInfoVCDelegate <NSObject>
-(void)didFinishPeopleInfo:(id)sender;
@end

@interface FillPeopleInfoVC : BaseViewController<UITextFieldDelegate,ChosePickerVCDelegate>
@property (retain, nonatomic) IBOutlet ClickableTableView *fillInfoTableView;

@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
//报名数量
@property (retain, nonatomic) IBOutlet UILabel *peopleCountLable;
//选择性别
@property (retain, nonatomic) IBOutlet ChosePickerVC *peopleChoseSexView;

@property (nonatomic,assign) id<FillPeopleInfoVCDelegate> delegate;

@property (nonatomic,retain) ActiveInfo *activeInfo;

@end
