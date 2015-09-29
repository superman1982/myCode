//
//  NickNameVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol NickNameVCDelegate <NSObject>

-(void)textFieldDidFilled:(NSString *)aStr;
@end
@interface NickNameVC : BaseViewController<UITextFieldDelegate>
//昵称输入框
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (nonatomic,assign)  BOOL isFillIDCard;

@property (nonatomic,assign) id<NickNameVCDelegate> delegate;
@property (nonatomic,assign) BOOL isInputWithDigits;
@end
