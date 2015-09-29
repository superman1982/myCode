//
//  FindPassWord.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableTableView.h"
#import "SecrityButtonManeger.h"

@interface FindPassWord : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SecrityButtonManegerDelegate>

@property (retain, nonatomic) IBOutlet UIView *hotLineFooterView;
@property (retain, nonatomic) IBOutlet ClickableTableView *findPasswordTableView;
@end
