//
//  LoginViewController.h
//  MyProject
//
//  Created by lin on 15-1-6.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKLoginViewController.h"

@interface LoginViewController : SKLoginViewController

@property (retain, nonatomic) IBOutlet UISwitch *rememberSwitch;
@property (retain, nonatomic) IBOutlet UITextField *userAcountField;
@property (retain, nonatomic) IBOutlet UITextField *userPassword;
@end
