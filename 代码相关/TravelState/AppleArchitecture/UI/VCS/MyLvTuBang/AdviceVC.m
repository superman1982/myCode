//
//  AdviceVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AdviceVC.h"
#import "StringHelper.h"
#import "AnimationTransition.h"
#import "UserManager.h"
#import "NetManager.h"

@interface AdviceVC ()
{
    CGRect mOriginRect;
    CGRect mDestineRect;
}
@end

@implementation AdviceVC
//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"AdviceVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"AdviceVC" bundle:aBuddle];
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
    self.title = @"意见反馈";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(confirmAdviceButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    self.placeHolder = @"请输入意见反馈,最多300字";
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_contentTextView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    CGRect textRect = self.contentTextView.frame;
    [self.contentTextView setFrame:CGRectMake(textRect.origin.x, textRect.origin.y + 10, textRect.size.width, textRect.size.height)];
    [self.view addSubview:self.contentTextView];
    mOriginRect = self.view.frame;
    mDestineRect = CGRectMake(mDestineRect.origin.x, mDestineRect.origin.y - 50, 320, mOriginRect.size.height);
    self.contentTextView.layer.borderWidth = 1;
    self.contentTextView.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
    self.contentTextView.text = self.placeHolder;
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
//----------

- (void)viewDidUnload {
    [self setContentTextView:nil];
    [super viewDidUnload];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:self.placeHolder]) {
        textView.text = @"";
    }
    
}
//@"请输入意见反馈,最多300字"
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = self.placeHolder;
    }
    //如果已经移动了self.view的位置那么移回原来的位置
    if (self.view.frame.origin.y == mDestineRect.origin.y) {
        [UIView moveToView:self.view DestRect:mOriginRect
                OriginRect:mDestineRect duration:.2 IsRemove:NO Completion:Nil];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSInteger vCharactorCount = [StringHelper textLength:textView.text];
    LOG(@"已经输入%d",vCharactorCount);
    if (vCharactorCount >= 300) {
        //移动回原位置
        if (self.view.frame.origin.y == mDestineRect.origin.y) {
            [UIView moveToView:self.view DestRect:mOriginRect
                    OriginRect:mDestineRect duration:.2 IsRemove:NO Completion:^(BOOL finished) {
                        [textView resignFirstResponder];
                    }];
        }
    }
    
    //移动View的最大输入字符数，因为超过该数量，键盘会挡住textView
    NSInteger maxCharactor = 58;
    if (IS_IPHONE_5) {
        maxCharactor = 130;
    }
    //当本View被其他View加载时，移动位置
    if (self.needToMove) {
        //向上移动输入位置
        if (vCharactorCount > maxCharactor && self.view.frame.origin.y != mDestineRect.origin.y) {
            [UIView moveToView:self.view DestRect:mDestineRect
                    OriginRect:mOriginRect duration:.2 IsRemove:NO Completion:Nil];
        }
    }
    //输入回车时，结束输入
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


#pragma mark 其他业务点击事件
-(void)confirmAdviceButtonTouchDown:(id)sender{
    NSString *content = self.contentTextView.text;
    if (content.length == 0 || [content isEqualToString:self.placeHolder]) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    
    id vUserId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:vUserId,@"userId",content,@"content", nil];
    [NetManager postDataFromWebAsynchronous:APPURL1003 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber  *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功，感谢您的车途邦的关注！"];
                [self back];
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"提交意见" Notice:@""];
    
}
@end
