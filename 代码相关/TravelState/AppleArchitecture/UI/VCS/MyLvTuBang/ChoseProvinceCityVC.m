//
//  ChoseCityVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-27.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChoseProvinceCityVC.h"
#import "NetManager.h"
#import "HttpDefine.h"
#import "ChoseDistrictVC.h"
#import "RegisterVC.h"

@interface ChoseProvinceCityVC ()

@end

@implementation ChoseProvinceCityVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ChoseProvinceCityVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChoseProvinceCityVC" bundle:aBuddle];
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
    [_provinceDic release];
    [_placeArray removeAllObjects],[_placeArray release];
    [_placeTableView release];
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

-(void )setPlaceArray:(NSMutableArray *)placeArray{
    if (_placeArray == Nil) {
        _placeArray = [[NSMutableArray alloc] init];
    }
    [_placeArray removeAllObjects];
    [_placeArray addObjectsFromArray:placeArray];
    [self.placeTableView reloadData];
}

-(void)setProvinceDic:(NSDictionary *)provinceDic{
    _provinceDic = [[NSDictionary alloc] initWithDictionary:provinceDic];
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
    if (_isNeedChosedDistrict) {
        [self goToChosePlaceVC:[_placeArray objectAtIndex:indexPath.row]];
    }else{
        if ([_delegate respondsToSelector:@selector(didChoseProvinceCityVCFinished:)]) {
            //组合选择的省市信息
            NSDictionary *vCityData = [_placeArray objectAtIndex:indexPath.row];
            NSDictionary *vDic = [NSDictionary dictionaryWithObjectsAndKeys:self.provinceDic,@"province",vCityData,@"city", nil];
            //发送信息到需要的地方
            [_delegate didChoseProvinceCityVCFinished:vDic];
        }
    }
}

#pragma mark - 其他辅助功能
-(void)goToChosePlaceVC:(NSDictionary *)aData{
    NSNumber *vCityID = [aData objectForKey:@"id"];
    IFISNILFORNUMBER(vCityID);
    [ViewControllerManager createViewController:@"ChoseDistrictVC"];
    //请求网络数据
    NSDictionary *vParemeterDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"type",vCityID,@"id",nil];
    
   [NetManager postDataFromWebAsynchronous:APPURL103 Paremeter:vParemeterDic Success:^(NSURLResponse *response, id responseObject) {
       //解析返回数据到数组
       NSDictionary *vDataDic = [[NetManager jsonToDic:responseObject] objectForKey:@"data"];
       NSMutableArray *vDataArray = [NSMutableArray array];
       for (NSDictionary *vDic in vDataDic) {
           [vDataArray addObject:vDic];
       }
       ChoseDistrictVC *vChosePlaceVC = (ChoseDistrictVC *)[ViewControllerManager getBaseViewController:@"ChoseDistrictVC"];
       vChosePlaceVC.placeArray = vDataArray;
       vChosePlaceVC.provinceDic = self.provinceDic;
       vChosePlaceVC.cityDic = aData;
       vChosePlaceVC.delegate = self.delegate;
       vChosePlaceVC.fromVCName = self.fromVCName;
       //显示地区
       [ViewControllerManager showBaseViewController:@"ChoseDistrictVC" AnimationType:vaDefaultAnimation SubType:0];
    } Failure:^(NSURLResponse *response, NSError *error) {
    } RequestName:@"获取区" Notice:@""];
}

- (void)viewDidUnload {
    [self setPlaceTableView:nil];
    [super viewDidUnload];
}


@end
