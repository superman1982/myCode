//
//  BMKPointA.h
//  CTBMobilePro
//
//  Created by klbest1 on 13-8-2.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "ShangJiaInfo.h"

@interface BMKPointA : BMKPointAnnotation

{
	int tag_;
    int renZheng_;
    int leiXing_;
}

@property (nonatomic,assign) int tag;
@property (nonatomic,assign) int renZheng;
@property (nonatomic,assign) int leiXing;
@property (nonatomic,retain) NSString *bunessTitle;
@property (nonatomic,retain) ShangJiaInfo *shangJiaInfo;

@end
