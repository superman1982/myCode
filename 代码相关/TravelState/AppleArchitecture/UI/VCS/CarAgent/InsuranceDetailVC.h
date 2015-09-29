//
//  InsuranceDetailVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-5-8.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsuranceDetailVC : BaseViewController

@property (strong, nonatomic) IBOutlet UITextView *insuranceDescTextView;
@property (nonatomic,assign) NSInteger chosedTag;
//投保后的提示
@property (retain, nonatomic) IBOutlet UIView *IneedInsuranceNoticeView;

@property (strong, nonatomic) IBOutlet UIView *noticeContentView;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@end
