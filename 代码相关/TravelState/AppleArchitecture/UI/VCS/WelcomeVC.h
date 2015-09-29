//
//  WelcomeVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-15.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelcomeVCDeleate <NSObject>

-(void)didWelcomeVCDismissed:(id)sender;

@end
@interface WelcomeVC : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *pageControlContentView;

@property (nonatomic,assign)  id<WelcomeVCDeleate>  delegate;
@end
