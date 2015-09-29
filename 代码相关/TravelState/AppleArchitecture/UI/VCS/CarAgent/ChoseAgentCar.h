//
//  ChoseAgentCar.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCarAndCarInfo.h"
#import "ChoseDistrictVC.h"

@interface ChoseAgentCar : BaseViewController<ChoseDistrictVCDelegate,AddCarAndCarInfoDelegate>
@property (retain, nonatomic) IBOutlet UITableView *agentCarTableView;

@property (retain, nonatomic) IBOutlet UILabel *headerLable;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerVew;
@end
