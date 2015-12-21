//
//  SLCustomUINavigationController.m
//  相机
//
//  Created by lin on 15-3-11.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SLCustomUINavigationController.h"
#import "SLCameraViewController.h"


@interface SLCustomUINavigationController ()
{
    BOOL _statusBarHiden;
}
@end

@implementation SLCustomUINavigationController

-(void)dealloc{
    if (!_statusBarHiden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _statusBarHiden = [UIApplication sharedApplication].statusBarHidden;

}

-(void)showCamera:(UIViewController *)aParentVC{
    _naviDelegate = aParentVC;
    [self setNavigationBarHidden:YES];
    [self setHidesBottomBarWhenPushed:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    SLCameraViewController *vCameraVC = [[SLCameraViewController alloc] init];
    [self setViewControllers:[NSArray arrayWithObject:vCameraVC]];
    [vCameraVC release];
    [aParentVC presentViewController:self animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ios6 +
- (BOOL)shouldAutorotate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DeviceRoatedNotification object:nil];
#if CAN_ROTATE
    return YES;
#else
    return NO;
#endif
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
