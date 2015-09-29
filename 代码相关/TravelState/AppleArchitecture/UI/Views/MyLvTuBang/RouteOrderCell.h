//
//  RouteOrderCell.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"
#import "MyOrderCell.h"

@interface RouteOrderCell : UITableViewCell
{
    MyOrderCell *mCell;
}
//评价或付款按钮
@property (retain, nonatomic) IBOutlet UIButton *payOrCommentButton;

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productName;

//价格描述
//挂牌价
@property (strong, nonatomic) IBOutlet UILabel *guaPaiLable;
//会员价
@property (strong, nonatomic) IBOutlet UILabel *vipPriceLable;
//返途币
@property (strong, nonatomic) IBOutlet UILabel *returnMoneyLable;

@property (retain, nonatomic) IBOutlet UILabel *orderState;
@property (retain, nonatomic) IBOutlet UIImageView *orderStateImageView;

@property (retain, nonatomic) IBOutlet UILabel *orderId;

@property (retain, nonatomic) IBOutlet UILabel *orderTime;

@property (retain, nonatomic) IBOutlet UILabel *payedTime;

@property (strong, nonatomic) IBOutlet UILabel *orderStateDescLable;

@property (nonatomic,retain) OrderInfo *orderInfo;

-(void)setCell:(OrderInfo *)aInfo;
@end
