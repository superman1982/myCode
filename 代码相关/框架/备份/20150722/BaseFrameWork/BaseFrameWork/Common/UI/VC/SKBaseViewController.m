//
//  SKBaseViewController.m
//  Seework
//
//  Created by lin on 15-5-5.
//  Copyright (c) 2015年 seeyon. All rights reserved.
//

#import "SKBaseViewController.h"
#import "SKMacros.h"

@implementation SKBaseViewController

-(void)dealloc{
    [_parameter release];
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initWithNavi];
}

-(void)initWithNavi{
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x206ba7);
    UILabel *vTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
    vTitleLable.font = [UIFont boldSystemFontOfSize:17];
    vTitleLable.textColor = [UIColor whiteColor];
    vTitleLable.textAlignment = NSTextAlignmentCenter;
    vTitleLable.backgroundColor = [UIColor clearColor];
    vTitleLable.text = _titleStr;
    [self.navigationItem setTitleView:vTitleLable];
    [vTitleLable release];

}

-(void)showElertView:(NSString *)aMessage{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"注意" message:aMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
    [alerView release];
    alerView = nil;
}

@end
