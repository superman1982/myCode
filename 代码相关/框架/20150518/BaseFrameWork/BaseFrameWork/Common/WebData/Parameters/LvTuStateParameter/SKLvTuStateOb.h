//
//  SKLvTuStateOb.h
//  BaseFrameWork
//
//  Created by lin on 15/5/27.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseObject.h"

@interface SKLvTuStateOb : SKBaseObject

@property (nonatomic,retain) NSString *classType;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSNumber *provinceId;
@property (nonatomic,retain) NSNumber *cityId;
@property (nonatomic,retain) NSNumber *districtId;
@property (nonatomic,retain) NSNumber *type;
@property (nonatomic,retain) NSNumber *pageIndex;
@property (nonatomic,retain) NSNumber *pageSize;
@end
