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
    SK_RELEASE_SAFELY(_baseView);
    [_parameter release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        [self initWithNavi];
    }
    return self;
}

-(void)loadView{
    [super loadView];
    if(_baseView == nil){
        NSString *viewClassName =  NSStringFromClass([self class]);
        viewClassName = [viewClassName stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
        Class viewClass = NSClassFromString(viewClassName);
        if ([viewClass isSubclassOfClass:[UIView class]]) {
            id currentView = [[viewClass alloc] initWithFrame:self.view.bounds];
            self.baseView = currentView;
            [self.view  addSubview:currentView];
        }
    }else{
        [_baseView removeFromSuperview];
        [self.view addSubview:_baseView];
    }
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)initWithNavi{
    [UINavigationBar appearance].barTintColor = RGBCOLOR(110, 200, 255);
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];

//    UIBarButtonItem *vLeftButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backButtonClicked:)];
//    self.navigationItem.leftBarButtonItem = vLeftButtonItem;
//    [vLeftButtonItem release];
}

-(void)backButtonClicked:(id)aSender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showElertView:(NSString *)aMessage{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"注意" message:aMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
    [alerView release];
    alerView = nil;
}

@end
