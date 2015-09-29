//
//  OrderDetailCell.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "OrderDetailCell.h"
#import "UIImageView+AFNetworking.h"

@implementation OrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(OrderInfo *)aInfo{
    if (aInfo == nil) {
        return;
    }
    self.orderInfo = aInfo;
    
    NSString *orderIdStr = [NSString stringWithFormat:@"订单号:%@",aInfo.orderId];
    self.orderId.text = orderIdStr;

    self.orderTime.text = [NSString stringWithFormat:@"下单时间: %@",aInfo.orderTime];
    self.payedTime.text = [NSString stringWithFormat:@"付款时间: %@",aInfo.exchangeTime];
    if (aInfo.orderState  == otCancle) {
        self.orderState.text = @"已撤销";
        [self.orderState setFrame:CGRectMake(self.orderState.frame.origin.x-30, self.orderState.frame.origin.y, self.orderState.frame.size.width, self.orderState.frame.size.height)];
        self.orderStateImageView.image = [UIImage imageNamed:@""];
    }else if (aInfo.orderState == otDealing) {
        self.orderState.text = @"办理中";
        self.orderStateImageView.image = [UIImage imageNamed:@"myOrder_handling_btn"];

    }else if (aInfo.orderState  == otConfirm) {
        self.orderState.text = @"商家确认";
        self.orderStateImageView.image = [UIImage imageNamed:@"myOrder_confirmed_btn"];
    }else if (aInfo.orderState == otPayed) {
        self.orderState.text = @"已付款";
        self.orderStateImageView.image = [UIImage imageNamed:@"myOrder_payed_btn"];
        if ([aInfo.isEvaluate intValue] == 1) {
            self.orderState.text = @"已评论";
        }else{
            self.orderState.text = @"未评论";
        }
    }
    
    //商家留言
    self.userComment.text = [NSString stringWithFormat:@"我的留言: %@",aInfo.userComment ];
    self.bunessComment.text = [NSString stringWithFormat:@"商家留言: %@",aInfo.sellerComment];
}

@end
