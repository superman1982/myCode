//
//  MyOrderFooterCell.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-27.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"
#import "MyOrderCell.h"

@interface MyOrderFooterCell : UITableViewCell
{
    MyOrderCell *mOrderCell;
}
@property (strong, nonatomic) IBOutlet UILabel *amountLable;
@property (strong, nonatomic) IBOutlet UILabel *totoalCostLable;
//评价或付款按钮
@property (retain, nonatomic) IBOutlet UIButton *payOrCommentButton;
@property (nonatomic,retain) OrderInfo *orderInfo;

-(void)setCell:(OrderInfo *)aInfo;
@end
