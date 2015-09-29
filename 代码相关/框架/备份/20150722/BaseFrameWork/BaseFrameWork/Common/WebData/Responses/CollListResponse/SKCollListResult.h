//
//  SKCollListResult.h
//  BaseFrameWork
//
//  Created by lin on 15/5/19.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseObject.h"

@interface SKCollListResult : SKBaseObject

@property (nonatomic,assign) NSInteger  total;
@property (nonatomic,retain) NSArray   *dataList;
@property (nonatomic,retain) NSString  *extend;
@end
