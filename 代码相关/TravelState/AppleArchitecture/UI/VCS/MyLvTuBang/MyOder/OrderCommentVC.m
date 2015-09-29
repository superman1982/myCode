//
//  OrderCommentVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-21.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "OrderCommentVC.h"
#import "AdviceVC.h"
#import "UserManager.h"
#import "NetManager.h"
#import "OrderDetailVC.h"
#import "MyOrdersVC.h"
#import "MyRouteOrderDetailVC.h"

@interface OrderCommentVC ()
{
    NSMutableArray *mButtonArrays;
    AdviceVC *mCommentVC;
    NSInteger mScore;
}
@end

@implementation OrderCommentVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"OrderCommentVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"OrderCommentVC" bundle:aBuddle];
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
    self.title = @"订单评价";
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 40, 44)];
    [vRightButton addTarget:self action:@selector(commentConfirmButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    mScore = 5;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mButtonArrays removeAllObjects];
    [mButtonArrays release];
    [_starContentView release];
    [_starOne release];
    [_starTwo release];
    [_starThree release];
    [_starFour release];
    [_starFive release];
    [_commentContentView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    mButtonArrays = [[NSMutableArray alloc]initWithObjects:
                     self.starOne,
                     self.starTwo,
                     self.starThree,
                     self.starFour,
                     self.starFive,
                     nil];
    //加载输入框
    if (mCommentVC == Nil) {
        mCommentVC = [[AdviceVC alloc] init];
        mCommentVC.needToMove = YES;
    }
    mCommentVC.placeHolder = @"请输入评论";
    CGRect vTextViewRect = mCommentVC.contentTextView.frame;
    [mCommentVC.contentTextView setFrame:CGRectMake(vTextViewRect.origin.x, vTextViewRect.origin.y, vTextViewRect.size.width, vTextViewRect.size.height-44)];
    [self.commentContentView addSubview:mCommentVC.view];

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
    [super viewShouldUnLoad];
}
//----------

- (void)viewDidUnload {
    [self setStarContentView:nil];
    [self setStarOne:nil];
    [self setStarTwo:nil];
    [self setStarThree:nil];
    [self setStarFour:nil];
    [self setStarFive:nil];
    [self setCommentContentView:nil];
    [super viewDidUnload];
}

#pragma mark - 其他辅助功能
-(void)clearButtons{
    for (UIButton *vButton in mButtonArrays) {
        [vButton setBackgroundImage:[UIImage imageNamed:@"orderComment_star_btn_default"] forState:UIControlStateNormal];
    }
}

-(void)addStarToButton:(NSInteger)aInedx{
    for (NSInteger i = 0 ; i < aInedx; i++) {
        UIButton *vButton = [mButtonArrays objectAtIndex:i];
        [vButton setBackgroundImage:[UIImage imageNamed:@"orderComment_star_btn_select"] forState:UIControlStateNormal];
    }
    
    for (NSInteger j = aInedx; j < 5; j++) {
        UIButton *vButton = [mButtonArrays objectAtIndex:j];
        [vButton setBackgroundImage:[UIImage imageNamed:@"orderComment_star_btn_default"] forState:UIControlStateNormal];
    }
}

#pragma mark 更新评价,付款等状态
-(void)refreshOderStuff{
    MyOrdersVC *vOrderVC = (MyOrdersVC *)[ViewControllerManager getBaseViewController:@"MyOrdersVC"];
    if (vOrderVC != nil) {
        [vOrderVC initWebData];
    }
    
    MyRouteOrderDetailVC *vMyRouteDetailVC = (MyRouteOrderDetailVC *)[ViewControllerManager getBaseViewController:@"MyRouteOrderDetailVC"];
    if (vMyRouteDetailVC != Nil) {
        [vMyRouteDetailVC initWebData];
    }
}

#pragma mark - 其他业务点击事件
- (IBAction)starButtonClicked:(UIButton *)sender {
    mScore = sender.tag;
    [self clearButtons];
    [self addStarToButton:sender.tag];
}

-(void)commentConfirmButtonTouchDown:(id)sender{
    NSString *evaluate = mCommentVC.contentTextView.text;
    if ([evaluate isEqualToString:mCommentVC.placeHolder]) {
        [SVProgressHUD showErrorWithStatus:@"请输入评论内容"];
        return;
    }
    id userId = [UserManager instanceUserManager].userID;
    id orderId = self.orderInfo.orderId;
    IFISNILFORNUMBER(orderId);
    NSNumber *score = [NSNumber numberWithInt:mScore];
    
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                userId,@"userId",
                                orderId,@"orderId",
                                score,@"score",
                                evaluate,@"evaluate",
                                nil];
    [NetManager postDataFromWebAsynchronous:APPURL813 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vStateNumber = [vReturnDic objectForKey:@"stateCode"];
        if (vStateNumber != Nil) {
            if ([vStateNumber intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"评价成功"];
                //跟新页面
                [self refreshOderStuff];
                [self back];
                return ;
            }
        }
        
        [SVProgressHUD showErrorWithStatus:@"评论失败"];
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"订单评价" Notice:@""];

}
@end
