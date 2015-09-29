//
//  OrderCommentVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

@interface OrderCommentVC : BaseViewController

@property (retain, nonatomic) IBOutlet UIView *starContentView;

@property (retain, nonatomic) IBOutlet UIButton *starOne;

@property (retain, nonatomic) IBOutlet UIButton *starTwo;
@property (retain, nonatomic) IBOutlet UIButton *starThree;
@property (retain, nonatomic) IBOutlet UIButton *starFour;
@property (retain, nonatomic) IBOutlet UIButton *starFive;
//评论View
@property (retain, nonatomic) IBOutlet UIView *commentContentView;
@property (nonatomic,retain)  OrderInfo  *orderInfo;

#pragma mark 更新评价,付款等状态
-(void)refreshOderStuff;
@end
