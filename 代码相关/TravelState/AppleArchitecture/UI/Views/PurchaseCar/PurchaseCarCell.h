//
//  PurchaseCarCell.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-23.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseCarInfo.h"


@protocol PurchaseCarCellDelegate <NSObject>
-(void)didPurchaseCarCellCountChanged:(PurchaseCarInfo *)aInfo;
@end

@interface PurchaseCarCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UILabel *businessName;
@property (retain, nonatomic) IBOutlet UILabel *summationLable;
@property (retain, nonatomic) IBOutlet UIImageView *photo;

@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *count;
//工本费
@property (strong, nonatomic) IBOutlet UILabel *price;
//代办费
@property (retain, nonatomic) IBOutlet UILabel *vipPrice;
//斜杠
@property (strong, nonatomic) IBOutlet UIImageView *lineImageView;

@property (retain, nonatomic) IBOutlet UIView *upContentView;

@property (nonatomic,retain) PurchaseCarInfo *purchaseCarInfo;

@property (nonatomic,assign)  id<PurchaseCarCellDelegate> delegate;

-(void)setCell:(PurchaseCarInfo *)aInfo;

@end
