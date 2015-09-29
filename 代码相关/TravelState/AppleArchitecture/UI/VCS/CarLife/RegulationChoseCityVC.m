//
//  RegulationChoseCityVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-3-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RegulationChoseCityVC.h"

@interface RegulationChoseCityVC ()

@end

@implementation RegulationChoseCityVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"RegulationChoseCityVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"RegulationChoseCityVC" bundle:aBuddle];
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
    self.title = @"选择城市";
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

-(void)setCityInfoArray:(NSMutableArray *)cityInfoArray{
    if (_cityInfoArray == Nil) {
        _cityInfoArray = [[NSMutableArray alloc] init];
    }
    [_cityInfoArray removeAllObjects];
    [_cityInfoArray addObjectsFromArray:cityInfoArray];
    [self.RegulationChoseCityVCTableView reloadData];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryNone;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    NSDictionary *vDic = [self.cityInfoArray objectAtIndex:indexPath.row];
    vCell.textLabel.text = [vDic objectForKey:@"city_name"];
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didRegulationChoseCityVCSelected:)]) {
        NSDictionary *vDic = [self.cityInfoArray objectAtIndex:indexPath.row];
        [_delegate didRegulationChoseCityVCSelected:vDic];
    }
}



@end
