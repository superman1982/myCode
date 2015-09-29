//
//  LoginViewController.m
//  BaseArchitecture
//
//  Created by lin on 14-8-5.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginParemeter.h"
#import "JSONKit.h"
#import "NetManager.h"
#import "SyDataUtil.h"
#import "WelcomeAnimationVC.h"

@interface LoginViewController ()
{
    UITextField *acountField;
    UITextField *passWordField;
}
@end

@implementation LoginViewController

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
        [self initCommonData];
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {
    [super setLayout: aPortait];
    [self setViewFrame:aPortait];
}

//重载导航条
-(void)initTopNavBar{
    [super initTopNavBar];
    self.title = @"登录";
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [super dealloc];
}
#endif


// 初始经Frame
- (void) initView: (BOOL) aPortait {
    if (acountField == nil) {
        acountField = [UITextField createTextFieldWithFrontSize:15 Delegate:self PlaceHolder:@"placeHolder" BackGroundColoer:[UIColor orangeColor]];
    }
    
    if (passWordField == nil) {
        passWordField = [UITextField createTextFieldWithFrontSize:15 Delegate:self PlaceHolder:@"placeHolder" BackGroundColoer:[UIColor orangeColor]];
    }
    
    UIButton *vConnectButton = [UIButton  createButtonWithFrame:CGRectMake(200, 70, 60, 40) Title:@"登录" NormalImage:nil HelightImage:nil Target:self SELTOR:@selector(loginButtonClicked:)];
    
    UIButton *vSetButton = [UIButton  createButtonWithFrame:CGRectMake(200, 120, 60, 40) Title:@"设置" NormalImage:nil HelightImage:nil Target:self SELTOR:@selector(setButtonClicked:)];
    
    UIButton *vTestMemberResourceButton = [UIButton  createButtonWithFrame:CGRectMake(200, 170, 120, 40) Title:@"获取会员数据" NormalImage:nil HelightImage:nil Target:self SELTOR:@selector(memberResourceButtonButtonClicked:)];
    
    [self.view addSubview:vSetButton];
    [self.view addSubview:acountField];
    [self.view addSubview:passWordField];
    [self.view addSubview:vConnectButton];
    [self.view addSubview:vTestMemberResourceButton];
    
    [self setViewFrame:aPortait];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"self.view.height%f",self.view.frame.size.height);
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{

        }
        [acountField setFrame:CGRectMake(10, 20, 180, 41)];
        [passWordField setFrame:CGRectMake(210, 20, 50, 41)];
    }else{
    }
}

#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}

-(void)back{
}

-(void)loginButtonClicked:(id)sender{
    NSDictionary *vDic = @{protocolType: @"iPhoneInHouse",
                           clientVersion: @"5.1.0",
                           password: @"123456",
                           loginType: [NSNumber numberWithInt:3],
                           verifyCode: [NSNull null],
                           deviceCode:@"[iPhone Simulator]:iPhone Simulator|93249FC9-D0C9-41A7-8750-86672F0B3CA4",
                           timezone: [NSNull null],
                           local: @"en",
                           token: @"",
                           username: @"zl5",};
    NSArray *vArrayWithDic = @[vDic];
    NSString *vJsonStr = [vArrayWithDic JSONString];
    NSDictionary *vParemeter = @{@"arguments": vJsonStr,
                                 @"managerMethod":@"transLogin",
                                 @"managerName":@"mLoginManager",
                                 };
    
    [NetManager postURLData:@"SeeyonMobileBrokerServlet?serviceProcess=A6A8_Common&responseCompress=gzip" Parameter:vParemeter Success:^(id responseObject, NSError *error) {
        NSString *vDataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *vData = [vDataStr dataUsingEncoding:NSISOLatin1StringEncoding];
        NSData *decompressData = [SyDataUtil uncompressZippedData:(NSMutableData *)vData];
        NSString  *responseString = [[[NSString alloc] initWithData:decompressData encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"收到回复：%@",responseString);
    } Failure:^(id responseObject, NSError *error) {
        NSLog(@"失败！");
    }];

}

-(void)memberResourceButtonButtonClicked:(id)sender{
    NSArray *vArguments = @[[NSNumber numberWithLongLong:6463744246298723057],
                            [NSNumber numberWithLongLong:-5136318525231052114],
                            ];
    NSString *vJsonStr = [vArguments JSONString];
    NSDictionary *vParemeter = @{@"arguments":vJsonStr,
                                 @"managerMethod":@"getMemberResourcesById",
                                 @"managerName":@"mPrivilegeManager",};
    [NetManager postURLData:@"SeeyonMobileBrokerServlet?serviceProcess=A6A8_Common&responseCompress=gzip" Parameter:vParemeter Success:^(id responseObject, NSError *error) {
        NSString *vDataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *vData = [vDataStr dataUsingEncoding:NSISOLatin1StringEncoding];
        NSData *decompressData = [SyDataUtil uncompressZippedData:(NSMutableData *)vData];
        NSString  *responseString = [[[NSString alloc] initWithData:decompressData encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"收到回复：%@",responseString);
    } Failure:^(id responseObject, NSError *error) {
        NSLog(@"失败！");
    }];
}

-(void)setButtonClicked:(id)sender{
    [[ViewControllerManager getViewControllerManagerWithKey:NOMAL_MANEGER]createViewController:@"SetViewController"];
    [[ViewControllerManager getViewControllerManagerWithKey:NOMAL_MANEGER]showBaseViewController:@"SetViewController" AnimationType:vaCube SubType:0];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    WelcomeAnimationVC *vWelcome = [[WelcomeAnimationVC alloc] init];
//    [self.navigationController pushViewController:vWelcome animated:YES];
//    [vWelcome release];
}
@end
