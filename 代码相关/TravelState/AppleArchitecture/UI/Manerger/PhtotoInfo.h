//
//  PhtotoInfo.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhtotoInfo : NSObject

@property (nonatomic,retain) UIImage *photoImage;
@property (nonatomic,retain) NSString *phtotURLStr;
@property (nonatomic,assign) PhotoType photoType;
@property (nonatomic,retain) id businessId;
@property (nonatomic,assign) BOOL isAudio;
@end
