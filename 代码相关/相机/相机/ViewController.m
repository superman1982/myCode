//
//  ViewController.m
//  相机
//
//  Created by lin on 15-3-11.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"
#import "SLCustomUINavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)dealloc{
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    SLCustomUINavigationController *vNavi = [[SLCustomUINavigationController alloc] init];
    [vNavi showCamera:self];
    [vNavi release];
}

-(void)didTakePhotoSuccess:(UIImage *)photo{
    NSLog(@"photo:%@",photo);
}
@end
