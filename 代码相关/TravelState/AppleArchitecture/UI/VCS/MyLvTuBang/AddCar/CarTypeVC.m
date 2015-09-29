//
//  CarTypeVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-3-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "CarTypeVC.h"
#import "NetManager.h"

@interface CarTypeVC ()

@property (nonatomic,retain) NSMutableArray *carTypeInfoArray;
@end

@implementation CarTypeVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    /*if (IS_IPHONE_5) {
        self = [super initWithNibName:@"CarTypeVC_2x" bundle:aBuddle];
    }else*/{
        self = [super initWithNibName:@"CarTypeVC" bundle:aBuddle];
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
    self.title = @"车辆类型";
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
- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)setCarTypeInfoArray:(NSMutableArray *)carTypeInfoArray{
    if (_carTypeInfoArray == Nil) {
        _carTypeInfoArray = [[NSMutableArray alloc] init];
    }
    
    [_carTypeInfoArray removeAllObjects];
    [_carTypeInfoArray addObjectsFromArray:carTypeInfoArray];
    [self.carTypeTableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _carTypeInfoArray.count;
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
    }
    /*	{
     "car":"大型车",
     "id":"01"
     },*/
    NSDictionary *vDic = [_carTypeInfoArray objectAtIndex:indexPath.row];
    vCell.textLabel.text = [vDic objectForKey:@"car"];
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didCarTypeVCSelected:)]) {
        NSDictionary *vDic = [self.carTypeInfoArray objectAtIndex:indexPath.row];
        [_delegate didCarTypeVCSelected:vDic];
        [self back];
    }
}


#pragma mark 其他辅助功能
-(void)initWebData{
    [NetManager getURLDataFromWeb:APPURL921 Parameter:Nil Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *result = [vReturnDic objectForKey:@"result"];
        NSMutableArray *vResultArray = [NSMutableArray array];
        for (NSDictionary *vResultDic in result) {
            [vResultArray addObject:vResultDic];
        }
        self.carTypeInfoArray = vResultArray;
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"请求车辆类型" Notice:@""];
}
@end
