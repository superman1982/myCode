//
//  JiFenTranferVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-12.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableTableView.h"

@interface JiFenTranferVC : BaseViewController<UITableViewDataSource,UITextFieldDelegate,ClickableTableViewDelegate>
//积分headerView
@property (retain, nonatomic) IBOutlet UIView *jiFenHeaderView;
//可用积分
@property (retain, nonatomic) IBOutlet UILabel *couldUserJiFen;
//积分转换tablView
@property (retain, nonatomic) IBOutlet ClickableTableView *jiFenTranferTableView;
//确认View
@property (retain, nonatomic) IBOutlet UIView *xunWenView;
@property (retain, nonatomic) IBOutlet UILabel *tuBiLable;
@end
