//
//  PurchaseCarCell.m
//  lvtubangmember
//
//  Created by klbest1 on 14-3-23.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "PurchaseCarCell.h"
#import "ImageViewHelper.h"

@implementation PurchaseCarCell

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

-(void)setCell:(PurchaseCarInfo *)aInfo{
    self.upContentView.layer.borderWidth =1;
    self.upContentView.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
    if (aInfo == Nil) {
        return;
    }
    self.businessName.text = aInfo.businessName;
    [self.photo setImageWithURL:[NSURL URLWithString:aInfo.photo] PlaceHolder:[UIImage imageNamed:@"lvtubang"]];
    self.name.text = aInfo.name;
    self.count.text = [NSString stringWithFormat:@"%@",aInfo.count];
    self.vipPrice.text = [NSString stringWithFormat:@"会员价: %@",aInfo.vipPrice];
    if ([aInfo.serviceType intValue] == 12) {
        self.lineImageView.hidden = YES;
        self.price.text = [NSString stringWithFormat:@"工本费: %@",aInfo.price];
    }else{
        self.lineImageView.hidden = NO;
        self.price.text = [NSString stringWithFormat:@"挂牌价: %@",aInfo.price];
    }
    self.purchaseCarInfo = aInfo;
}

- (IBAction)addButtonClicked:(id)sender {
    NSInteger vOrderNumber = [self.purchaseCarInfo.count intValue];
    vOrderNumber++;
    self.purchaseCarInfo.count = [NSNumber numberWithInt:vOrderNumber];
    self.count.text = [NSString stringWithFormat:@"%@",self.purchaseCarInfo.count];
    if ([_delegate respondsToSelector:@selector(didPurchaseCarCellCountChanged:)]) {
        [_delegate didPurchaseCarCellCountChanged:self.purchaseCarInfo];
    }
}

- (IBAction)decreaseButtonClicked:(id)sender {
    NSInteger vOrderNumber = [self.purchaseCarInfo.count intValue];
    vOrderNumber--;
    if (vOrderNumber <= 1) {
        vOrderNumber = 1;
    }
    self.purchaseCarInfo.count = [NSNumber numberWithInt:vOrderNumber];
    self.count.text = [NSString stringWithFormat:@"%@",self.purchaseCarInfo.count];

    if ([_delegate respondsToSelector:@selector(didPurchaseCarCellCountChanged:)]) {
        [_delegate didPurchaseCarCellCountChanged:self.purchaseCarInfo];
    }
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_upContentView release];
    [_businessName release];
    [_summationLable release];
    [_photo release];
    [_name release];
    [_count release];
    [_vipPrice release];
    [super dealloc];
}
#endif
@end
