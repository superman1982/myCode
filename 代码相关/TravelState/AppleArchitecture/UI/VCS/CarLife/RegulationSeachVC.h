//
//  RegulationSeachVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCarAndCarInfo.h"

@interface RegulationSeachVC : BaseViewController<AddCarAndCarInfoDelegate>

@property (strong, nonatomic) IBOutlet UITableView *regulationTableView;

-(void)initWebDataSuccess:(void (^)(NSURLResponse *response,id responseObject))aSucces;
@end
