//
//  AgentBunessDetailCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AgentBunessDetailCell.h"
#import "NetManager.h"
#import "UserManager.h"

@implementation AgentBunessDetailCell

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
    self.bunessProductInfo = aInfo;
    
}

- (IBAction)addPurchaseCarButtonClicked:(id)sender {
    id userId= [UserManager instanceUserManager].userID;
    id  businessId = self.bunessProductInfo.businessId;
    id serviceType = self.bunessProductInfo.serviceType;
    id standardServiceType = self.bunessProductInfo.standardServiceType;
    id serviceId = self.bunessProductInfo.serviceId;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                userId,@"userId",
                                businessId,@"businessId",
                                serviceType,@"serviceType",
                                standardServiceType,@"standardServiceType",
                                serviceId,@"serviceId",
                                [NSNumber numberWithInt:1],@"count",
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
    [super dealloc];
}
#endif

@end
