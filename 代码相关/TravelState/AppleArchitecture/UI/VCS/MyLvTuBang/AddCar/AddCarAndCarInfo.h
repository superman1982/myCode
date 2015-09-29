//
//  AddCarAndCarInfo.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseDateVC.h"
#import "TakePhotoTool.h"
#import "ClickableTableView.h"
#import "IDCardCell.h"
#import "CarTypeVC.h"
#import "AddCarAndCarInfo.h"


@protocol AddCarAndCarInfoDelegate <NSObject>
@optional
-(NSString *)titleForHeaderView:(id)sender;
-(NSInteger)heightForHeaderViewInSectionOne:(id)sender;
-(void)didAddCarAndCarInfoFinished:(id)sender;
@end

@interface AddCarAndCarInfo : BaseViewController<ChoseDateVCDelegate,TakePhotoToolDelegate,UITextFieldDelegate,ClickableTableViewDelegate,IDCardCellDelegate,CarTypeVCDelegate,AddCarAndCarInfoDelegate>
//我的爱车tabliew
@property (retain, nonatomic) IBOutlet ClickableTableView *carInfoTableView;

@property (nonatomic,retain) id<AddCarAndCarInfoDelegate> delegate;

//设为默认车辆FooterView
@property (retain, nonatomic) IBOutlet UIView *footerViewForDefaultCar;
//我的爱车信息HeaderView
@property (retain, nonatomic) IBOutlet UIView *headerViewForCarInfo;
//是否是添加车辆
@property (nonatomic,assign)  BOOL isAddCar;
//添加爱车是的HeaderView
@property (retain, nonatomic) IBOutlet UIView *headerViewForAddCar;

@property (retain, nonatomic) IBOutlet UIView *contentView;
//默认车辆CheckButton
@property (strong, nonatomic) IBOutlet UIButton *defaultCheckButton;

//爱车详情信息
@property (nonatomic,retain)  NSMutableDictionary *carDic;

@end
