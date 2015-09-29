//
//  RegulationAddCarVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarTypeVC.h"
#import "RegulationChoseCityVC.h"

@interface RegulationAddCarVC : BaseViewController<UITextFieldDelegate,CarTypeVCDelegate,RegulationChoseCityVCDelegate>

@property (nonatomic,retain) NSDictionary *carDic;
@property (strong, nonatomic) IBOutlet UITableView *regulationAddCarVCTableView;

@end
