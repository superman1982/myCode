//
//  RegulationSearchResultsVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RegulationSearchResultsVC.h"
#import "RegulationCell.h"

@interface RegulationSearchResultsVC ()

@end

@implementation RegulationSearchResultsVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"RegulationSearchResultsVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"RegulationSearchResultsVC" bundle:aBuddle];
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
    self.title = @"违章结果";
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
-(void)setResultArray:(NSMutableArray *)resultArray{
    if (_resultArray == Nil) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    [_resultArray removeAllObjects];
    [_resultArray addObjectsFromArray:resultArray];
    [self.regulationSearchResultsVCTableView reloadData];
}

-(void)setResultDic:(NSDictionary *)resultDic{
    if (_resultDic == Nil) {
        _resultDic = [[NSDictionary alloc] initWithDictionary:resultDic];
        NSDictionary *vListsDic = [_resultDic objectForKey:@"lists"];
        NSMutableArray *vArrayOfLists = [NSMutableArray array];
        for (NSDictionary *vDic in vListsDic) {
            [vArrayOfLists addObject:vDic];
        }
        self.resultArray = vArrayOfLists;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    RegulationCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"RegulationCell" owner:self options:Nil] objectAtIndex:0];

    [vCell setCell:Nil];
    
    return vCell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"reguCell";
    RegulationCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"RegulationCell" owner:self options:Nil] objectAtIndex:0];
    }
    
    NSDictionary *vDic = [self.resultArray objectAtIndex:indexPath.row];
    
    NSString *vDateStr = [vDic objectForKey:@"date"];
    IFISNIL(vDateStr);
    vDateStr = [NSString stringWithFormat:@"时间：%@",vDateStr];
    vCell.timeLable.text = vDateStr;
    
    NSString *vAdreeStr = [vDic objectForKey:@"area"];
    IFISNIL(vAdreeStr);
    vAdreeStr = [NSString stringWithFormat:@"地点：%@",vAdreeStr];
    vCell.addressLable.text = vAdreeStr;
    
    NSString *vActStr = [vDic objectForKey:@"act"];
    IFISNIL(vActStr);
    vActStr = [NSString stringWithFormat:@"行为：%@",vActStr];
    vCell.xingWeiLable.text = vActStr;
    
    vCell.kouFenLable.text = [vDic objectForKey:@"fen"];
    IFISNIL(vCell.kouFenLable.text);
    vCell.faKuanLable.text = [vDic objectForKey:@"money"];
    IFISNIL(vCell.faKuanLable.text);
    id handled = [vDic objectForKey:@"handled"];
    if ([handled intValue] == 1) {
        vCell.ifIsDealLable.text = @"已处理";
    }else{
        vCell.ifIsDealLable.text = @"未处理";
    }

    return vCell;
}

@end
