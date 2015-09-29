//
//  UPGrandMemberShipVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMemberShipCardVC : BaseViewController
@property (retain, nonatomic) IBOutlet UITableView *upGrandTableView;
//升级会员
@property (retain, nonatomic) IBOutlet UIView *footerView;
//我的vip介绍
@property (retain, nonatomic) IBOutlet UIView *myVIpCardHeaderView;

@property (retain, nonatomic) IBOutlet UILabel *cardLevel;
@property (retain, nonatomic) IBOutlet UILabel *expireTime;
@end
