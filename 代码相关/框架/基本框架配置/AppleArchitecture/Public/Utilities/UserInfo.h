//
//  UserInfo.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-4.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,retain) NSNumber *provinceId;

@property (nonatomic,retain) NSNumber *cityId;

@property (nonatomic,retain) NSNumber *districtId;

@property (nonatomic,retain) NSString *usertId;

@property (nonatomic,retain) NSString *realName;

@property (nonatomic,retain) NSNumber *idNumber;

@property (nonatomic,retain) NSMutableArray *idImgs;

@property (nonatomic,retain) NSNumber *isAudit;

@property (nonatomic,retain) NSString *birthday;

@property (nonatomic,retain) NSString *phone;

@property (nonatomic,retain) NSString *sex;

@property (nonatomic,retain) NSString *QQ;

@property (nonatomic,retain) NSString *email;

@property (nonatomic,retain) NSString *residence;

@property (nonatomic,retain) NSString *headerImageUrl;

@property (nonatomic,retain) NSString *nickname;

@property (nonatomic,retain) NSString *signature;

@property (nonatomic,retain) NSNumber *isSetPayPassword;

@property (nonatomic,retain) NSNumber *directMessage;

@property (nonatomic,retain) NSString *registerFrom;

@property (nonatomic,retain) NSNumber *isAllowInvite;

@property (nonatomic,retain) NSNumber *rechargeMoney;

@property (nonatomic,retain) NSNumber *giveMoney;

@property (nonatomic,retain) NSNumber *isPaySms;

@property (nonatomic,retain) NSNumber *alertMessage;

@property (nonatomic,retain) NSString *memberTime;

@property (nonatomic,retain) NSNumber *memberLeverId;

@property (nonatomic,retain) NSString *memberLeverName;

@property (nonatomic,retain) NSString *memberLeverImageUrl;

@property (nonatomic,retain) NSMutableArray *memberCard;
/*
 "provinceId": "int:省份id",
 "cityId": "int:城市id",
 "districtId": "int:地区id",
 "usertId": "int:用户Id",
 "realName": "String:真实姓名",
 "idNumber": "String:身份证号码",
 "idImgs":
 [
 "String:身份证照片(url)",
 …
 ],
 "birthday": "String:生日",
 "phone": "String:手机号码",
 "sex": "String:男、女",
 "QQ": "String:QQ号码",
 "email": "String:邮箱",
 "residence": "String:户籍",
 "headerImageUrl": "String:头像(url)",
 "nickname": "String:昵称",
 "signature": "String:个性签名",
 "isSetPayPassword": "int:是否设置支付密码，0表示没有，1表示已设置"
 "directMessage": "int:私信开关(0、关；1、开)",
 "registerFrom": "String:注册渠道来源",
 "isAllowInvite": "int:允许邀请开关(0、不允许；1、允许)",
 "isPaySms": "int:支付提醒数目",
 "alertMessage": "int:提醒消息数目",
 "memberTime": "String:会员时长(如:123天)",
 "memberLeverId": "int:会员等级ID",
 "memberLeverName": "String:会员等级名字",
 "memberLeverImageUrl": "String:会员等级对应的图片(url)"
 */
@end
