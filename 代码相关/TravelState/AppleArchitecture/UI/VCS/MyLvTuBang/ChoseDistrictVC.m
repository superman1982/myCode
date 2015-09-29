//
//  ChoseCityAeraVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-27.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChoseDistrictVC.h"

@interface ChoseDistrictVC ()

@end

@implementation ChoseDistrictVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ChoseDistrictVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ChoseDistrictVC" bundle:aBuddle];
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
    [_cityDic release];
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

-(void)setCityDic:(NSDictionary *)cityDic{
    _cityDic = [[NSDictionary alloc] initWithDictionary:cityDic];
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
    }
    
    vCell.textLabel.text = [[_placeArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didFinishChosedPlace:)]) {
        NSDictionary *vDic = [NSDictionary dictionaryWithObjectsAndKeys:self.provinceDic,@"province",self.cityDic,@"city",[_placeArray objectAtIndex:indexPath.row],@"district", nil];
        [_delegate didFinishChosedPlace:vDic];
    }
}

- (void)viewDidUnload {
    [self setPlaceTableView:nil];
    [super viewDidUnload];
}


@end
