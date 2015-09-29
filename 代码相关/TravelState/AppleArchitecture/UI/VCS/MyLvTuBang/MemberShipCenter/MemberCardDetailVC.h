//
//  MemberCardDetailVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCardDetailVC : BaseViewController

@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
//卡号
@property (nonatomic,retain) id    cardNumber;
@property (retain, nonatomic) IBOutlet UILabel *cardLevel;

@property (retain, nonatomic) IBOutlet UILabel *cardNo;
@property (retain, nonatomic) IBOutlet UILabel *expireTime;
@end
