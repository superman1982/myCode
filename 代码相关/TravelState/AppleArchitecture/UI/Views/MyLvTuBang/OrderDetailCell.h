//
//  OrderDetailCell.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

@interface OrderDetailCell : UITableViewCell

@property (nonatomic,retain) OrderInfo *orderInfo;

@property (retain, nonatomic) IBOutlet UILabel *orderState;
@property (retain, nonatomic) IBOutlet UIImageView *orderStateImageView;

@property (retain, nonatomic) IBOutlet UILabel *orderId;

@property (retain, nonatomic) IBOutlet UILabel *orderTime;

@property (retain, nonatomic) IBOutlet UILabel *payedTime;

//商家留言
@property (strong, nonatomic) IBOutlet UILabel *bunessComment;

@property (retain, nonatomic) IBOutlet UILabel *userComment;


-(void)setCell:(OrderInfo *)aInfo;
@end
