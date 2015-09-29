//
//  ViewController.m
//  测试可移动菜单项
//
//  Created by lin on 14-6-6.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "ViewController.h"
#import "SyLCustomMenuView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SyLCustomMenuView *vCustomMenuView =[[SyLCustomMenuView alloc] initWithFrame:CGRectMake(0, 100, 320, 450) withCloum:3 Row:10];
    [self.view addSubview:vCustomMenuView];
    [vCustomMenuView release];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
