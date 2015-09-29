//
//  AddJiaoQiangXiangVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseDateVC.h"
#import "TakePhotoTool.h"
#import "ChoseProvinceCityVC.h"
#import "InsuranceInfo.h"
#import "IDCardCell.h"

@protocol AddJiaoQiangXiangVCDelegate <NSObject>

-(void)didAddJiaoQiangXiangFinished:(id)sender;
@end

@interface AddJiaoQiangXiangVC : BaseViewController<UITextFieldDelegate,ChoseDateVCDelegate,TakePhotoToolDelegate,ChoseProvinceCityVCDelegate,IDCardCellDelegate>

@property (nonatomic,assign) BOOL isAddJiaoQiangXian;

@property (nonatomic,retain) InsuranceInfo *insuranceInfo;

@property (nonatomic,retain) id<AddJiaoQiangXiangVCDelegate> delegate;

@property (retain, nonatomic) IBOutlet ClickableTableView *jiaoQiangXianTableView;

@end
