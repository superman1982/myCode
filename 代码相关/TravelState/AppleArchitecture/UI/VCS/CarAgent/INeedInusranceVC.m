//
//  INeedInusranceVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-5-8.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "INeedInusranceVC.h"
#import "InsuranceDetailVC.h"

@interface INeedInusranceVC ()

@end

@implementation INeedInusranceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _LowPriceButton.layer.cornerRadius = 5;
   _LowPriceButton.layer.masksToBounds = YES;
    
    _changYongProjectButton.layer.cornerRadius = 5;
    _changYongProjectButton.layer.masksToBounds = YES;
    
    _JiChuProjectButton.layer.cornerRadius = 5;
    _JiChuProjectButton.layer.masksToBounds = YES;
    
    _jinJiButton.layer.cornerRadius = 5;
    _jinJiButton.layer.masksToBounds = YES;
    
    _zuiJiaProjectButton.layer.cornerRadius = 5;
    _zuiJiaProjectButton.layer.masksToBounds = YES;
    
    _wanQuanProjectButton.layer.cornerRadius = 5;
    _wanQuanProjectButton.layer.masksToBounds = YES;
    
    self.title = @"我要投保";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lowPriceButtonClicked:(UIButton *)sender {
    [self goToInsurnceDetailVC:sender.tag];
}
- (IBAction)changYongButtonClicked:(UIButton *)sender {
    [self goToInsurnceDetailVC:sender.tag];
}
- (IBAction)jiChuButtonClicked:(UIButton *)sender {
    [self goToInsurnceDetailVC:sender.tag];
}
- (IBAction)jinJIButtonClicked:(UIButton *)sender {
    [self goToInsurnceDetailVC:sender.tag];
}
- (IBAction)zuiJiaButtonClicked:(UIButton *)sender {
    [self goToInsurnceDetailVC:sender.tag];
}

- (IBAction)wanQuanButtonClicked:(UIButton *)sender {
    [self goToInsurnceDetailVC:sender.tag];
}

-(void)goToInsurnceDetailVC:(NSInteger)aTag{
    [ViewControllerManager createViewController:@"InsuranceDetailVC"];
    InsuranceDetailVC *vVC = (InsuranceDetailVC *)[ViewControllerManager getBaseViewController:@"InsuranceDetailVC"];
    vVC.chosedTag = aTag;
    [ViewControllerManager showBaseViewController:@"InsuranceDetailVC" AnimationType:vaDefaultAnimation SubType:0];
}


@end
