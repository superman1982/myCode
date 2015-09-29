//
//  CustomTabBarController.h
//  CTBDriversClient
//
//  Created by apple_lwq on 13-12-3.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"

@class UITabBarController;
@protocol CustomTabBarControllerDelegate;
@interface CustomTabBarController : UIViewController<CustomTabBarDelegate,UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer * panGesture;
	CustomTabBar *_tabBar;
	UIView      *_containerView;
	UIView		*_transitionView;
	id<CustomTabBarControllerDelegate> _delegate;
	NSMutableArray *_viewControllers;
    NSMutableArray *_imagesArr;
	NSUInteger _selectedIndex;
	
	BOOL _tabBarTransparent;
	BOOL _tabBarHidden;
    BOOL _panFlag;
}

@property(nonatomic, copy) NSMutableArray *viewControllers;
@property(nonatomic, copy) NSMutableArray *imagesArr;
@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

// Apple is readonly
@property (nonatomic, readonly) CustomTabBar *tabBar;
@property(nonatomic,assign) id<CustomTabBarControllerDelegate> delegate;


// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic, readonly) BOOL tabBarHidden;
@property (nonatomic, readonly) BOOL panFlag;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;
//隐藏tabbar
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;

//切换显示界面
- (void)changeViewControllerAtIndex:(int)index;

// Remove the viewcontroller at index of viewControllers.
- (void)removeViewControllerAtIndex:(NSUInteger)index;

// Insert an viewcontroller at index of viewControllers.
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

@end


@protocol CustomTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(CustomTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(CustomTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface UIViewController (CustomTabBarControllerSupport)
@property(nonatomic, retain, readonly) CustomTabBarController *customTabBarController;
@end

