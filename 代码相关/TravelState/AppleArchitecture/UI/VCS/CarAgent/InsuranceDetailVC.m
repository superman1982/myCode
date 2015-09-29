//
//  InsuranceDetailVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-5-8.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "InsuranceDetailVC.h"
#import "StringHelper.h"
#import "UserManager.h"
#import "NetManager.h"

@interface InsuranceDetailVC ()
@property (nonatomic,retain) NSArray *insuranceInfoArray;
@end

@implementation InsuranceDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          _insuranceInfoArray = @[
                                  @"套餐一：最低保障方案 \n险种组合： 交强险+第三者责任险10万+不计免赔+税收\n保障范围：只对被保险人驾车发生事故造成的第三者人身伤亡和财产损失负赔偿责任。一旦撞车或撞人，对方的损失能得到保险公司的一些赔偿，但自己车的损失只有自己负担。\n适用对象：车辆使用较长时间、驾驶技术娴熟、想减少保费支出的车主。\n特点：只有最低保障，费用低。",
                                  @"套餐二：最常用方案\n险种组合：交强险+第三者责任险20万+座位险1万+不计免赔+税收\n保障范围：包括基本险的保障范围，如自然灾害和意外事故造成的车辆损失，驾驶保险车辆对第三者造成的损失。\n适用对象：有安全保障的停车位，有一定驾龄、愿意自己承担部分风险的车主。\n特点：费用适度，能够提供基本的保障，但保障额度不够大。",
                                  @"套餐三：基础保障方案\n险种组合：交强险+第三者责任险30万+座位险2万+不计免赔+税收\n保障范围：对被保险人驾车发生事故造成的第三者人身伤亡和财产损失负赔偿责任，同时兼顾车上人员伤亡、丢失和100%赔付等风险。\n适用对象：有一定经济压力的车主。\n特点：费用适度，经济实用。",
                                  @"套餐四：经济保障方案\n险种组合：交强险+第三者责任险50万+座位险2万+不计免赔+税收\n保障范围：对被保险人驾车发生事故造成的第三者的人伤和物损、车上人员的伤亡有更大的保障，人们最关心的丢失和100%赔付等大风险都有保障。\n适用对象：经济充裕、精打细算的车主。\n特点：对于老手来说保险性价比最高",
                                  @"套餐五：最佳保障方案\n险种组合：车辆损失险＋第三者责任险30万＋不计免赔特约险＋车上责任险\n保障范围：在经济保障方案的基础上加入了车辆损失险，对自身的保障更全面。\n适用对象：新车、新手\n特点：投保价值大，物有所值。 ",
                                  @"套餐六：完全保障方案\n险种组合：车辆损失险＋第三者责任险50万＋不计免赔特约险＋车上责任险+玻璃破碎险+指定专修厂险\n保障范围：能保的险种全部投保，驾驶、修理车辆过程中可能遇到的风险基本都能得到保障。\n适用对象：适合高档车、新车新手或需全面保障型的车主。\n特点：几乎与汽车有关的全部事故损失都能得到赔偿，投保的人不必因少保某一个险种而得不到某些赔偿。但保全险保费高，某些险种出险的几率非常小。",
                                  ];
    }
    return self;
}


//重载导航条
-(void)initTopNavBar{
    [super initTopNavBar];
    UIButton *vRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vRightButton setTitle:@"我要投保" forState:UIControlStateNormal];
    [vRightButton setFrame:CGRectMake(0, 0, 80, 44)];
    [vRightButton addTarget:self action:@selector(iNeedInsuranceButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vRightButton];
    self.navigationItem.rightBarButtonItem = vBarButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"保险详情";
    // Do any additional setup after loading the view from its nib.
    self.insuranceDescTextView.layer.borderWidth = 1;
    self.insuranceDescTextView.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
    self.noticeContentView.layer.cornerRadius = 10;
    self.noticeContentView.clipsToBounds = YES;
    self.confirmButton.layer.borderWidth = 1;
    self.confirmButton.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
    
    if (_insuranceInfoArray.count > _chosedTag) {
        NSString *vChosedStr = [_insuranceInfoArray objectAtIndex:_chosedTag];
        self.insuranceDescTextView.text = vChosedStr;
        CGSize vStrSize = [StringHelper caluateStrLength:vChosedStr Front:self.insuranceDescTextView.font ConstrainedSize:CGSizeMake(self.insuranceDescTextView.frame.size.width - 12, CGFLOAT_MAX)];
        self.insuranceDescTextView.frame = CGRectMake(self.insuranceDescTextView.frame.origin.x, self.insuranceDescTextView.frame.origin.y, 320, vStrSize.height + 12 );
        //不是Ios7出现的偏差
        if (!IS_IOS7) {
            self.insuranceDescTextView.frame = CGRectMake(self.insuranceDescTextView.frame.origin.x, self.insuranceDescTextView.frame.origin.y, 320, vStrSize.height + 12 + 21 *3);
        }
    }else{
        self.insuranceDescTextView.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iNeedInsuranceButtonTouchDown:(UIButton *)sender{
    id vUserId = [UserManager instanceUserManager].userID;
    //获取保险介绍内容
    NSString *vInsuranceStr = [_insuranceInfoArray objectAtIndex:_chosedTag];
    //获取套餐名字
    NSString *vPakegeType = [StringHelper getUNZipedFileName:vInsuranceStr MiddleStr:@"\n"];
   //组合请求参数
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserId,@"userId",
                                [NSNumber numberWithInt:1000000],@"companyId",
                                @"平安保险",@"insuranceCompany",
                                vPakegeType,@"packageType",
                                nil];
     NSData *vReturnData = [NetManager postToURLSynchronous:APPURL501 Paremeter:vParemeter timeout:30 RequestName:@"我要投保"];
     NSDictionary *vReturnDic = [NetManager jsonToDic:vReturnData];
    NSNumber *vStateCode = [vReturnDic objectForKey:@"stateCode"];
    if ([vStateCode intValue] == 0) {
            [self.view addSubview:self.IneedInsuranceNoticeView];
            [UIView animateChangeView:self.IneedInsuranceNoticeView AnimationType:vaFade SubType:vsFromBottom Duration:.2 CompletionBlock:Nil];

    }
}

- (IBAction)needInsuranceButtonCLicked:(id)sender {
    [UIView animateChangeView:self.IneedInsuranceNoticeView AnimationType:vaFade SubType:vsFromBottom Duration:.2 CompletionBlock:^{
        [self.IneedInsuranceNoticeView removeFromSuperview];
        [self back];
    }];
}
@end
