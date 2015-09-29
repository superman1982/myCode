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

@interface LoginViewController ()<SkBaseWebRequestDelegate,UITextFieldDelegate>
{
    SKLoginWebRequest *_loginRequest;
}
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
    [_rememberSwitch setOn:vSet.isRememberPassWord];
    if (vSet.isRememberPassWord) {
        _userAcountField.text= [GTMUtil decrypt:vSet.loginName];
        _userPassword.text = [GTMUtil decrypt:vSet.loginPassword];
    }
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
    if (_loginRequest == nil) {
        _loginRequest = [[SKLoginWebRequest alloc] init];
    }
    _loginRequest.param = vLoginRequestParam;
    _loginRequest.delegate = self;
    [_loginRequest requestData];
    
    [vLoingOb release];
}

- (IBAction)switchAction:(UISwitch *)sender {
    [SKLocalSetting instanceSkLocalSetting].isRememberPassWord = sender.on;
}

- (IBAction)cancelAction:(id)sender {
//    if (_loginRequest.requestOperation.isExecuting) {
        [_loginRequest.requestOperation cancel];
//    }
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
    if ( [SKLocalSetting instanceSkLocalSetting].isRememberPassWord) {
        [SKLocalSetting instanceSkLocalSetting].loginName = [GTMUtil encrypt:_userAcountField.text];
        [SKLocalSetting instanceSkLocalSetting].loginPassword = [GTMUtil encrypt:_userPassword.text];
        [SKLocalSetting saveSetting];
    }else{
        [SKLocalSetting instanceSkLocalSetting].loginName = @"";
        [SKLocalSetting instanceSkLocalSetting].loginPassword = @"";
        [SKLocalSetting saveSetting];
    }
}

-(void)didLoadDataFailure:(id)sender Error:(NSError *)aError{
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
