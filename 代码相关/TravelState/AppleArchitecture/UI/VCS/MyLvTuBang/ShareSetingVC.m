//
//  ShareSetingVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ShareSetingVC.h"
#import <ShareSDK/ShareSDK.h>

@interface ShareSetingVC ()

@property (nonatomic,retain) UISwitch *sinaSwitch;
@property (nonatomic,retain) UISwitch *tengXunSwitch;
@end

@implementation ShareSetingVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    if (IS_IPHONE_5) {
                self = [super initWithNibName:@"ShareSetingVC_2x" bundle:aBuddle];
    }else{
        self = [super initWithNibName:@"ShareSetingVC" bundle:aBuddle];
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
    self.title = @"分享设置";
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
    [self.sinaSwitch release];
    [self.tengXunSwitch release];
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
    self.sinaSwitch = nil;
    self.tengXunSwitch = nil;
    [super viewShouldUnLoad];
}
//----------
- (void)viewDidUnload {
    [super viewDidUnload];
}

-(UISwitch *)sinaSwitch{
    if (_sinaSwitch == nil) {
        _sinaSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(240, 7, 51, 31)];
        [_sinaSwitch addTarget:self action:@selector(sinaSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _sinaSwitch;
}

-(UISwitch *)tengXunSwitch{
    if (_tengXunSwitch == nil) {
        _tengXunSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(240, 7, 51, 31)];
        [_tengXunSwitch addTarget:self action:@selector(tengXunSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _tengXunSwitch;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"myCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (vCell == Nil) {
        vCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        vCell.textLabel.font = [UIFont systemFontOfSize:14];
        vCell.textLabel.textAlignment = NSTextAlignmentLeft;
        vCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0){
        vCell.textLabel.text = @"新浪授权新浪微博分享";
        [vCell.contentView addSubview:self.sinaSwitch];
        [vCell.imageView setImage:[UIImage imageNamed:@"shareSetting_weibo_btn"]];
    }else if (indexPath.row == 1){
        vCell.textLabel.text = @"腾讯授权腾讯微博分享";
        [vCell.contentView addSubview:self.tengXunSwitch];
        [vCell.imageView setImage:[UIImage imageNamed:@"shareSetting_tencentWeibo_btn"]];
    }
    
    return vCell;
}

#pragma mark - 其他业务点击事件
#pragma mark  新浪分享设置
-(void)sinaSwitchValueChange:(UISwitch *)sender{
    if (sender.on) {
        [ShareSDK authWithType:ShareTypeSinaWeibo options:Nil result:^(SSAuthState state, id<ICMErrorInfo> error) {}];
    }else{
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    }
}

#pragma mark  腾讯分享设置
-(void)tengXunSwitchValueChange:(UISwitch *)sender{
    if (sender.on) {
        [ShareSDK authWithType:ShareTypeTencentWeibo options:Nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
            
        }];
    }else{
        [ShareSDK cancelAuthWithType:ShareTypeTencentWeibo];
    }
}
@end
