//
//  AliPayManeger.m
//  lvtubangmember
//
//  Created by klbest1 on 14-3-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AliPayManeger.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"

@implementation AliPayManeger

-(id)init{
    self = [super init];
    if (self) {
        _result = @selector(paymentResult:);
    }
    return self;
}
//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                if ([_delegate respondsToSelector:@selector(didAliPayManegerPaySucess:)]) {
                    [_delegate didAliPayManegerPaySucess:self.productInfo];
                }
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

-(void)payAliProduct:(ProductInfo *)aInfo{
    self.productInfo = aInfo;
    //获取plist信息
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //获取程序名字
    NSString *appScheme = [infoDic objectForKey:(NSString *)kCFBundleNameKey];
    NSString* orderInfo = [self getOrderInfo:aInfo];
    NSString* signedStr = [self doRsa:orderInfo];

    LOG(@"%@",signedStr);
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderInfo, signedStr, @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
}

-(NSString*)getOrderInfo:(ProductInfo *)aInfo
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = aInfo.orderId; //订单ID（由商家自行制定）
	order.productName = aInfo.subject; //商品标题
	order.productDescription = aInfo.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",aInfo.price]; //商品价格
	order.notifyURL =  @"http://www.hnqlhr.com/services/alipay/notify"; //回调URL
	return [order description];
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    LOG(@"%@",result);
}

@end
