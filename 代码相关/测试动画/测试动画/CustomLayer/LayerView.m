//
//  LayerView.m
//  测试动画
//
//  Created by lin on 14-6-26.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "LayerView.h"

@implementation LayerView

+(Class)layerClass{
    return [CustomLissajousLayer class];
}
@end
