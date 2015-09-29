//
//  SafeCenterVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-17.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableTableView.h"

@interface SafeCenterVC : BaseViewController
//safeFooterView 支付时短信提醒
@property (retain, nonatomic) IBOutlet UIView *safeFooterView;
@property (retain, nonatomic) IBOutlet ClickableTableView *safeCenterTableView;
@property (retain, nonatomic) IBOutlet UIButton *checkButton;
@end
