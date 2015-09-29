//
//  AllMyCarVC.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-15.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AllMyCarVC.h"
#import "MyCarVC.h"

@interface AllMyCarVC ()
{
    NSMutableArray *mMyCarArray;
}
@end

@implementation AllMyCarVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"AllMyCarVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"AllMyCarVC" bundle:aBuddle];
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
    self.title = @"选择车辆";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView: mIsPortait];
}

//初始化数据
-(void)initCommonData{
    mMyCarArray = [[NSMutableArray alloc] init];
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [super dealloc];
}
#endif

// 初始View
- (void) initView: (BOOL) aPortait {
    MyCarVC *vMyCarVC = [[MyCarVC alloc] init];
    [vMyCarVC initWebDataComplete:^(NSArray *responseObject) {
        if (responseObject.count > 0) {
            [mMyCarArray addObjectsFromArray:responseObject];
            [self.allMyCarTableView reloadData];
        }
    }];
}

//设置View方向
-(void) setViewFrame:(BOOL)aPortait{
    if (aPortait) {
    }else{
    }
}

//------------------------------------------------

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger mRowCount = mMyCarArray.count;
    tableView.frame = CGRectMake(0, 0, 320, 44 *mRowCount + 44 + 10);
    if (tableView.frame.size.height > self.view.frame.size.height - 54) {
        tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 54);
    }
    return mRowCount;
}

#pragma mark table背景颜色
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1]];
    SAFE_ARC_AUTORELEASE(headerView);
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:15];
        vCell.textLabel.textColor = [UIColor darkGrayColor];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        vCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //设置图片
        UIImageView *vCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 14, 15, 15)];
        vCellImageView.tag = 100;
        vCellImageView.hidden = YES;
        vCellImageView.image = [UIImage imageNamed:@"carDetail_star_btn"];
        [vCellImageView setBackgroundColor:[UIColor clearColor]];
        [vCell.contentView addSubview:vCellImageView];
        SAFE_ARC_RELEASE(vCellImageView);
        
    }
    if (indexPath.section == 0) {
        NSDictionary *vDic = [mMyCarArray objectAtIndex:indexPath.row];
        NSString *vCarLisence = [vDic objectForKey:@"carNumber"];
        IFISNIL(vCarLisence);
        vCell.textLabel.text = vCarLisence;
        UIImageView *vImageView = (UIImageView *)[vCell.contentView viewWithTag:100];
        if ([[vDic objectForKey:@"isDefault"] intValue] == 1) {
            vImageView.hidden = NO;
        }else{
            vImageView.hidden = YES;
        }
        
    }
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didAllMyCarVCSeleted:)]) {
        [_delegate didAllMyCarVCSeleted:[mMyCarArray objectAtIndex:indexPath.row]];
        [self back];
    }
}

@end
