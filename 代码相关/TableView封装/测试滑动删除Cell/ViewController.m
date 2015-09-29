//
//  ViewController.m
//  测试滑动删除Cell
//
//  Created by lin on 14-8-7.
//  Copyright (c) 2014年 lin. All rights reserved.
////*****************************read me first ************************/
//  大家好，这是本人第二个作品，有一部分参照了别人的代码，但是大部分还是自己写的
//  大家如果在使用中有什么疑问和Bug可及时与我联系，QQ:2489278559
//  对于学习ios的初学者可以看看我提供的教程：
//  http://item.taobao.com/item.htm?spm=a230r.1.14.294.BRk2Ew&id=39818151361&ns=1#detail
//************************************ end **************************/

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#import "ViewController.h"
#import "MyTableViewCell.h"

@interface ViewController ()
{
    NSInteger rowCount;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"列表封装:滑动删除，下拉刷新，点击下载";
    if (IS_IOS7) {
        self.edgesForExtendedLayout =UIRectEdgeNone ;
    }
    if (_customTableView == nil) {
        _customTableView = [[SKExtendLoadMoreTableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 -20)];
        _customTableView.dataSource = self;
        _customTableView.delegate = self;
    }
    [_customTableView forceToFreshData];
    [self.view addSubview:_customTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView{
    return 88;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView{
}

-(void)didDeleteCellAtIndexpath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView{
    rowCount--;
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(SKCustomTableView *)aView{
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (complete) {
            if(rowCount > 30){
                complete(0);
            }else{
                rowCount += 4;
                complete(4);
            }
        }
    });
}

-(void)refreshData:(void(^)())complete FromView:(SKCustomTableView *)aView{
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        rowCount = 5;
        if (complete) {
            complete();
        }
    });
}

-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(SKCustomTableView *)aView{
    return rowCount;
}

-(SKSlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(SKCustomTableView *)aView{
    static NSString *vCellIdentify = @"sliderCell";
    
    MyTableViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
    }
    return vCell;
}

- (IBAction)touched:(UIButton *)sender {

}
@end
