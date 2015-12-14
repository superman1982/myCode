//
//  ViewController.m
//  测试键盘遮挡输入内容
//
//  Created by lin on 15/11/15.
//  Copyright © 2015年 lin. All rights reserved.
//

#import "ViewController.h"
#import "YKKeyboardHandler.h"

@interface ViewController ()<KBKeyboardHandlerDelegate>
{
    YKKeyboardHandler *keyboard;
}
@end

@implementation ViewController

-(void)dealloc{
    keyboard.delegate = nil;
    [keyboard release];
    [_textView release];
    [_scrollView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    [self.view addSubview:_scrollView];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);

    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height - 200, self.view.frame.size.width- 80, 200)];
        _textView.text = @"wo chaohgoahgoahgo";
    }
    [_scrollView addSubview:_textView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.scrollView addGestureRecognizer:tap];
    
    keyboard = [[YKKeyboardHandler alloc] init];
    keyboard.delegate = self;
    
}

-(void)tap:(id)sender{
    [_textView resignFirstResponder];
}

-(void)keyboardSizeChanged:(CGSize)delta
{
    // Resize / reposition your views here. All actions performed here
    // Sample:
    CGRect frame = self.scrollView.frame;
    frame.size.height -= delta.height;
    self.scrollView.frame = frame;
    
    CGFloat yOffset = _textView.frame.origin.y - frame.size.height + _textView.frame.size.height;
    [self.scrollView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
