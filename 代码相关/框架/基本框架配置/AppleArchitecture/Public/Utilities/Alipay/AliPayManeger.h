//
//  AliPayManeger.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfo.h"

@protocol AliPayManegerDelegate <NSObject>

-(void)didAliPayManegerPaySucess:(ProductInfo *)sender;
@end

@interface AliPayManeger : NSObject

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (nonatomic,assign) id <AliPayManegerDelegate> delegate;

@property (nonatomic,retain) ProductInfo *productInfo;

-(void)payAliProduct:(ProductInfo *)aInfo;

@end
