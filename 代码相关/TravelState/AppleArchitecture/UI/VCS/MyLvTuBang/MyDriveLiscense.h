//
//  MyDriveLiscense.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-15.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableTableView.h"
#import "ChoseDateVC.h"
#import "TakePhotoTool.h"
#import "NickNameVC.h"
#import "IDCardCell.h"
#import "ChoseProvinceCityVC.h"
#import "ChoseProvinceVC.h"

@interface MyDriveLiscense : BaseViewController<ChoseDateVCDelegate,TakePhotoToolDelegate,UITextFieldDelegate,NickNameVCDelegate,IDCardCellDelegate,ChoseProvinceCityVCDelegate>

@property (retain, nonatomic) IBOutlet ClickableTableView *mDriveLisenseTableVIew;

@property (nonatomic,assign) BOOL isAddDriveLisence;
//车架号头
@property (retain, nonatomic) IBOutlet UIView *HeaderForDriveLisence;

@end
