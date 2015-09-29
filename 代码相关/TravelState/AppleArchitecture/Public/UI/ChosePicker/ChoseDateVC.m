//
//  ChoseDateVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChoseDateVC.h"
#import "AnimationTransition.h"


@interface ChoseDateVC ()
{
    CGRect mDestRect;
}
@end

@implementation ChoseDateVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ChoseDateVC" bundle:nibBundleOrNil];
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"ChoseDateVC_2x" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mDestRect = self.datePickerContentView.frame;
    mDestRect = CGRectMake(0, mDestRect.origin.y - 64, 320, mDestRect.size.height);
    mDateformate = [[NSDateFormatter alloc] init];
    [mDateformate setDateFormat:@"yyyy-MM-dd"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView animateChangeView:self.view AnimationType:vaFade SubType:0 Duration:.2 CompletionBlock:Nil];
    
    //移动DatePickerContenView
    CGRect vOriginRect =CGRectMake(0, mHeight, 320, mHeight);
    [UIView moveToView:self.datePickerContentView DestRect:mDestRect OriginRect:vOriginRect duration:.3 IsRemove:NO Completion:Nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#if __has_feature(objc_arc)
#else
// deallo
- (void)dealloc {
    [mDateformate release];
    [_datePickerView release];
    [_datePickerContentView release];
    [super dealloc];
}
#endif

- (void)viewDidUnload {
    [self setDatePickerView:nil];
    [self setDatePickerContentView:nil];
    [super viewDidUnload];
}

-(void)dateContentViewMoveOut{
    [UIView animateChangeView:self.view AnimationType:vaFade SubType:0 Duration:.2 CompletionBlock:Nil];
    //移动DatePickerContenView
    CGRect vOriginRect =CGRectMake(0, mHeight, 320, mHeight);
    [UIView moveToView:self.datePickerContentView DestRect:vOriginRect OriginRect:mDestRect duration:.2 IsRemove:NO Completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

#pragma mark - 其他业务点击事件
- (IBAction)confirmClicked:(id)sender {
    [self dateContentViewMoveOut];
    if ([_delegate respondsToSelector:@selector(didConfirmDate:)]) {
        NSString *vDateStr = [mDateformate stringFromDate:self.datePickerView.date];
        [_delegate didConfirmDate:vDateStr];
    }
}

- (IBAction)cancleClicked:(id)sender {
    [self dateContentViewMoveOut];
    if ([_delegate respondsToSelector:@selector(didCancleDate:)]) {
        NSString *vDateStr = [mDateformate stringFromDate:self.datePickerView.date];
        [_delegate didCancleDate:vDateStr];
    }
}

- (IBAction)dateValueChanged:(id)sender {
    if ([_delegate respondsToSelector:@selector(valueDidChange:)]) {
        NSString *vDateStr = [mDateformate stringFromDate:self.datePickerView.date];
        [_delegate valueDidChange:vDateStr];
    }
}

@end
