//
//  AddBunessInuranceVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseDateVC.h"
#import "TakePhotoTool.h"
#import "InsuranceInfo.h"
#import "IDCardCell.h"

@protocol  AddBunessInuranceVCDelegate <NSObject>

-(void)didAddBunessInuranceSucces:(id)sender;

@end

@interface AddBunessInuranceVC : BaseViewController<UITextFieldDelegate,ChoseDateVCDelegate,TakePhotoToolDelegate,IDCardCellDelegate>

@property (nonatomic,assign) BOOL isAddBunessInsurance;
@property (nonatomic,assign) InsuranceInfo *insuranceInfo;
@property (retain, nonatomic) IBOutlet ClickableTableView *bunessTableView;
@property (nonatomic,retain) id<AddBunessInuranceVCDelegate> delegate;

@end
