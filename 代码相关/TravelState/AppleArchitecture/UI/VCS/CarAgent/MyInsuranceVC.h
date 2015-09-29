//
//  MyInsuranceVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddBunessInuranceVC.h"
#import "AddJiaoQiangXiangVC.h"

@interface MyInsuranceVC : BaseViewController<AddBunessInuranceVCDelegate,AddJiaoQiangXiangVCDelegate>

@property (retain, nonatomic) IBOutlet UITableView *insuranceTableView;
@property (retain, nonatomic) IBOutlet UIButton *bunessButton;
@property (retain, nonatomic) IBOutlet UIButton *jiaoQiangButton;
@property (strong, nonatomic) IBOutlet UILabel *addInsuranceLable;
@end
