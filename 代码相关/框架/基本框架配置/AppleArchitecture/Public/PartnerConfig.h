//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088111854653956"
//收款支付宝账号
#define SellerID  @"2570359836@qq.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"62ffrvfk2x45rpsr9uno5xsfga3hd8cb"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALdWbHI9h/Hc0mkYXFWBB9SuqB44vTQmYHNkC/QC4AP0j4oaXkRYbq4doPlcFSShd2/kTnOhM+hiUci5BI6MXuR94QotNEPv8apDAwqu/BD788M5wa2uRDmnaDZgw0fKP/DGLn3+xTx09q2d5jmRRyc7eXIpSktpC2yOxrqOFZ8VAgMBAAECgYBbet8f3b4AnBvNXt9rtrdukzvF4K/f3qpPyYMBXZHjx1r8IQ4acjm/3X7eDelq3rqW9UeEANLCyJRgYJl6e2Y5KjT82RTc3OWS+glrE6/zNzN7rZUL3hUlNrhvHGPTe03R4rdeBHavPL+0aWcu/3RA+BKn1ATpznQ2d5mPETW7IQJBAOgDpwYg2U7kAr+qAJNWSEN+NS2gIOZdR5dt36Zxj1kNWWrzIylmclXV7bE5cyni0JqAc/wkXYqr6q/dMPNb4lkCQQDKSoYrRDBE/JbVZTI+cfHHphu0Jgw8W+CtJU+O6yD/qo/GMNXcGukwhfiWHkcDb4Oh4DdnwR9zl5Ngc0pgF3MdAkAzQGNL8kOurqWAyz/3TA8Igb+jhYTe/moLJGVMMje1N0KyYmU5Bv1owqoQBR3Qed8U0h1M7IeRU2qzUIw4pep5AkAb13333n62P/2SiUcNCSm5zMbrWIE+nXai3gvBI+N6zMLVCEum651ErGu2XZxwgJyhXvbBNPdbNXV3RObrqs6RAkEAneYrjP+5sCjef7XW/1jxJygP6LpZ51E7Eljhr44JCcqEsGBdJtu6qxWspCycxLpIm+7F+gqj1Lu/ZwBNeO42Zg=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
