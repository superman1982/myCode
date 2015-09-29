//
//  UpGrandMembershipVCViewController.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "UpGrandMemberVC.h"
#import "UpGrandVipCell.h"
#import "UserManager.h"
#import "NetManager.h"

@interface UpGrandMemberVC ()

@property (nonatomic,retain) NSMutableArray *memberInfoArray;
@end

@implementation UpGrandMemberVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"UpGrandMemberVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"UpGrandMemberVC" bundle:aBuddle];
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
    self.title = @"升级会员";
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
    [_memberInfoArray removeAllObjects];
    [_memberInfoArray release];
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
    [super viewShouldUnLoad];
}
//----------

-(void)setMemberInfoArray:(NSMutableArray *)memberInfoArray{
    if (_memberInfoArray == Nil) {
        _memberInfoArray = [[NSMutableArray alloc] init];
    }
    [_memberInfoArray addObjectsFromArray:memberInfoArray];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UpGrandVipCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"UpGrandVipCell" owner:self options:nil] objectAtIndex:0];
    return vCell.frame.size.height;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger vRowCount = 4;
    if (vRowCount > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return  vRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"upCell";
    UpGrandVipCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"UpGrandVipCell" owner:self options:nil] objectAtIndex:0];
    }
    NSInteger vRowIndex = indexPath.row;
    if (vRowIndex%2) {
        vCell.cardBackImageView.image = [UIImage imageNamed:@"menberShipUp_bkg2_bkg"];
    }else{
        vCell.cardBackImageView.image = [UIImage imageNamed:@"menberShipUp_bkg1_bkg"];
    }
    [vCell setCell:[self.memberInfoArray objectAtIndex:indexPath.row]];
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [ViewControllerManager createViewController:@"MemberCardDetailVC"];
    [ViewControllerManager showBaseViewController:@"MemberCardDetailVC" AnimationType:vaDefaultAnimation SubType:0];
}

#pragma mark - 其他辅助功能
-(void)initWebData{
    id vUserId = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:vUserId,@"userId", nil];
    [NetManager postDataFromWebAsynchronous:APPURL807 Paremeter:vParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vMemberArray  = [NSMutableArray array];
        for (NSDictionary *vDic in  vDataDic) {
            [vMemberArray addObject:vDic];
        }
        self.memberInfoArray = vMemberArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"请求升级会员" Notice:@""];
}

@end
