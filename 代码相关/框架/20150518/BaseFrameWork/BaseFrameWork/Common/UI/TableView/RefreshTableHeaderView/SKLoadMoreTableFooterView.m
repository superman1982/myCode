//
//  SKLoadMoreTableFooterView.m
//  测试滑动删除Cell
//
//  Created by lin on 15/7/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKLoadMoreTableFooterView.h"
#import "CircleView.h"


@interface SKLoadMoreTableFooterView()
{
    UILabel *_stateLable;
    BOOL   _isLoading;
    UIScrollView  *_scrolView;
}
@end

@implementation SKLoadMoreTableFooterView

-(void)dealloc{
    [_scrolView release],_scrolView = nil;
    [_stateLable release],_stateLable = nil;
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (_stateLable == nil) {
            _stateLable = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 200)/2, 40, 200, 21)];
            _stateLable.backgroundColor = [UIColor clearColor];
            _stateLable.textAlignment = NSTextAlignmentCenter;
            [self setState:LoadStateBegainDrag];
        }
        [self addSubview:_stateLable];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _stateLable.frame = CGRectMake((frame.size.width - 200)/2, 40, 200, 21);
}

-(void)setState:(LoadState)aState{
    switch (aState) {
        case LoadStateBegainDrag:
            _stateLable.text = @"上拉下载";
            break;
        case LoadStateLoading:
        {
            _stateLable.text = @"加载中. . .";
        }
            break;
        case LoadStateLoadFinish:
            _stateLable.text = @"加载完成";
            break;
        case LoadStateNoneData:
            _stateLable.text = @"没有了";
            break;
        default:
            break;
    }
}

- (void)loadMoreScrollViewWillBeginScroll:(UIScrollView *)scrollView{
    _scrolView = scrollView;
    if ([_delegate respondsToSelector:@selector(isLoadingData:)]) {
        _isLoading = [_delegate isLoadingData:self];
    }
    if (!_isLoading) {
        [self setState:LoadStateBegainDrag];
    }
}

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.dragging) {
        //没数据了，直接返回
        if ([_delegate respondsToSelector:@selector(noDataToLoad:)]) {
            BOOL noData = [_delegate noDataToLoad:self];
            if (noData) {
                [self setState:LoadStateNoneData];
                return;
            }
        }
        //各种加载状态
        CGFloat moveDistance = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        if (moveDistance > 80){
            NSLog(@"moveDistance:%f",moveDistance);

            if ([_delegate respondsToSelector:@selector(isLoadingData:)]) {
                _isLoading = [_delegate isLoadingData:self];
            }
            if (!_isLoading) {
                if ([_delegate respondsToSelector:@selector(begainToLoadData:)]) {
                    [_delegate begainToLoadData:self];
                }
            }
            if(_isLoading){
                [self setState:LoadStateLoading];
            }
        }
    }
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView{
    CGFloat moveDistance = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
    
    if (moveDistance < 80 ) {
        [UIView animateWithDuration:.3 animations:^{
            _scrolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
    }else {
        [UIView animateWithDuration:.3 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(0,0,100,0);
        }];
    }
}

-(void)recoverNormalStateReadyLoadData{
    self.alpha = 0.0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            _scrolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            self.frame =  CGRectMake(0, _tableView.contentSize.height, _tableView.frame.size.width, 100);
            self.alpha = 1.0;
        }];
        [self setState:LoadStateBegainDrag];
    });
}
@end
