//
//  AgrementVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

// 协议类型
typedef enum {
    atRegister=1,
    atBook,
    atMakeCar,
} AgrementType;

@interface AgrementVC : BaseViewController
//注册协议
@property (retain, nonatomic) IBOutlet UITextView *agrementTextView;
//拼车协议
@property (retain, nonatomic) IBOutlet UITextView *makeCarAgrement;
//报名协议
@property (retain, nonatomic) IBOutlet UITextView *bookAgrement;

#pragma mark 设置协议类型
-(void)setAgrementType:(AgrementType)aType;

@end
