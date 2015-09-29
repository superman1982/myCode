//
//  DriverLifeVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@interface DriverLifeVC : BaseViewController

@property (retain, nonatomic) IBOutlet UIView *addedView;

@property (retain, nonatomic) IBOutlet CustomImageView *customImageView;

@property (retain, nonatomic) IBOutlet UITextField *ipDoMainLable;

@property (retain, nonatomic) IBOutlet UITextField *portLable;
@end
