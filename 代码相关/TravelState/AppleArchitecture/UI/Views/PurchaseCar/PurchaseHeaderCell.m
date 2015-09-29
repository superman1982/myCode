//
//  PurchaseHeaderCell.m
//  lvtubangmember
//
//  Created by klbest1 on 14-3-24.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "PurchaseHeaderCell.h"

@implementation PurchaseHeaderCell

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

-(void)setCell:(PurchaseHeadInfo *)aInfo {
    self.headInfo = aInfo;
    id vipPriceSummation = aInfo.summVipPriceMoney;
    IFISNILFORNUMBER(vipPriceSummation);
    self.summation.text = [NSString stringWithFormat:@"%@",vipPriceSummation];
    if ([aInfo.serviceType intValue] == 12) {
        self.summation.text = [NSString stringWithFormat:@"%d",[vipPriceSummation intValue] + [aInfo.summPriceMoney intValue]];

    }
    self.bunessName.text = aInfo.bunessName;
    
    if (aInfo.isCheck) {
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"addCar_checkbox_btn_select"] forState:UIControlStateNormal];
    }else{
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"addCar_checkbox_btn_default"] forState:UIControlStateNormal];
    }
}

- (IBAction)checkButtonClicked:(UIButton *)sender {
    if (self.headInfo.isCheck) {
        self.headInfo.isCheck = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"addCar_checkbox_btn_default"] forState:UIControlStateNormal];
    }else{
        self.headInfo.isCheck = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"addCar_checkbox_btn_select"] forState:UIControlStateNormal];
    }
    if ([_delegate respondsToSelector:@selector(didPurchaseHeaderCellCheckChanged:)]) {
        [_delegate didPurchaseHeaderCellCheckChanged:self.headInfo];
    }
}

@end
