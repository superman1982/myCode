//
//  HomePageViewController.m
//  MyProject
//
//  Created by lin on 15-1-14.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "HomePageViewController.h"
#import "UIViewController+SkViewControllerCategory.h"
#import "SKCacheImageViewController.h"
#import "SKCacheViewControllerParameter.h"
#import "SKLocalSetting.h"
#import "SKWelcomeViewController.h"

#define  SkCacheImageVCTag       @"skcacheimagevctag"

@interface HomePageViewController ()<SKCacheImageViewControllerDelegate>
{
    SKWelcomeViewController *_welcomePageViewController;
}
@end

@implementation HomePageViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{
    [_welcomePageViewController release],_welcomePageViewController = nil;
    [_moduleDics removeAllObjects],_moduleDics = nil;
    [_homeImageView release];
    [_homeImageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_moduleDics == nil) {
        _moduleDics = [[NSMutableDictionary alloc] init];
    }
    
    if ([SKLocalSetting instanceSkLocalSetting].needShowWelcomePages) {
        _welcomePageViewController = [[SKWelcomeViewController alloc] init];
        _welcomePageViewController.view.frame = AppDelegateInstance.window.bounds;
        [self.view addSubview:_welcomePageViewController.view];
    }
    
    CGRect screenRect = [UIScreen mainScreen].applicationFrame;
    if (_cacheImageButton == nil) {
        _cacheImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cacheImageButton addTarget:self action:@selector(cacheImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _cacheImageButton.frame = CGRectMake(screenRect.size.width - 110, screenRect.size.height - 30, 100, 44);
//        _cacheImageButton.backgroundColor = [UIColor blueColor];
        [_cacheImageButton setTitle:@"列表图片缓存" forState:UIControlStateNormal];
    }
    [self.view addSubview:_cacheImageButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutAction:(id)sender {
    [self.appDelegate showLoginViewControllerAnimated:YES];
}

- (IBAction)cacheImageButtonClicked:(id)sender {
    UINavigationController *vNavi = [_moduleDics objectForKey:SkCacheImageVCTag];
    if (vNavi == nil) {
        SKCacheImageViewController *vSKCacheVC = [[SKCacheImageViewController alloc] init];
        SKCacheViewControllerParameter *vParameter = [[SKCacheViewControllerParameter alloc] init];
        vParameter.delegate = self;
        vParameter.modulTag = SkCacheImageVCTag;
        vSKCacheVC.parameter = vParameter;
        
        vNavi = [[UINavigationController alloc] initWithRootViewController:vSKCacheVC];
        [_moduleDics setObject:vNavi forKey:SkCacheImageVCTag];
        [vNavi release];
        [vSKCacheVC release];
        [vParameter release];
    }
    
    [self.view addSubview:vNavi.view];

}


#pragma mark BackDelegate
-(void)backButtonClicked:(SKCacheViewControllerParameter *)sender{
    UINavigationController *vNaiv = [_moduleDics objectForKey:sender.modulTag];
    if (vNaiv != nil) {
        [vNaiv.view removeFromSuperview ];
    }
}
@end
