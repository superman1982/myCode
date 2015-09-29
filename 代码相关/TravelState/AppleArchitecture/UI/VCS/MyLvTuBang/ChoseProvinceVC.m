//
//  ChosePlaceVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-27.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChoseProvinceVC.h"
#import "NetManager.h"
#import "HttpDefine.h"
#import "ChoseProvinceCityVC.h"

@interface ChoseProvinceVC ()

@end

@implementation ChoseProvinceVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ChoseProvinceVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChoseProvinceVC" bundle:aBuddle];
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
    self.title = @"地区";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

-(void)initCommonData{
    _placeArray = [[NSMutableArray alloc] init];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_placeArray removeAllObjects],[_placeArray release];
    [_placeTableView release];
    [super dealloc];
}
#endif

// 初始经Frame
- (void) initView: (BOOL) aPortait {
    self.placeTableView.frame = self.view.frame;
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

-(void )setPlaceArray:(NSMutableArray *)placeArray{
    if (_placeArray == Nil) {
        _placeArray = [[NSMutableArray alloc] init];
    }
    [_placeArray removeAllObjects];
    [_placeArray addObjectsFromArray:placeArray];
    [self.placeTableView reloadData];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _placeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:14];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    vCell.textLabel.text = [[_placeArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didChoseProvinceFinished:)]) {
        [_delegate didChoseProvinceFinished:[_placeArray objectAtIndex:indexPath.row]];
    }else{
        [self goToChosePlaceVC:[_placeArray objectAtIndex:indexPath.row]];
    }
}

#pragma mark - 其他辅助功能
-(void)goToChosePlaceVC:(NSDictionary *)aData{
    NSNumber *vProinvceID = [aData objectForKey:@"id"];
    IFISNILFORNUMBER(vProinvceID);
    [ViewControllerManager createViewController:@"ChoseProvinceCityVC"];
    //请求网络数据
    NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"type",vProinvceID,@"id",nil];
    
    [NetManager postDataFromWebAsynchronous:APPURL103 Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
        //解析返回数据到数组
        NSDictionary *vDataDic = [[NetManager jsonToDic:responseObject] objectForKey:@"data"];
        NSMutableArray *vDataArray = [NSMutableArray array];
        for (NSDictionary *vDic in vDataDic) {
            [vDataArray addObject:vDic];
        }
        ChoseProvinceCityVC *vChosePlaceVC = (ChoseProvinceCityVC *)[ViewControllerManager getBaseViewController:@"ChoseProvinceCityVC"];
        vChosePlaceVC.provinceDic = aData;
        vChosePlaceVC.placeArray = vDataArray;
        vChosePlaceVC.delegate = self.delegate;
        vChosePlaceVC.isNeedChosedDistrict = self.isNeedChosedDistrict;
        vChosePlaceVC.fromVCName = self.fromVCName;
        //显示地区
        [ViewControllerManager showBaseViewController:@"ChoseProvinceCityVC" AnimationType:vaDefaultAnimation SubType:0];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"获取市" Notice:@""];
}
- (void)viewDidUnload {
[self setPlaceTableView:nil];
[super viewDidUnload];
}
@end
