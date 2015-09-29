//
//  SetViewController.m
//  BaseArchitecture
//
//  Created by lin on 14-8-4.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "SetViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFNetWorkClient.h"
#import "NetManager.h"
#import "SyDataUtil.h"

#define IP_DOMAINKEY  @"ipDoMainkey"

@interface SetViewController ()
{
    UITextField *inputIpField;
    UITextField *inputPortField;
    NetManager *net;
}
@end

@implementation SetViewController

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
    self.title = @"设置域名";
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
    SAFE_ARC_RELEASE(inputIpField);
    SAFE_ARC_RELEASE(inputPortField);
    [super dealloc];
}
#endif


// 初始经Frame
- (void) initView: (BOOL) aPortait {
    if(inputPortField == nil){
        inputPortField = [UITextField createTextFieldWithFrontSize:15 Delegate:self PlaceHolder:@"placeHolder" BackGroundColoer:[UIColor orangeColor]];
    }
    if (inputIpField == nil) {
        inputIpField = [UITextField createTextFieldWithFrontSize:15 Delegate:self PlaceHolder:@"placeHolder" BackGroundColoer:[UIColor orangeColor]];
    }

    inputIpField.text = @"211.157.139.215";
    inputPortField.text = @"9946";
    
    UIButton *vConnectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vConnectButton setFrame:CGRectMake(200, 60, 60, 40)];
    [vConnectButton setTitle:@"连接" forState:UIControlStateNormal];
    [vConnectButton setBackgroundColor:[UIColor blueColor]];
    [vConnectButton addTarget:self action:@selector(connectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:inputIpField];
    [self.view addSubview:inputPortField];
    [self.view addSubview:vConnectButton];
    
    [self setViewFrame:aPortait];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(BOOL)checkIfHasSavedTheIPDomain:(NSString *)aIpStr{
    NSArray *vIpArray = [[NSUserDefaults standardUserDefaults] objectForKey:IP_DOMAINKEY];
    
    for (NSString *ip in vIpArray) {
        if ([aIpStr isEqualToString:ip]) {
            return YES;
        }
    }
    return NO;
}

-(void)addIpDomain:(NSString *)aDoMain Port:(NSString *)aPort{
    NSString *vNewIPStr = [NSString stringWithFormat:@"https://%@:%@",aDoMain,aPort];
    
    if (![self checkIfHasSavedTheIPDomain:vNewIPStr]) {
        NSMutableArray *vIPArray = [[NSUserDefaults standardUserDefaults] objectForKey:IP_DOMAINKEY];
        if (vIPArray == nil) {
            vIPArray = [NSMutableArray array];
        }
        
        [vIPArray addObject:vNewIPStr];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IP_DOMAINKEY];
        [[NSUserDefaults standardUserDefaults] setObject:vIPArray forKey:IP_DOMAINKEY];
    }
    
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{
            [inputIpField setFrame:CGRectMake(10, 20, 180, 41)];
            [inputPortField setFrame:CGRectMake(210, 20, 50, 41)];
        }
    }else{
    }
}

#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [super viewShouldUnLoad];
}

-(void)back{
    [super back];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//----------

#pragma mark 点击事件
-(void)connectedButtonClicked:(UIButton *)aSender{
    if (inputIpField.text.length == 0) {
        return;
    }
    [self addIpDomain:inputIpField.text Port:@"9946"];
    
    NSArray *vIPArray = [[NSUserDefaults standardUserDefaults] objectForKey:IP_DOMAINKEY];
    if (vIPArray.count == 0) {
        return;
    }
    NSString *vURLPath = [[[NSUserDefaults standardUserDefaults] objectForKey:IP_DOMAINKEY] lastObject];
    vURLPath = [vURLPath stringByAppendingString:@"/seeyon/servlet/SeeyonMobileBrokerServlet?serviceProcess=A6A8_Common&responseCompress=gzip"];
    //URL
    vURLPath =(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)vURLPath, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    //Paremeter
    NSDictionary *vParemeter = @{@"managerMethod": @"getUpdateServerInfo",
                                 @"managerName":@"mMOneProfileManager"};
    
    [NetManager postURLData:vURLPath Parameter:vParemeter Success:^(id responseObject, NSError *error) {
        NSString *vDataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *vData = [vDataStr dataUsingEncoding:NSISOLatin1StringEncoding];
        NSData *decompressData = [SyDataUtil uncompressZippedData:(NSMutableData *)vData];
        NSString  *responseString = [[[NSString alloc] initWithData:decompressData encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"收到回复：%@",responseString);
    } Failure:^(id responseObject, NSError *error) {
        NSLog(@"失败！");
    }];
}

@end
