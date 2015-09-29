//
//  OrderDetailVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

@interface OrderDetailVC : BaseViewController

@property (nonatomic,retain) OrderInfo *orderInfo;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UITableView *orderTableView;
@property (strong, nonatomic) IBOutlet UILabel *amountLable;
@property (strong, nonatomic) IBOutlet UILabel *totoalCostLable;

@property (strong, nonatomic) IBOutlet UILabel *returnMoneyLable;
//评价或付款按钮
@property (retain, nonatomic) IBOutlet UIButton *payOrCommentButton;

@property (nonatomic,retain) NSMutableArray *orderDetailArray;

@end
