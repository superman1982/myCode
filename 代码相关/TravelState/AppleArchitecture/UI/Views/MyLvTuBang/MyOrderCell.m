//
//  MyOrderCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MyOrderCell.h"
#import "OrderCommentVC.h"
#import "ProductInfo.h"
#import "PayOrderVC.h"
#import "UserManager.h"
#import "NetManager.h"
#import "MyLvTuBangVC.h"
#import "ImageViewHelper.h"
#import "StringHelper.h"
#import "ActivityRouteManeger.h"

@implementation MyOrderCell

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

-(void)setCell:(OrderInfo *)aInfo{
    if (aInfo == nil) {
        return;
    }
    self.orderInfo = aInfo;
    
    //价格描述
    if ([aInfo.orderType intValue] == 12) {
        self.guaPaiLable.text = [NSString stringWithFormat:@"工本费: %@",aInfo.price];
        self.vipPriceLable.text = [NSString stringWithFormat:@"代办费: %@",aInfo.vipPrice];
    }
    self.returnMoneyLable.text = [NSString stringWithFormat:@"返途币: %@",aInfo.returnMoney];
    self.guaPaiLable.text = [NSString stringWithFormat:@"挂牌价: %@",aInfo.price];
    self.vipPriceLable.text = [NSString stringWithFormat:@"会员价: %@",aInfo.vipPrice];
    
    [self.productImageView setImageWithURL:[NSURL URLWithString:aInfo.servicePhtoto] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
    self.productName.text = aInfo.serviceName;
    self.amoutLable.text = [NSString stringWithFormat:@"数量: %@",aInfo.orderCount];
}

-(NSInteger )setShowOderDetail:(OrderInfo *)aInfo{
    self.amoutLable.hidden = YES;
    self.upLineImageView.hidden = YES;
    self.showOtherButton.hidden = YES;
    self.downLineImageView.hidden = YES;
    CGSize vDescSize = [StringHelper caluateStrLength:aInfo.serviceDesc Front:self.productDescLable.font ConstrainedSize:CGSizeMake(self.productDescLable.frame.size.width, CGFLOAT_MAX)];
    self.productDescLable.text = aInfo.serviceDesc;
    self.productDescLable.hidden = NO;
    [self.productDescLable setNumberOfLines:0];
    [self.productDescLable setFrame:CGRectMake(11, 81, 299, vDescSize.height)];
    if (vDescSize.height > 21) {
        [self setFrame:CGRectMake(0, 0, 320, 110 + vDescSize.height - 21 )];
    }
    
    self.productName.text = aInfo.serviceName;
    
    return self.frame.size.height;
}

-(void)setHideShowOtherUI{
    self.showOtherButton.hidden =YES;
    self.upLineImageView.hidden = YES;
    [self.downLineImageView setFrame:CGRectMake(11, 109-20, 320, 1)];
    [self setFrame:CGRectMake(0, 0, 320, 110 - 20)];
}

-(void)setShowShowOtherUI{
    self.showOtherButton.hidden =NO;
    self.upLineImageView.hidden = NO;
    [self.downLineImageView setFrame:CGRectMake(11, 109, 320, 1)];
    [self setFrame:CGRectMake(0, 0, 320, 110)];
}


- (IBAction)showOtherServiceButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(didMyOrderShowOtherService: Section:)]) {
        [_delegate didMyOrderShowOtherService:self.orderInfo Section:self.tag];
    }
}

- (IBAction)payOrCommentButtonClicked:(id)sender {
    [self dealPayButton:self.orderInfo];
}

-(void)dealPayButton:(OrderInfo *)aInfo{
    //撤销订单
    if (aInfo.orderState == otDealing) {
        [self cancleOder:aInfo.orderId];
    }else if (aInfo.orderState == otConfirm) {
        //        //付款
        //检查途币余额
        if ([aInfo.totalprice intValue]> [[UserManager instanceUserManager].userInfo.rechargeMoney intValue]) {
            [self showNoticeUI];
        }else{
            [ViewControllerManager createViewController:@"PayOrderVC"];
            PayOrderVC *vVC = (PayOrderVC *)[ViewControllerManager getBaseViewController:@"PayOrderVC"];
            vVC.oderInfo = aInfo;
            [ViewControllerManager showBaseViewController:@"PayOrderVC" AnimationType:vaDefaultAnimation SubType:0];
        }
    }else if (aInfo.orderState == otPayed){
        if ([aInfo.isEvaluate intValue] == 0) {
            //评论
            [ViewControllerManager createViewController:@"OrderCommentVC"];
            OrderCommentVC *vVC = (OrderCommentVC *)[ViewControllerManager getBaseViewController:@"OrderCommentVC"];
            vVC.orderInfo = aInfo;
            [ViewControllerManager showBaseViewController:@"OrderCommentVC" AnimationType:vaDefaultAnimation SubType:0];
        }
    }

}

#pragma mark 提示途币不足
-(void)showNoticeUI{
    UIAlertView *vAlertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"途币不足，确定去充值吗 ？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [vAlertView show];
    vAlertView = Nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        id vPayPassword = [UserManager instanceUserManager].userInfo.isSetPayPassword;
        //设置了支付密码直接充值
        if ([vPayPassword intValue] == 1) {
            [ViewControllerManager  createViewController:@"ChongZhiVC"];
            [ViewControllerManager showBaseViewController:@"ChongZhiVC" AnimationType:vaDefaultAnimation SubType:0];
        }else{
            //没设置支付密码先添加支付密码
            [ViewControllerManager createViewController:@"AddPayPasswordVC"];
            [ViewControllerManager showBaseViewController:@"AddPayPasswordVC" AnimationType:vaDefaultAnimation SubType:0];
        }

    }
}

-(void)cancleOder:(id)aOrderId{
    if (aOrderId == Nil) {
        return;
    }
    id userId = [UserManager instanceUserManager].userID;
    
    NSDictionary *vParemeter = @{@"userId": userId,
                                 @"orderId":aOrderId,
                                 };
    [NetManager postDataFromWebAsynchronous:APPURL814 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"撤销成功"];
                [ActivityRouteManeger refreshPayRelatedUI];
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:@"撤销失败"];
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"撤销订单" Notice:@"正在撤销"];
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_orderInfo release];
    [_orderId release];
    [_orderType release];
    [_returnMoney release];
    [_price release];
    [_vipPrice release];
    [_orderTime release];
    [_orderState release];
    [_userComment release];
    [_orderStateImageView release];
    [_payOrCommentButton release];
    [_payedTime release];
    [_needMoney release];
    [super dealloc];
}
#endif
@end
