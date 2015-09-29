//
//  SecrityButtonManeger.m
//  lvtubangmember
//
//  Created by klbest1 on 14-3-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "SecrityButtonManeger.h"
#import "NetManager.h"

@implementation SecrityButtonManeger

-(id)init{
    self = [super init];
    if (self != Nil) {
        mseconds = 60;
    }
    return self;
}

#pragma mark 发送验证码
+(void)getSecrityCode:(NSString *)sender{
    if (sender == Nil || sender.length  == 0) {
        LOG(@"getSecrityCodeButtonClicked,电话号码输入有误");
        return;
    }
    NSMutableDictionary *vParemeterDic = [[NSMutableDictionary alloc] init];
    [vParemeterDic setObject:@"" forKey:@"userId"];
    [vParemeterDic setValue:sender forKey:@"receiver"];
    [vParemeterDic setObject:@"" forKey:@"content"];
    [vParemeterDic setObject:[NSNumber numberWithInt:0] forKey:@"type"];
    [NetManager postDataFromWebAsynchronous:APPURL105
                                  Paremeter:vParemeterDic
                                    Success:^(NSURLResponse *response, id responseObject) {
                                        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
                                        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
                                        if (vDataDic.count > 0) {
                                        }
                                        [SVProgressHUD showSuccessWithStatus:@"短信发送中，请稍后"];
                                    } Failure:^(NSURLResponse *response, NSError *error) {
                                        [SVProgressHUD showErrorWithStatus:@"获取验证码失败,请检查网络或重试"];
                                    } RequestName:@"获取验证码" Notice:@""];
    
}

-(UIButton *)creatSecrityCodeButton{
    UIButton *vCodeButton = [[UIButton alloc] init];
    vCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [vCodeButton setFrame:CGRectMake(242, 2, 76, 40)];
    [vCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [vCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vCodeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [vCodeButton setBackgroundColor:[UIColor orangeColor]];
    [vCodeButton addTarget:self action:@selector(getPhoneSecrityCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    vCodeButton.layer.cornerRadius = 5;
    vCodeButton.layer.masksToBounds = YES;
    return vCodeButton;
}

-(void)getPhoneSecrityCodeButtonClicked:(UIButton *)sender{
    //如果正在计时不执行以下操作
    if (isAcounting) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(didSecrityButtonManegerButtonClicked:)]) {
        NSString *vPhoneNumber = [_delegate didSecrityButtonManegerButtonClicked:Nil];
        if (vPhoneNumber.length > 0) {
            //发送验证码
            [SecrityButtonManeger getSecrityCode:vPhoneNumber];
            //开始计时
            if (mTimer == Nil) {
                mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount:) userInfo:sender repeats:YES];
            }
            if (![mTimer isValid]) {
                return;
            }
            //启动计时
            [mTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        }
    }
}

-(void)timeCount:(NSTimer *)sender{
    isAcounting = YES;
    UIButton *vCodeButton = (UIButton *)sender.userInfo;
    //显示倒计时
    mseconds--;
    [vCodeButton setTitle:[NSString stringWithFormat:@"%d",mseconds] forState:UIControlStateNormal];
    if (mseconds == 0) {
        ;
        mseconds = 60;
        isAcounting = NO;
        [vCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        //让计时器失效
        [mTimer setFireDate:[NSDate distantFuture]];
    }
}

@end
