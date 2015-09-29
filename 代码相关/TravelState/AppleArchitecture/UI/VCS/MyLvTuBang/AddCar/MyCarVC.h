//
//  MyCarVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCarAndCarInfo.h"

@interface MyCarVC : BaseViewController<AddCarAndCarInfoDelegate>

//我的爱车
@property (retain, nonatomic) IBOutlet UITableView *myCarTableView;
@property (nonatomic,retain) NSMutableArray *myCarArray;

#pragma mark - 其他辅助功能
-(void)initWebDataComplete:(void (^)(id responseObject))aComPlete;

#pragma mark - 爱车详情
-(void)getCarDetail:(id )aCarId Complete:(void (^)(id responseObject))aComPlete;

@end
