//
//  LoginVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginVCDelegate <NSObject>
-(void)didLoginSuccess:(BOOL)sender;
@end
@interface LoginVC : BaseViewController<UITextFieldDelegate>
//账号
@property (retain, nonatomic) IBOutlet UITextField *acountField;
//密码
@property (retain, nonatomic) IBOutlet UITextField *passWordField;
//记住密码
@property (retain, nonatomic) IBOutlet UIButton *checkPasswordButton;

@property (nonatomic,assign)  BOOL           isSelectedView;

@property (nonatomic,assign) id delegate;
@end
