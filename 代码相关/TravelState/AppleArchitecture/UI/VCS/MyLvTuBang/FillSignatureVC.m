//
//  FillSignatureVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "FillSignatureVC.h"

@interface FillSignatureVC ()

@end

@implementation FillSignatureVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"FillSignatureVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"FillSignatureVC" bundle:aBuddle];
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
    self.title = @"签名";
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
-(void)dealloc
{
    [_signatureTextView release];
    [super dealloc];
}
#endif


// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.signatureTextView.layer.borderWidth = 1;
    self.signatureTextView.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
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
#pragma mark TextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 屏幕点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (!CGRectContainsPoint(self.signatureTextView.frame,vTouchPoint)) {
        [self.signatureTextView resignFirstResponder];
    }
}

#pragma mark - 业务点击事件
-(void)saveButtonTouchDown:(UIButton *)sender{
    if (self.signatureTextView.text.length > 0) {
        if ([_delegate respondsToSelector:@selector(didFillSignatureFinished:)]) {
            [_delegate didFillSignatureFinished:self.signatureTextView.text];
            [self back];
        }
    }
}

- (void)viewDidUnload {
[self setSignatureTextView:nil];
[super viewDidUnload];
}
@end
