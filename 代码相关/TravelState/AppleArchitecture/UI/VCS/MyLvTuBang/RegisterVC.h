//
//  RegisterVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableTableView.h"
#import "ChoseDistrictVC.h"
#import "SecrityButtonManeger.h"

@protocol RegisterVCDelegate <NSObject>
-(void)didRegistAndLoginSuccess:(BOOL)sender;
@end

@interface RegisterVC : BaseViewController<ClickableTableViewDelegate,UITextFieldDelegate,ChoseDistrictVCDelegate,SecrityButtonManegerDelegate>

//同意注册服务协议
@property (retain, nonatomic) IBOutlet UIView *xieYiFooterView;
@property (retain, nonatomic) IBOutlet ClickableTableView *registerTableView;
@property (nonatomic,retain) id<RegisterVCDelegate> delegate;
//是否选中我的旅途邦页面，因为有的地方登录成功后不需要选中
@property (nonatomic,assign)  BOOL    isSelectedView;

@end
