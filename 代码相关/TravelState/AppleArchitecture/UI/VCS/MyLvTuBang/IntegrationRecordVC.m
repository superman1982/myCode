//
//  IntegrationRecordVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "IntegrationRecordVC.h"
#import "JiFenCell.h"
#import "UserManager.h"
#import "NetManager.h"

@interface IntegrationRecordVC ()
{
    NSInteger  mPageIndex;
    NSInteger  mPageSize;
    NSInteger  mType;
    BOOL       isInitWebData;
}
@property (nonatomic,retain) NSMutableArray *intergrationArray;

@end

@implementation IntegrationRecordVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"IntegrationRecordVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"IntegrationRecordVC" bundle:aBuddle];
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
    self.title = @"我的途币";
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
    [_intergrationArray removeAllObjects];
    [_intergrationArray release];
    [_chongZhiJiLuButton release];
    [_transferRecordButton release];
    [_zengSongRecordButton release];
    [_costRecordButton release];
    [_intergrationRecordTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    [self chongZhiRecordButtonClicked:Nil];
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
    [self setChongZhiJiLuButton:nil];
    [self setTransferRecordButton:nil];
    [self setZengSongRecordButton:nil];
    [self setCostRecordButton:nil];
    [self setIntergrationRecordTableView:nil];
    [super viewDidUnload];
}

-(void)setIntergrationArray:(NSMutableArray *)intergrationArray{
    if (_intergrationArray == Nil) {
        _intergrationArray = [[NSMutableArray alloc] init];
    }
    if (isInitWebData) {
        [_intergrationArray removeAllObjects];
    }
    [_intergrationArray addObjectsFromArray:intergrationArray];
    [self.intergrationRecordTableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger vRowCount = self.intergrationArray.count;
    if (vRowCount > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return vRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"memCell";
    JiFenCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"JiFenCell" owner:self options:nil] objectAtIndex:0];
        UIImageView *vBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 114) ];
        [vBackImageView setImage:[UIImage imageNamed:@"scoreLog_item_bkg1_bkg"]];
        vCell.backgroundView = vBackImageView;
        SAFE_ARC_AUTORELEASE(vBackImageView);
        
        UIImageView *vSelecteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 114) ];
        [vSelecteImageView setImage:[UIImage imageNamed:@"scoreLog_item_bkg2_bkg"]];
        vCell.selectedBackgroundView = vSelecteImageView;
        SAFE_ARC_AUTORELEASE(vSelecteImageView);
    }
    
    [vCell setCell:[self.intergrationArray objectAtIndex:indexPath.row]];
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 其他辅助功能
-(void)clearButtons{
    [self.chongZhiJiLuButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.chongZhiJiLuButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.transferRecordButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.transferRecordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.zengSongRecordButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.zengSongRecordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.costRecordButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.costRecordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}
#pragma mark 下载数据初始化
-(void)initWebData{
    isInitWebData = YES;
    id vUserID = [UserManager instanceUserManager].userID;
    mPageIndex = 0;
    mPageSize = 14;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                [NSNumber numberWithInt:mType],@"type",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    [self postToWeb:vParemeter];
    
}
#pragma mark 下载数据设置
-(void)loadWebData{
    isInitWebData = NO;
    mPageIndex++;
    id vUserID = [UserManager instanceUserManager].userID;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                vUserID,@"userId",
                                [NSNumber numberWithInt:mType],@"type",
                                [NSNumber numberWithInt:mPageIndex],@"pageIndex",
                                [NSNumber numberWithInt:mPageSize],@"pageSize",
                                nil];
    [self postToWeb:vParemeter];
}

#pragma mark 请求数据
-(void)postToWeb:(NSDictionary *)aParemeter{
    [NetManager postDataFromWebAsynchronous:APPURL808 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vNoticeArray = Nil;
        if (vDataDic.count > 0) {
            vNoticeArray = [NSMutableArray array];
            for (NSDictionary *vDic in vDataDic) {
                [vNoticeArray addObject:vDic];
            }
        }
        self.intergrationArray = vNoticeArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"途币记录" Notice:@""];
}

#pragma mark - 其他业务点击事件

- (IBAction)chongZhiRecordButtonClicked:(id)sender {
    [self clearButtons];
    [self.chongZhiJiLuButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
    [self.chongZhiJiLuButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    mType = 1;
    [self initWebData];
}

- (IBAction)transferButtonClicked:(id)sender {
    [self clearButtons];
    [self.transferRecordButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
    [self.transferRecordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    mType = 2;
    [self initWebData];
}
- (IBAction)givingButtonClicked:(id)sender {
    [self clearButtons];
    [self.zengSongRecordButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
    [self.zengSongRecordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    mType = 3;
    [self initWebData];
}

- (IBAction)costButtonClicked:(id)sender {
    [self clearButtons];
    [self.costRecordButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
    [self.costRecordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    mType = 4;
    [self initWebData];
}

@end
