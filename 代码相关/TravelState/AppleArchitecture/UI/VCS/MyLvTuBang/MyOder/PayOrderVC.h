//
//  PayOrderVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-8.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

@interface PayOrderVC : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *payOrderTableview;
@property (nonatomic,retain) OrderInfo *oderInfo;

@end
