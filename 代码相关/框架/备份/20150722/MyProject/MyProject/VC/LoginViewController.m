//
//  LoginViewController.m
//  MyProject
//
//  Created by lin on 15-1-6.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "LoginViewController.h"
#import "SKLocalSetting.h"
#import "SKLoginWebRequest.h"
#import "SKLoginOB.h"
#import "SKLoginRequestParam.h"
#import "UIDevice-Hardware.h"
#import "GTMUtil.h"
#import "UIViewController+SkViewControllerCategory.h"
#import "SKLocalSetting.h"

// app id
#define kAppID_InHouse_Pad	@"com.seeyon.oa.M1IPad"
#define kAppID_InHouse_Phone @"com.seeyon.oa6"
#define kAppID_AppStore_Pad @"com.seeyon.oa6.hd"
#define kAppID_AppStore_Phone @"com.seeyon.oa6.3"
#define kAppID_AppStore_M1Phone @"com.seeyon.oa.M1IPhone"

#define kC_iMessageClientProtocolType_IPad @"iPad"
#define kC_iMessageClientProtocolType_IPadInHouse @"iPadInHouse"
#define kC_iMessageClientProtocolType_IPhone @"iPhone"
#define kC_iMessageClientProtocolType_IPhoneInHouse @"iPhoneInHouse"

@interface LoginViewController ()<SkBaseWebRequestDelegate>

@end

@implementation LoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SKLocalSetting *vSet = [SKLocalSetting instanceSkLocalSetting];
    vSet.domain = @"http://211.157.139.215:9999";
//    vSet.port = @"9999";
//    vSet.loginName  = @"sy4";
//    vSet.loginPassword = @"123456";
//    [SkLocalSetting saveSetting];
//    NSLog(@" vSet.loginName:%@", vSet.loginName);
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSLog(@"docDir:%@",docDir);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    SKLoginOb *vLoingOb = [[SKLoginOb alloc] init];
    vLoingOb.username = [GTMUtil encrypt:_userAcountField.text];
    vLoingOb.password = [GTMUtil encrypt:_userPassword.text];
    vLoingOb.loginType = 3;
    NSString *vToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    vLoingOb.token = vToken;

    vLoingOb.clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    vLoingOb.protocolType = [self protocolType];
    NSString *deviceName = [NSString stringWithFormat:@"[%@]:%@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] name]] ;
    vLoingOb.deviceCode = [NSString stringWithFormat:@"%@|%@",deviceName,[[UIDevice currentDevice] macaddress]];
    vLoingOb.local = @"en";
    
    
    SKLoginRequestParam *vLoginRequestParam = [[SKLoginRequestParam alloc] initWithLoginOb:vLoingOb];
    SKLoginWebRequest *vLoginRequest = [[SKLoginWebRequest alloc] init];
    vLoginRequest.param = vLoginRequestParam;
    vLoginRequest.delegate = self;
    [vLoginRequest requestData];
    
    [vLoingOb release];
}

//消息推送注册协议
- (NSString*)protocolType
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString  *protocolType = @"" ;
    if ([identifier isEqualToString:kAppID_AppStore_Pad]) {
        protocolType = kC_iMessageClientProtocolType_IPad;
    }
    else if ([identifier isEqualToString:kAppID_AppStore_Phone]) {
        protocolType = kC_iMessageClientProtocolType_IPhone;
        
    }
    else if ([identifier isEqualToString:kAppID_InHouse_Pad]) {
        protocolType = kC_iMessageClientProtocolType_IPadInHouse;
    }
    else if ([identifier isEqualToString:kAppID_InHouse_Phone]) {
        protocolType = kC_iMessageClientProtocolType_IPhoneInHouse;
    }
    
    return protocolType;
}

-(void)didStartLoadData:(id)sender{
    
}

-(void)didLoadDataSucess:(SKBaseResponse *)aReponse WithRequest:(SKBaseWebRequest *)aRequest{
    [self.appDelegate showHomeViewController];
}

-(void)didLoadDataFailure:(id)sender Error:(NSError *)aError{
}

- (void)dealloc {
    [_rememberSwitch release];
    [_userAcountField release];
    [_userPassword release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setRememberSwitch:nil];
    [self setUserAcountField:nil];
    [self setUserPassword:nil];
    [super viewDidUnload];
}
@end
