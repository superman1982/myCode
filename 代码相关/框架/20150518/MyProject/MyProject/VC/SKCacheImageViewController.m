//
//  SKCacheImageViewController.m
//  MyProject
//
//  Created by lin on 15/5/18.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKCacheImageViewController.h"
#import "SKCacheViewControllerParameter.h"
#import "SKCacheImageTableViewCell.h"
#import "SKCollListRequest.h"
#import "SKCollListRequestParam.h"
#import "SKCollListResult.h"
#import "SKLvTuStateRequestParam.h"
#import "SKLvTuStateRequest.h"
#import "SKLvTuStateResult.h"
#import "SKExtendLoadMoreTableView.h"

#define NEWABOSULUTEPATH @"http://www.hnqlhr.com"

#define APPURL401 [NSString stringWithFormat:@"%@%@",NEWABOSULUTEPATH,@"/services/activity/listActivity"]

@interface SKCacheImageViewController()<SKCustomTableViewDataSource,SKCustomTableViewDelegate,SkBaseWebRequestDelegate>
{
    SKCollListRequest *_collistRequest;
    SKLvTuStateRequest *_lvTuRequest;
    NSInteger           _currentIndex;
    NSInteger           _total;
    BOOL               _isRefresh;
}
@property (nonatomic,retain) NSMutableArray *pageData;
@end
@implementation SKCacheImageViewController

-(void)dealloc{
    [_pageData removeAllObjects];
    SK_RELEASE_SAFELY(_pageData);
    [_collistRequest release];
    [_cacheTableView release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    
}

-(void)initWithNavi{
    self.titleStr = @"图片本地缓存";
    UIBarButtonItem *vLeftButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backButtonClicked:)];
    self.navigationItem.leftBarButtonItem = vLeftButtonItem;
    [vLeftButtonItem release];
    [super initWithNavi];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    if (_pageData == nil) {
        _pageData = [[NSMutableArray alloc] init];
    }
    if (_cacheTableView == nil) {
        _cacheTableView = [[SKExtendLoadMoreTableView alloc] init];
        _cacheTableView.dataSource = self;
        _cacheTableView.delegate = self;
        _cacheTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
    [self.view addSubview:_cacheTableView];
    
    [_cacheTableView forceToFreshData];
//    [self refreshM1];
//    [self loadLvTuBang];
    
}

-(void)loadM1{
    if (_collistRequest == nil) {
        _collistRequest = [[SKCollListRequest alloc] init];
    }
    SKCollListOb *vSKCollListOb = [[SKCollListOb alloc] init];
    vSKCollListOb.affairState = 3;
    vSKCollListOb.lastID = 0;
    vSKCollListOb.startIndex = _currentIndex;
    vSKCollListOb.size = 20;
    SKCollListRequestParam *vParameter = [[SKCollListRequestParam alloc] initWithSKCollListOb:vSKCollListOb];
    _collistRequest.param = vParameter;
    _collistRequest.delegate = self;
    [_collistRequest requestData];
    
    [vParameter release];
    [vSKCollListOb release];
}

-(void)refreshM1{
    _currentIndex = 0;
    [self loadM1];
}


-(void)loadLvTuBang{
    SKLvTuStateOb *vOb = [[SKLvTuStateOb alloc] init];
    vOb.cityId = [NSNumber numberWithInt:0];
    vOb.districtId = [NSNumber numberWithInt:0];
    vOb.userId = @"";
    vOb.pageIndex = [NSNumber numberWithInt:0];
    vOb.pageSize = [NSNumber numberWithInt:14];
    vOb.provinceId = [NSNumber numberWithInt:18];
    vOb.type = [NSNumber numberWithInt:1];
    SKLvTuStateRequestParam *vParameter = [[SKLvTuStateRequestParam alloc] initWithLoginOb:vOb];
    vParameter.requestURLStr = APPURL401;
    
    [vOb release];
    if (_lvTuRequest == nil) {
        _lvTuRequest = [[SKLvTuStateRequest alloc] init];
        _lvTuRequest.delegate = self;
    }
    _lvTuRequest.param = vParameter;
    [_lvTuRequest requestData];
}


-(void)backButtonClicked:(id)sender{
    SKCacheViewControllerParameter *vParemeter = (SKCacheViewControllerParameter *)self.parameter;
    if ([vParemeter.delegate respondsToSelector:@selector(backButtonClicked:)]) {
        [vParemeter.delegate backButtonClicked:vParemeter];
    }
}

#pragma mark - SKCustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(SKCustomTableView *)aView{
    return _pageData.count;
}

-(SKSlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView{
    static NSString *vCellIdentify = @"myCell";

    SKCacheImageTableViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[SKCacheImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
    }
    [vCell setCell:[_pageData objectAtIndex:aIndexPath.row]];
    return vCell;
}

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView{
    return 100;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView{
    
}

#pragma mark - SKCustomTableViewDelegate
-(void)didDeleteCellAtIndexpath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView{
    NSInteger row = aIndexPath.row;
    [_pageData removeObjectAtIndex:row];
}

-(BOOL)noDataToLoadFromView:(SKCustomTableView *)aView{
    
    return _total <= self.pageData.count ? YES : NO;
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(SKCustomTableView *)aView{
    _isRefresh = NO;
    [self loadM1];
}

-(void)refreshData:(void(^)())complete FromView:(SKCustomTableView *)aView{
    _isRefresh = YES;
    [self refreshM1];
}

#pragma mark - SkBaseWebRequestDelegate
-(void)didStartLoadData:(id)sender{
}

-(void)didLoadDataSucess:(SKBaseResponse *)aReponse WithRequest:(SKBaseWebRequest *)aRequest{
    if (aRequest == _collistRequest) {
        SKCollListResult *vResult = aReponse.result;
        NSLog(@"aReponse.result:%@",(SKCollListResult *)aReponse.result);
        if (_isRefresh) {
            [_pageData removeAllObjects];
        }
        [_pageData addObjectsFromArray:vResult.dataList];
        _currentIndex = self.pageData.count;
        _total = vResult.total;
        [_cacheTableView reloadTableView];
    }else if (aRequest == _lvTuRequest){
        SKLvTuStateResult *vResult = aReponse.result;
        if (_isRefresh) {
            [_pageData removeAllObjects];
        }
        [_pageData addObjectsFromArray:vResult.data.normal];
        [_cacheTableView reloadTableView];
    }

}

-(void)didLoadDataFailure:(id)sender Error:(NSError *)aError{
}

@end
