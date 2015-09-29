//
//  ShangJiaInfo.h
//  车途邦
//
//  Created by klbest1 on 13-11-7.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface ShangJiaInfo : BMKPoiInfo

///POI名称
@property (nonatomic, retain) NSString* name; //title
///POIuid
@property (nonatomic, retain) NSString* uid;
///POI地址
@property (nonatomic, retain) NSString* address; //address
///POI所在城市
@property (nonatomic, retain) NSString* city;
///POI电话号码
@property (nonatomic, retain) NSString* phone;
//商家位置
@property (nonatomic) CLLocationCoordinate2D pt;
//门头
@property (nonatomic,retain) NSString *photo; 
//是否认证isauthenticate
@property (nonatomic,assign) NSInteger isauthenticate; 
//星级stars
@property (nonatomic,assign) NSInteger stars; 
//距离distance
@property (nonatomic,assign) NSInteger distance; 

@property (nonatomic,retain) id bunessId;

@property (nonatomic,assign) NSInteger userid;
//类型
@property (nonatomic,assign) NSInteger type; 
//最小价格
@property (nonatomic,retain) id minMoney;
//最大价格
@property (nonatomic,retain) id maxMoney;
//搜索类型
@property (nonatomic,retain) NSNumber *searchType;
//服务名字
@property (nonatomic,retain) NSString *serviceName;

-(id)initName:(NSString *)aName Address:(NSString *)aAdress Phone:(NSString *)aPhone
        Photo:(NSString *)aPhoto Isauthenticate:(NSInteger )aAuth Stars:(NSInteger)star
     Distance:(NSInteger)aDistane Pt:(CLLocationCoordinate2D)aPt BussId:(id)aBunessId
         Type:(NSInteger)aType UserId:(NSInteger)aUserId;
    
@end
