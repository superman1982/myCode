//
//  HomePageViewController.m
//  MyProject
//
//  Created by lin on 15-1-14.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKHomePageViewController.h"
#import "UIViewController+SkViewControllerCategory.h"

@interface SKHomePageViewController ()

@end

@implementation SKHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutAction:(id)sender {
    [self.appDelegate showLoginViewControllerAnimated:YES];
}

@end
