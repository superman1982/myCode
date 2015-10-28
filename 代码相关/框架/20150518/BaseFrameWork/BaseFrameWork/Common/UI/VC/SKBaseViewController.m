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
    _width = self.view.bounds.size.width;
    _height = self.view.bounds.size.height;
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
    self.view.backgroundColor = YK_BACKGROUND_COLOR;
}

-(void)initWithNavi{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; // 返回按钮颜色
    [UINavigationBar appearance].barTintColor = YK_BUTTON_COLOR; //背景颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]]; //标题title属性

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
