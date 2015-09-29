//
//  BuneesCommentVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BuneesCommentVC.h"
#import "BunessCommentCell.h"
#import "NetManager.h"

@interface BuneesCommentVC ()
{
    NSInteger  mPageSize;
    NSInteger  mPageIndex;
    NSInteger  mType;
    BOOL       isInitWebData;
}
@property (nonatomic,retain) NSMutableArray *commentArray;
@end

@implementation BuneesCommentVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"BuneesCommentVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"BuneesCommentVC" bundle:aBuddle];
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
    self.title = @"商家评价";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

//初始化数据
-(void)initCommonData{
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_commentArray removeAllObjects],_commentArray = Nil;
    [_allNumerLable release];
    [_bestLable release];
    [_middleLable release];
    [_badLable release];
    [_bestLable release];
    [_middleTitleLable release];
    [_badTitleLable release];
    [_commtentTableView release];
    [_allButton release];
    [_bestButton release];
    [_middleButton release];
    [_badButton release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView: (BOOL) aPortait {
    [self initWebData];

}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
    }else{
    }
}

//------------------------------------------------

-(void)setCommentArray:(NSMutableArray *)commentArray{
    if (_commentArray == Nil) {
        _commentArray = [[NSMutableArray alloc] init];
    }
    if (isInitWebData) {
        [_commentArray removeAllObjects];
    }
    [_commentArray addObjectsFromArray:commentArray];
    [self.commtentTableView reloadData];
}

#pragma mark UITableViewDataSource -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BunessCommentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BunessCommentCell" owner:self options:nil] objectAtIndex:0];
    NSString *vContentStr = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    [cell setHightOfCell:vContentStr];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"commentCell";
    BunessCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BunessCommentCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setCell:[self.commentArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 其他辅助功能
-(void)initWebData{
    isInitWebData = YES;
    mPageSize = 14;
    mPageIndex = 0;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:self.shangJiaInfo.bunessId ,@"businessId",   [NSNumber numberWithInt:mPageIndex],@"pageIndex",
        [NSNumber numberWithInt:mPageSize],@"pageSize",
        [NSNumber numberWithInt:mType],@"type",
                                nil];
    [self postWebData:vParemeter];
}

-(void)downLoadWebData{
    isInitWebData = NO;
    mPageIndex++;
    NSDictionary *vParemeter = [NSDictionary dictionaryWithObjectsAndKeys:self.shangJiaInfo.bunessId ,@"businessId",   [NSNumber numberWithInt:mPageIndex],@"pageIndex",
        [NSNumber numberWithInt:mPageSize],@"pageSize",
        [NSNumber numberWithInt:mType],@"type",
                                nil];
    [self postWebData:vParemeter];
}

-(void)postWebData:(NSDictionary *)aParemeter{
    [NetManager postDataFromWebAsynchronous:APPURL904 Paremeter:aParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        NSMutableArray *vCommentsArray = [NSMutableArray array];
        if (vDataDic.count > 0) {
            NSDictionary *vCommentDic = [vDataDic objectForKey:@"comment"];
            for (NSDictionary *vDic in vCommentDic) {
                [vCommentsArray addObject:vDic];
            }
            //设置好评等得数量
            [self setMenuButton:vDataDic];
        }
        self.commentArray = vCommentsArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"请求商家评论" Notice:@""];
}

-(void)setMenuButton:(NSDictionary *)aDic{
    NSString *vBestStr = [aDic objectForKey:@"best"];
    IFISNIL(vBestStr);
    self.bestLable.text = [NSString stringWithFormat:@"(%@)",vBestStr];
    
    NSString *vMiddleStr = [aDic objectForKey:@"normal"];
    IFISNIL(vMiddleStr);
    self.middleLable.text = [NSString stringWithFormat:@"(%@)",vMiddleStr];
    
    NSString *vBadStr = [aDic objectForKey:@"bad"];
    IFISNIL(vBadStr);
    self.badLable.text = [NSString stringWithFormat:@"(%@)",vBadStr];
    
    NSInteger vAllNumber = [vBestStr intValue] + [vMiddleStr intValue] + [vBadStr intValue];
    NSString *vAllNumberStr = [NSString stringWithFormat:@"(%d)",vAllNumber];
    self.allNumerLable.text = vAllNumberStr;
}

-(void)clearOtherButtonCorlor{
//    roadBook_tab_bkg.png
    self.allNumerLable.textColor = [UIColor darkGrayColor];
    self.allTitleLable.textColor = [UIColor darkGrayColor];
    self.bestTitleLable.textColor = [UIColor darkGrayColor];
    self.bestLable.textColor = [UIColor darkGrayColor];
    self.middleLable.textColor = [UIColor darkGrayColor];
    self.middleTitleLable.textColor = [UIColor darkGrayColor];
    self.badLable.textColor = [UIColor darkGrayColor];
    self.badTitleLable.textColor = [UIColor darkGrayColor];
    
    [self.allButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.bestButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.middleButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.badButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
}
#pragma mark - 其他业务点击事件
- (IBAction)allButtonClicked:(id)sender {
    mType = 0;
    [self initWebData];
    [self clearOtherButtonCorlor];
    self.allNumerLable.textColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1];
    self.allTitleLable.textColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1];
    [self.allButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
}

- (IBAction)bestButtonClicked:(id)sender {
    mType = 1;
    [self initWebData];
    [self clearOtherButtonCorlor];
    self.bestTitleLable.textColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1];
    self.bestLable.textColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1];
    [self.bestButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
}
- (IBAction)middleButtonClicked:(id)sender {
    mType = 2;
    [self initWebData];
    [self clearOtherButtonCorlor];
    self.middleLable.textColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1];
    self.middleTitleLable.textColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1];
    [self.middleButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
}
- (IBAction)badButtonClicked:(id)sender {
    mType = 3;
    [self initWebData];
    [self clearOtherButtonCorlor];
    self.badLable.textColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1];
    self.badTitleLable.textColor = [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:230/255.0 alpha:1];
    [self.badButton setBackgroundImage:[UIImage imageNamed:@"roadBook_tab_bkg.png"] forState:UIControlStateNormal];
}

- (void)viewDidUnload {
   [self setAllNumerLable:nil];
    [self setBestLable:nil];
    [self setMiddleTitleLable:nil];
    [self setBadTitleLable:nil];
    [self setBestLable:nil];
    [self setMiddleLable:nil];
    [self setBadLable:nil];
    [self setCommtentTableView:nil];
    [self setAllButton:nil];
    [self setBestButton:nil];
    [self setMiddleButton:nil];
    [self setBadButton:nil];
   [super viewDidUnload];
}
@end
