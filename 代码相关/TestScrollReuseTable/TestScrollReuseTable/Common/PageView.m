//
//  PageView.m
//  TestScrollReuseTable
//
//  Created by lin on 14-5-28.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "PageView.h"

@implementation PageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commInit];
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    return self;
}

-(void)commInit{
    if (_pageTableView == nil) {
        _pageTableView = [[UITableView alloc] initWithFrame:self.frame];
        _pageTableView.delegate = self;
        _pageTableView.dataSource = self;
    }
    [self addSubview:_pageTableView];
}

-(void)pageViewWillApear{
    [_pageTableView reloadData];
    NSLog(@"PageIndex:%dWillAppear",self.pageIndex);
}

-(void)pageVIewDidDissApear{
    NSLog(@"PageIndex:%didDissAppear",self.pageIndex);
}

#pragma mark 模拟删除动画
-(void)removeSelfAnimation{
    CGAffineTransform vTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
//    [self setTransform:vTransform];
//    vTransform = CGAffineTransformMakeTranslation(320, self.frame.origin.y);
//    [self setTransform:vTransform];
    [UIView animateWithDuration:.2 animations:^{
        [self setTransform:vTransform];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            [self setTransform:CGAffineTransformMakeScale(0.05, .05)];
        } completion:^(BOOL finished) {
            [self setTransform:CGAffineTransformMakeTranslation(320,0)];
            [UIView animateWithDuration:.2 animations:^{
                [self setTransform:CGAffineTransformMakeTranslation(0, 0)];
            }];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_delegate respondsToSelector:@selector(numberOfRowsInTableView:InSection:FromView:)]) {
        NSInteger vRow =[_datasource numberOfRowsInTableView:tableView InSection:section FromView:self];
        return vRow;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(cellForRowInTableView:IndexPath:FromView:)]) {
        UITableViewCell *vCell = [_datasource cellForRowInTableView:tableView IndexPath:indexPath FromView:self];
        return vCell;
    }
    return nil;
}


@end
