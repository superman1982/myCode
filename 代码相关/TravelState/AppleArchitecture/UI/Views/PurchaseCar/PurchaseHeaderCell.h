//
//  PurchaseHeaderCell.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-24.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseHeadInfo.h"

@protocol PurchaseHeaderCellDelegate <NSObject>
-(void)didPurchaseHeaderCellCheckChanged:(PurchaseHeadInfo *)aInfo;
@end


@interface PurchaseHeaderCell : UITableViewCell

@property (nonatomic,assign) id<PurchaseHeaderCellDelegate> delegate;

@property (nonatomic,retain) PurchaseHeadInfo *headInfo;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;

@property (strong, nonatomic) IBOutlet UILabel *summation;

@property (strong, nonatomic) IBOutlet UILabel *bunessName;

-(void)setCell:(PurchaseHeadInfo *)aInfo;

@end
