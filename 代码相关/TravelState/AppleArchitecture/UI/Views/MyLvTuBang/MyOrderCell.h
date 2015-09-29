//
//  MyOrderCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

@protocol MyOrderCellDelegate <NSObject>

-(void)didMyOrderCellCancledOrder:(id)sender;


-(void)didMyOrderShowOtherService:(OrderInfo *)sender Section:(NSInteger)aSection;
@end

@interface MyOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productName;

//价格描述
//挂牌价
@property (strong, nonatomic) IBOutlet UILabel *guaPaiLable;
//会员价
@property (strong, nonatomic) IBOutlet UILabel *vipPriceLable;
//返途币
@property (strong, nonatomic) IBOutlet UILabel *returnMoneyLable;

@property (strong, nonatomic) IBOutlet UILabel *productDescLable;

@property (strong, nonatomic) IBOutlet UILabel *amoutLable;

@property (strong, nonatomic) IBOutlet UIImageView *upLineImageView;
@property (strong, nonatomic) IBOutlet UIButton *showOtherButton;
@property (strong, nonatomic) IBOutlet UIImageView *downLineImageView;

@property (nonatomic,assign) id<MyOrderCellDelegate> delegate;
@property (nonatomic,retain) OrderInfo *orderInfo;

-(void)setCell:(OrderInfo *)aInfo;
-(NSInteger )setShowOderDetail:(OrderInfo *)aInfo;
-(void)setHideShowOtherUI;
-(void)setShowShowOtherUI;
//付款，评价撤销等操作
-(void)dealPayButton:(OrderInfo *)aInfo;
@end
