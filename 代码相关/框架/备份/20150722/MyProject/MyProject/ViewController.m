//
//  ViewController.m
//  MyProject
//
//  Created by lin on 15-1-5.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"
#import "SKLocalSetting.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SKLocalSetting *vSet = [SKLocalSetting instanceSkLocalSetting];
    vSet.loginName  = @"sy4";
    vSet.loginPassword = @"123456";
    NSLog(@" vSet.loginName:%@", vSet.loginName);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSLog(@"docDir:%@",docDir);
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
