//
//  CleanCarDetailCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "CleanCarDetailCell.h"

@implementation CleanCarDetailCell

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

-(void)setCell:(BunessDetailProductInfo *)aInfo{
    if (aInfo == Nil) {
        return;
    }
    
    self.serviceName.text = aInfo.serviceName;
    
    self.serviceDesc.text = aInfo.serviceDesc;
    
    id vVipPriceStr = aInfo.vipPrice;
    vVipPriceStr = [NSString stringWithFormat:@"会员价 %@",vVipPriceStr];
    self.vipPrice.text = vVipPriceStr;
    
    id vOriginStr = aInfo.price;
    vOriginStr = [NSString stringWithFormat:@"挂牌价 %@",vOriginStr];
    self.price.text = vOriginStr;
    
    id vReuturnMoney = aInfo.returnMoney;
    vReuturnMoney = [NSString stringWithFormat:@"返途币 %@",vReuturnMoney];
    self.returnMoney.text = vReuturnMoney;
    
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_serviceName release];
    [_serviceDesc release];
    [_vipPrice release];
    [_price release];
    [_returnMoney release];
    [super dealloc];
}
#endif
@end
