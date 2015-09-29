//
//  RoutesMapVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiDuMapView.h"

@interface RoutesMapVC : BaseViewController<BaiDuMapViewDelegate>

-(void)reSetViewFrame:(CGRect)aFrame;
@end
