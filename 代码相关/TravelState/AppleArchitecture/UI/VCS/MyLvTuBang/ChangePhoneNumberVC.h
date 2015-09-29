//
//  ChangePhoneNumberVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-17.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableTableView.h"
#import "SecrityButtonManeger.h"

@interface ChangePhoneNumberVC : BaseViewController<UITextFieldDelegate,ClickableTableViewDelegate,SecrityButtonManegerDelegate>

@property (retain, nonatomic) IBOutlet ClickableTableView *changePhoneTableView;
@end
