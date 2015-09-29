//
//  HttpDefine.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ABOSULUTEPATH @"http://118.123.249.138:7001"

#define APPURL1006 [NSString stringWithFormat:@"%@%@",ABOSULUTEPATH,@"/services/mobile/login"]

#define APPURL1010 [NSString stringWithFormat:@"%@%@",ABOSULUTEPATH,@"/services/seller/gainSellerInfo"]

#define NEWABOSULUTEPATH @"http://www.hnqlhr.com"

#define APPURL101 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/app/version?terminal_type=51&user_type=1"]

#define APPURL102 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/global/getInitInfo"]

#define APPURL103 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/global/getRegion"]

#define APPURL105 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/global/getCaptcha"]

#define APPURL201 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/login"]
#pragma mark 注册
#define APPURL202 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/register"]

#pragma mark 轮播广告
#define APPURL301 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/advertising/listAdvertising"]

#pragma mark 轮播通告
#define APPURL499 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/listLatestActivity"]

#pragma mark 找回密码
#define APPURL303 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/findPassword"]

#pragma mark 搜索商家
#define APPURL330  [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/seller/find"]

#pragma mark 活动路书
#define APPURL401 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/listActivity"]

#pragma mark 活动详情
#define APPURL402 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/getDetail"]

#pragma mark 活动点赞
#define APPURL403 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/praise"]

#pragma mark 活动分享
#define APPURL404 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/share"]

#pragma mark 活动评价
#define APPURL405 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/comment"]

#pragma mark 查看某活动评价
#define APPURL406 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/listComment"]

#pragma mark 活动报名
#define APPURL407 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/signup"]

#pragma mark 获取旅途邦会员信息
#define APPURL409 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/getMemberInfo"]

#pragma mark 获取提供拼车列表
#define APPURL410 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/listProvideCar"]

#pragma mark 我要投保
#define APPURL501 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/insurance/insure"]

#pragma mark 获取商业保险
#define APPURL502 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/insurance/listCmrclInsur"]

#pragma mark 添加商业险
#define APPURL503 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/insurance/addCmrclInsur"]

#pragma mark 获取交强险列表
#define APPURL504 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/insurance/listCmplyInsur"]

#pragma mark 添加交强险
#define APPURL505 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/insurance/addCmplyInsur"]

#pragma mark 添加交强险
#define APPURL505 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/insurance/addCmplyInsur"]

#pragma mark 删除保险
#define APPURL540  [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/insurance/deleteInsur"]

#pragma mark 获取车务商家
#define APPURL506 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/seller/listOperationSeller"]

#pragma mark 获取支持的违章查询地区数据
#define APPURL601 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/violateRule/listRegion"]

#pragma mark 违章查询
#define APPURL602 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/violateRule/getViolate"]

#pragma mark 加入购物车
#define APPURL701 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/shoppingCart/addService"]

#pragma mark 购物车中的商品&服务列表
#define APPURL702 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/shoppingCart/listShoppingCart"]

#pragma mark 删除购物车中的几个服务
#define APPURL703 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/shoppingCart/removeService"]

#pragma mark 提交订单(结算)
#define APPURL704 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/shoppingCart/submitOrder"]

#pragma mark 获取个人资料
#define APPURL801 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/getUser"]

#pragma mark 修改添加个人资料
#define APPURL802 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/updateUser"]

#pragma mark 我的提醒
#define APPURL803 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/remind/listRemind"]

#pragma mark 我的消息
#define APPURL804 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/message/listReceiveMsg"]

#pragma mark 充值
#define APPURL805 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/score/recharge"]

#pragma mark 转账
#define APPURL806 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/score/transfer"]

#pragma mark 升级会员
#define APPURL807 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/vip/listMoreCardType"]

#pragma mark 积分记录
#define APPURL808 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/score/record"]

#pragma mark 我的会员卡
#define APPURL809 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/vip/listUserCard"]

#pragma mark 会员卡详情
#define APPURL810 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/vip/listUserWelfare"]

#pragma mark 我的订单
#define APPURL811 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/order/listOrder"]

#pragma mark 订单详情
#define APPURL812 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/order/getOrder"]

#pragma mark 订单评价
#define APPURL813 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/order/evaluate"]

#pragma mark 订单支付
#define APPURL833 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/order/payOrder"]

#pragma mark 撤销订单
#define APPURL814 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/order/cancel"]

#pragma mark 我的行程
#define APPURL815 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/listMyActivity"]

#pragma mark 我的爱车
#define APPURL816 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/car/listCar"]

#pragma mark 爱车详情
#define APPURL817 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/car/getCar"]

#pragma mark 添加爱车
#define APPURL818 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/car/addCar"]

#pragma mark 修改爱车
#define APPURL819 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/car/updateCar"]

#pragma mark 删除爱车
#define APPURL820 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/car/deleteCar"]

#pragma mark 我的驾驶证
#define APPURL821 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/driverLicense/getDriverLicense"]

#pragma mark 添加驾驶证
#define APPURL822 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/driverLicense/addDriverLicense"]

#pragma mark 修改驾驶证
#define APPURL823 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/driverLicense/updateDriverLicense"]

#pragma mark 修改手机号
#define APPURL824 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/updatePhone"]

#pragma mark 修改登录密码
#define APPURL825 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/updatePassword"]

#pragma mark 修改支付密码
#define APPURL826 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/updatePayPassword"]

#pragma mark 添加支付密码
#define APPURL827 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/user/addPayPassword"]

#pragma mark 商家详情
#define APPURL901 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/seller/getSellerDetail"]

#pragma mark 商家介绍
#define APPURL902 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/seller/getSellerDescription"]

#pragma mark 商家相册
#define APPURL903 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/seller/listSellerImage"]

#pragma mark 商家评论
#define APPURL904 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/seller/listSellerComment"]

#pragma mark 关于旅途邦
#define APPURL1001 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/ltb/getAbout"]

#pragma mark 分享旅途邦
#define APPURL1002 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/ltb/shareLtb"]

#pragma mark 意见反馈
#define APPURL1003 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/ltb/addOpinion"]

#pragma mark 添加照片
#define APPURL910 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/image/add"]

#pragma mark 删除照片
#define APPURL920 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/image/delete"]

#pragma mark 车辆类型 聚合
#define APPURL921 @"http://v.juhe.cn/wz/hpzl?key=e9abb0766c60f52f542e238246420382"

#pragma mark 违章城市 聚合
#define APPURL922 @"http://v.juhe.cn/wz/citys?key=e9abb0766c60f52f542e238246420382"

#pragma mark 查询违章 聚合
#define APPURL923 @"http://v.juhe.cn/wz/query?"

#pragma mark 聚合key
#define JUHEKEY  @"e9abb0766c60f52f542e238246420382"

#pragma mark 行程订单详情
#define APPURL933 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/getMyActDetail"]