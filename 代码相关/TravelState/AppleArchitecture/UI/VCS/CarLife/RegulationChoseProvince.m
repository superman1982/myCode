//
//  RegulationChoseProvince.m
//  lvtubangmember
//
//  Created by klbest1 on 14-3-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RegulationChoseProvince.h"
#import "NetManager.h"
#import "RegulationChoseCityVC.h"

@interface RegulationChoseProvince ()

@property (nonatomic,retain) NSMutableArray *provinceInfoArray;
@end

@implementation RegulationChoseProvince


//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"RegulationChoseProvince_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"RegulationChoseProvince" bundle:aBuddle];
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
    self.title = @"选择省";
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

-(void)setProvinceInfoArray:(NSMutableArray *)provinceInfoArray{
    if (_provinceInfoArray == Nil) {
        _provinceInfoArray = [[NSMutableArray alloc] init];
    }
    [_provinceInfoArray removeAllObjects];
    [_provinceInfoArray addObjectsFromArray:provinceInfoArray];
    [self.regulationChoseProvinceTableView reloadData];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.provinceInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *vDic = [self.provinceInfoArray objectAtIndex:indexPath.row];
    vCell.textLabel.text = [vDic objectForKey:@"province"];
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [ViewControllerManager createViewController:@"RegulationChoseCityVC"];
    RegulationChoseCityVC *vVC = (RegulationChoseCityVC *)[ViewControllerManager getBaseViewController:@"RegulationChoseCityVC"];
    vVC.delegate = self.delegate;
    //处理城市数据
    NSDictionary *vProvinceDic = [self.provinceInfoArray objectAtIndex:indexPath.row];
    NSDictionary *vCityDic = [vProvinceDic objectForKey:@"citys"];
    NSMutableArray *vArrayOfCity = [NSMutableArray array];
    for (NSDictionary *vDic in vCityDic) {
        [vArrayOfCity addObject:vDic];
    }
    vVC.cityInfoArray = vArrayOfCity;
    //显示数据
    [ViewControllerManager showBaseViewController:@"RegulationChoseCityVC" AnimationType:vaDefaultAnimation SubType:0];
}


#pragma mark - 其他辅助功能
#pragma mark 请求违章城市
-(void)initWebData{
    [NetManager getURLDataFromWeb:APPURL922 Parameter:Nil Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *result = [vReturnDic objectForKey:@"result"];
        NSMutableArray *vResultArray = [NSMutableArray array];
        NSArray *vProinceKeys = [result allKeys];
        for (NSString *vKey in vProinceKeys) {
            NSDictionary *vDic  = [result objectForKey:vKey];
            [vResultArray addObject:vDic];
        }
        self.provinceInfoArray = vResultArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"请求违章查询省市" Notice:@""];
}

@end
