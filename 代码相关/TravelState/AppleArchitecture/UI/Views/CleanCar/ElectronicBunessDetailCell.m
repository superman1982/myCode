//
//  ElectronicBunessDetailCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ElectronicBunessDetailCell.h"
#import "ImageViewHelper.h"
#import "UserManager.h"
#import "NetManager.h"
#import "StringHelper.h"

@implementation ElectronicBunessDetailCell

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
    //重设Cell大小
    [self setHeigtOfCell:aInfo];
    
    //有促销才显示时间
    if ([aInfo.isDiscount intValue] == 1) {
        NSString *vBegainDateStr = aInfo.beginDateTime;
        NSString *vEndDateStr = aInfo.endDateTime;
        self.beginDateTimeendDateTime.text = [NSString stringWithFormat:@"使用时间: %@至%@",vBegainDateStr,vEndDateStr];
    }else{
        self.beginDateTimeendDateTime.text = @"";
    }
    
    NSString *vipPriceDesc = @"会员价:";
    NSString *priceDesc = @"挂牌价:";
    NSString *returnMoneyDesc = @"返途币:";
    NSString *serviceDescDesc = @"商品描述:";
    //是否显示
    if ([aInfo.serviceType intValue] == 12) {
        self.acountContentCiew.hidden = YES;
        vipPriceDesc = @"代办费:";
        priceDesc = @"工本费:";
        serviceDescDesc = @"所需资料:";
        //重设"加入购物车"button位置
        [self.addToPurchaseCarButton setFrame:CGRectMake(self.addToPurchaseCarButton.frame.origin.x, 15, self.addToPurchaseCarButton.frame.size.width, self.addToPurchaseCarButton.frame.size.height)];
    }else{
        self.acountContentCiew.hidden = NO;
        //重设"加入购物车"button位置
        [self.addToPurchaseCarButton setFrame:CGRectMake(self.addToPurchaseCarButton.frame.origin.x, 24, self.addToPurchaseCarButton.frame.size.width, self.addToPurchaseCarButton.frame.size.height)];
    }
    //订单数量
    self.amoutsLable.text = [NSString stringWithFormat:@"%@",aInfo.orderNumber];
    
    id vVipPriceStr = aInfo.vipPrice;
    vVipPriceStr = [NSString stringWithFormat:@"%@%@",vipPriceDesc,vVipPriceStr];
    self.vipPrice.text = vVipPriceStr;
    
    id vOriginStr = aInfo.price;
    vOriginStr = [NSString stringWithFormat:@"%@%@",priceDesc,vOriginStr];
    self.price.text = vOriginStr;
    
    id vReuturnMoney = aInfo.returnMoney;
    vReuturnMoney = [NSString stringWithFormat:@"%@%@",returnMoneyDesc,vReuturnMoney];
    self.returnMoney.text = vReuturnMoney;
    
    self.serviceDesc.text = [NSString stringWithFormat:@"%@%@",serviceDescDesc,aInfo.serviceDesc ];
    
    self.downContentView.layer.borderWidth = 1;
    self.downContentView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1].CGColor;
    self.bunessProductInfo = aInfo;

}

-(float )setHeigtOfCell:(BunessDetailProductInfo *)aInfo{
    NSString *vCalculateStr = [NSString stringWithFormat:@"所需资料:%@",aInfo.serviceDesc];
    CGSize vDescSize = [StringHelper caluateStrLength:vCalculateStr Front:self.serviceDesc.font ConstrainedSize:CGSizeMake(self.serviceDesc.frame.size.width, CGFLOAT_MAX)];
    CGRect vServiceLableOriginRect = self.serviceDesc.frame;
    [self.serviceDesc setFrame:CGRectMake(self.serviceDesc.frame.origin.x, self.serviceDesc.frame.origin.y, self.serviceDesc.frame.size.width, vDescSize.height)];
    float vMoveSpace = vDescSize.height - vServiceLableOriginRect.size.height;
    if (vMoveSpace > 0) {
        [self.downContentView setFrame:CGRectMake(10, 106+vMoveSpace, 304, 59)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.x, self.frame.size.width, 173 + vMoveSpace)];
    }
    return self.frame.size.height;
}

- (IBAction)addButtonClicked:(id)sender {
    NSInteger vOrderNumber = [self.bunessProductInfo.orderNumber intValue];
    vOrderNumber++;
    self.bunessProductInfo.orderNumber = [NSNumber numberWithInt:vOrderNumber];
    self.amoutsLable.text = [NSString stringWithFormat:@"%@",self.bunessProductInfo.orderNumber];
    if ([_delegate respondsToSelector:@selector(didElectronicBunessDetailCellOrderAmountChanged:)]) {
        [_delegate didElectronicBunessDetailCellOrderAmountChanged:self.bunessProductInfo];
    }
}

- (IBAction)decreaseButtonClicked:(id)sender {
    NSInteger vOrderNumber = [self.bunessProductInfo.orderNumber intValue];
    vOrderNumber--;
    if (vOrderNumber <= 1) {
        vOrderNumber = 1;
    }
    self.bunessProductInfo.orderNumber = [NSNumber numberWithInt:vOrderNumber];
    self.amoutsLable.text = [NSString stringWithFormat:@"%@",self.bunessProductInfo.orderNumber];
    if ([_delegate respondsToSelector:@selector(didElectronicBunessDetailCellOrderAmountChanged:)]) {
        [_delegate didElectronicBunessDetailCellOrderAmountChanged:self.bunessProductInfo];
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
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"加入成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"加入失败"];
            }
        }
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
    [_beginDateTimeendDateTime release];
    [_amoutsLable release];
    [_servicePhoto release];
    [super dealloc];
}
#endif
@end
