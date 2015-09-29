//
//  NickNameVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-10.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "NickNameVC.h"

@interface NickNameVC ()

@end

@implementation NickNameVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"NickNameVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"NickNameVC" bundle:aBuddle];
    }
    
    if (self != nil) {
        [self initCommonData];
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {
    [super setLayout: aPortait];
    [self setViewFrame:aPortait];
}

//重载导航条
-(void)initTopNavBar{
    [super initTopNavBar];
    self.title = @"昵称";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(saveButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_inputTextField release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    if (_isInputWithDigits) {
        self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{
        }
    }else{
    }
}
#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}
//------------------------

-(void)setIsFillIDCard:(BOOL)isFillIDCard{
    _isFillIDCard = isFillIDCard;
    if (isFillIDCard) {
        self.title = @"身份证号";
    }
}
#pragma mark 其他业务点击事件
-(void)saveButtonTouchDown:(id)sender{
    if (self.inputTextField.text.length > 0) {
        if ([_delegate respondsToSelector:@selector(textFieldDidFilled:)]) {
            [_delegate textFieldDidFilled:self.inputTextField.text];
            [self back];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 屏幕点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.inputTextField.frame,vTouchPoint)) {
        [self.inputTextField resignFirstResponder];
    }
}

- (void)viewDidUnload {
[self setInputTextField:nil];
[super viewDidUnload];
}
@end
