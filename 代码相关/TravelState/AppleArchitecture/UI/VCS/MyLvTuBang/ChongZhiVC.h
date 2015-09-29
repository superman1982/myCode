//
//  ChongZhiVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableTableView.h"
#import "AliPayManeger.h"

@interface ChongZhiVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ClickableTableViewDelegate>

@property (retain, nonatomic) IBOutlet ClickableTableView *chongZhiTableView;

@property (retain, nonatomic) IBOutlet UIView *chongZhiFooterView;
@property (retain, nonatomic) IBOutlet UILabel *chongZhiMoneyLable;
@property (retain, nonatomic) IBOutlet UILabel *giveMoneyLable;
@end
