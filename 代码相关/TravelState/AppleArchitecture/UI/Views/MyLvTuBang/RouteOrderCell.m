//
//  RouteOrderCell.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RouteOrderCell.h"
#import "UIImageView+AFNetworking.h"
#import "SelfTravelVC.h"

@implementation RouteOrderCell

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
        _productName.text = @"";
        //价格描述
        //挂牌价
        _guaPaiLable.text = @"";
        //会员价
        _vipPriceLable.text = @"";
        //返途币
        _returnMoneyLable.text = @"";
        _orderId.text = @"";
        _orderTime.text = @"";
        _payedTime.text = @"";
        self.orderState.text = @"";
        self.orderStateImageView.image = [UIImage imageNamed:@""];
        _orderStateDescLable.text = @"";
        [self.productImageView setImage:[UIImage imageNamed:@"lvtubang.png"]];
        //设置评论按钮
        self.payOrCommentButton.hidden = YES;
        return;
    }
    self.orderInfo = aInfo;
    //设置评论按钮
    self.payOrCommentButton.hidden = YES;
    [self.productImageView setImageWithURL:[NSURL URLWithString:aInfo.businessPhoto] placeholderImage:[UIImage imageNamed:@"lvtubang.png"]];//??
    self.productName.text = aInfo.businessName;
    
    self.returnMoneyLable.text = [NSString stringWithFormat:@"返途币: %@",aInfo.returnMoney];
    self.guaPaiLable.text = [NSString stringWithFormat:@"挂牌价: %@",aInfo.price];
    self.vipPriceLable.text = [NSString stringWithFormat:@"会员价: %@",aInfo.vipPrice];
    
    
    NSString *orderIdStr = [NSString stringWithFormat:@"订单号:%@",aInfo.orderId];
    self.orderId.text = orderIdStr;
    
    self.orderTime.text = [NSString stringWithFormat:@"下单时间: %@",aInfo.orderTime];
    self.payedTime.text = [NSString stringWithFormat:@"付款时间: %@",aInfo.exchangeTime];
    aInfo.orderState = otPayed;
    if (aInfo.orderState  == otCancle) {
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self.payOrCommentButton setTitle:@"已撤销" forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1]];
        
        self.orderState.text = @"已撤销";
        [self.orderState setFrame:CGRectMake(self.orderState.frame.origin.x-30, self.orderState.frame.origin.y, self.orderState.frame.size.width, self.orderState.frame.size.height)];
        self.orderStateImageView.image = [UIImage imageNamed:@""];
    }else if (aInfo.orderState == otDealing) {
        
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self.payOrCommentButton setTitle:@"撤销订单" forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1]];
        
        self.orderState.text = @"办理中";
        self.orderStateImageView.image = [UIImage imageNamed:@"myOrder_handling_btn"];
        
    }else if (aInfo.orderState  == otConfirm) {
        //设置付款按钮
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"myOrder_pay_btn_default"] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"myOrder_pay_btn_select"] forState:UIControlStateHighlighted];
        
        self.orderState.text = @"商家确认";
        self.orderStateImageView.image = [UIImage imageNamed:@"myOrder_confirmed_btn"];
    }else if (aInfo.orderState == otPayed) {
        if ([aInfo.isEvaluate intValue] == 1) {
            self.orderState.text = @"已评论";
            //设置评论按钮
            self.payOrCommentButton.hidden = YES;
        }else{
            self.orderState.text = @"未评论";
            //设置评论按钮
            self.payOrCommentButton.hidden = NO;
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"orderDetail_comment_btn_default"] forState:UIControlStateNormal];
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"orderDetail_comment_bt_select"] forState:UIControlStateHighlighted];
        }
    }
    
    //价格描述
    if ([aInfo.orderType intValue] == 12) {
        self.guaPaiLable.text = [NSString stringWithFormat:@"工本费: %@",aInfo.price];
        self.vipPriceLable.text = [NSString stringWithFormat:@"代办费: %@",aInfo.vipPrice];
    }
}

- (IBAction)payButtonTouchDown:(id)sender {
    self.orderInfo.orderState = otPayed;
    if (mCell == Nil) {
        mCell = [[MyOrderCell alloc] init];
    }
    [mCell dealPayButton:self.orderInfo];
}

- (IBAction)activeDetailButtonClicked:(id)sender {
    SelfTravelVC *vVC = [[SelfTravelVC alloc] init];
    [vVC gotoActiveDetailVC:self.orderInfo.businessId];
    vVC = Nil;
}


@end
