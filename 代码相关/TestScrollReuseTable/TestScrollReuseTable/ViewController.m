//
//  ViewController.m
//  TestScrollReuseTable
//
//  Created by lin on 14-5-28.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "ViewController.h"
#import "ScrollPageView.h"

@interface ViewController ()
{
    UIBarButtonItem *vEditBarItem;
    UIBarButtonItem *vDownBarButtonItem;
    ScrollPageView *mPageView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (mPageView == nil) {
        mPageView = [[ScrollPageView alloc] initWithFrame:self.view.frame];
        [mPageView setNumberOfTotalPages:4];
    }
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:mPageView];
    
    [self initTopBar];
}

-(void)initTopBar{
    if (vEditBarItem == nil) {
        vEditBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    }
    
    if (vDownBarButtonItem == nil) {
        vDownBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    }
    
    UISegmentedControl *vSegMentControl = [[UISegmentedControl alloc] initWithItems:@[@"+",@"-"]];
    [vSegMentControl setFrame:CGRectMake(0, 0, 60, 30)];
    [vSegMentControl addTarget:self action:@selector(segMentedControlClicked:) forControlEvents:UIControlEventValueChanged];
    [vSegMentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [vSegMentControl setMomentary:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vSegMentControl];
    self.navigationItem.rightBarButtonItem = vEditBarItem;
}

-(void)editAction:(id)sender{
    [self.navigationItem setRightBarButtonItem:vDownBarButtonItem animated:YES];
    [self EditAnamate];
}

-(void)doneAction:(id)sender{
    [self.navigationItem setRightBarButtonItem:vEditBarItem animated:YES];
    [self doneAnamate];
}

-(void)EditAnamate{
    mPageView.edit = YES;
    [UIView animateWithDuration:.2 animations:^{
        [mPageView.scrollView setTransform:CGAffineTransformMakeScale(.5, .5)];
        [mPageView.scrollView setClipsToBounds:NO];
    }];
}

-(void)doneAnamate{
    mPageView.edit = NO;
    [UIView animateWithDuration:.2 animations:^{
         [mPageView.scrollView setTransform:CGAffineTransformMakeScale(1, 1)];
    } completion:^(BOOL finished) {
        [mPageView.scrollView setClipsToBounds:YES];
    }];
}

-(void)segMentedControlClicked:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        
    }else{
        [mPageView removeCurrentPageView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
