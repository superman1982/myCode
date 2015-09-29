//
//  MemberCardDetailVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MemberCardDetailVC.h"
#import "UserManager.h"
#import "NetManager.h"

@interface MemberCardDetailVC ()

@end

@implementation MemberCardDetailVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
       self = [super initWithNibName:@"MemberCardDetailVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"MemberCardDetailVC" bundle:aBuddle];
    }
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
    self.title = @"会员卡详情";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    [self initWebData];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_detailTableView release];
    [_cardNo release];
    [_expireTime release];
    [_cardLevel release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
        if (IS_IPHONE_5) {
        }else{
        }
    }else{
    }
}

#pragma mark 内存处理
- (void)viewShouldUnLoad{
    [self setDetailTableView:nil];
    [super viewShouldUnLoad];
}
//----------

- (void)viewDidUnload {
    [self setDetailTableView:nil];
    [self setCardNo:nil];
    [self setExpireTime:nil];
    [self setCardLevel:nil];
    [super viewDidUnload];
}

#pragma mark - 其他辅助功能
-(void)initWebData{
    IFISNIL(self.cardNumber);
    id vUserId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserId,@"userId",
                                self.cardNumber,@"cardNo",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL810 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"请求会员卡详情" Notice:@""];
}

#pragma mark - 其他业务点击事件
- (IBAction)upGrandButtonClicked:(id)sender {
}
@end
