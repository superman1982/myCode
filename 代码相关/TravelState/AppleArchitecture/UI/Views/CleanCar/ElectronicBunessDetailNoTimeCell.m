//
//  ElectronicBunessDetailNoTimeCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ElectronicBunessDetailNoTimeCell.h"
#import "ImageViewHelper.h"
#import "UserManager.h"
#import "NetManager.h"

@implementation ElectronicBunessDetailNoTimeCell

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
    
    NSString *vHeadImageURLStr = aInfo.servicePhoto;
    [self.servicePhoto setImageWithURL:[NSURL URLWithString:vHeadImageURLStr] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
    
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
    
    //订单数量
    self.amoutLable.text = [NSString stringWithFormat:@"%@",aInfo.orderNumber];
    self.bunessProductInfo = aInfo;
    
}



- (IBAction)addButtonClicked:(id)sender {
    NSInteger vOrderNumber = [self.bunessProductInfo.orderNumber intValue];
    vOrderNumber++;
    self.bunessProductInfo.orderNumber = [NSNumber numberWithInt:vOrderNumber];
    self.amoutLable.text = [NSString stringWithFormat:@"%@",self.bunessProductInfo.orderNumber];
    if ([_delegate respondsToSelector:@selector(didElectronicBunessDetailNoTimeCellOrderAmountChanged:)]) {
        [_delegate didElectronicBunessDetailNoTimeCellOrderAmountChanged:self.bunessProductInfo];
    }
}

- (IBAction)decreaseButtonClicked:(id)sender {
    NSInteger vOrderNumber = [self.bunessProductInfo.orderNumber intValue];
    vOrderNumber--;
    if (vOrderNumber <= 1) {
        vOrderNumber = 1;
    }
    self.bunessProductInfo.orderNumber = [NSNumber numberWithInt:vOrderNumber];
    self.amoutLable.text = [NSString stringWithFormat:@"%@",self.bunessProductInfo.orderNumber];
    if ([_delegate respondsToSelector:@selector(didElectronicBunessDetailNoTimeCellOrderAmountChanged:)]) {
        [_delegate didElectronicBunessDetailNoTimeCellOrderAmountChanged:self.bunessProductInfo];
    }
}

- (IBAction)addToPurchaseCarButtonClicked:(id)sender {
    id userId= [UserManager instanceUserManager].userID;
    id  businessId = self.bunessProductInfo.businessId;
    id serviceType = self.bunessProductInfo.serviceType;
    id standardServiceType = self.bunessProductInfo.standardServiceType;
    id serviceId = self.bunessProductInfo.serviceId;
    id count = self.bunessProductInfo.orderNumber;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                userId,@"userId",
                                businessId,@"businessId",
                                serviceType,@"serviceType",
                                standardServiceType,@"standardServiceType",
                                serviceId,@"serviceId",
                                count,@"count",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL701 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"加入购物车" Notice:@""];
}



#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_serviceName release];
    [_vipPrice release];
    [_price release];
    [_returnMoney release];
    [_serviceDesc release];
    [_servicePhoto release];
    [_amoutLable release];
    [super dealloc];
}
#endif
@end
