//
//  MyOrderFooterCell.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-27.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyOrderFooterCell.h"
#import "MyOrderCell.h"

@implementation MyOrderFooterCell

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
    self.orderInfo = aInfo;
    id vTotalAmount = aInfo.totalServices;
    IFISNILFORNUMBER(vTotalAmount);
    self.amountLable.text = [NSString stringWithFormat:@"数量: %@",vTotalAmount];
    
    id vTotalMoney = aInfo.totalprice;
    IFISNILFORNUMBER(vTotalMoney);
    self.totoalCostLable.text = [NSString stringWithFormat:@"%@",vTotalMoney];
    
    if (aInfo.orderState  == otCancle) {
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self.payOrCommentButton setTitle:@"已撤销" forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1]];
    }else if (aInfo.orderState == otDealing) {
        
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self.payOrCommentButton setTitle:@"撤销订单" forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1]];
        
    }else if (aInfo.orderState  == otConfirm) {
        //设置付款按钮
        self.payOrCommentButton.hidden = NO;
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"myOrder_pay_btn_default"] forState:UIControlStateNormal];
        [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"myOrder_pay_btn_select"] forState:UIControlStateHighlighted];
    }else if (aInfo.orderState == otPayed) {
        if ([aInfo.isEvaluate intValue] == 1) {
            self.payOrCommentButton.hidden = NO;
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            [self.payOrCommentButton setTitle:@"已评价" forState:UIControlStateNormal];
            [self.payOrCommentButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:1]];
        }else{
            //设置评论按钮
            self.payOrCommentButton.hidden = NO;
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"orderDetail_comment_btn_default"] forState:UIControlStateNormal];
            [self.payOrCommentButton setBackgroundImage:[UIImage imageNamed:@"orderDetail_comment_bt_select"] forState:UIControlStateHighlighted];
        }
    }
}

- (IBAction)payOrCommentButtonClicked:(id)sender {
    if (mOrderCell == Nil) {
        mOrderCell = [[MyOrderCell alloc] init];
    }
    [mOrderCell dealPayButton:self.orderInfo];
}
@end
