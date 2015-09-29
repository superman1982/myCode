//
//  SKCacheImageViewController.h
//  MyProject
//
//  Created by lin on 15/5/18.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKExtendLoadMoreTableView;

@protocol SKCacheImageViewControllerDelegate <NSObject>

-(void)backButtonClicked:(id)sender;

@end

@interface SKCacheImageViewController : SKBaseViewController
{
    SKExtendLoadMoreTableView  *_cacheTableView;
}
@property (nonatomic,assign) id delegate;

@end
