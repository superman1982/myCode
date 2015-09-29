//
//  CustomTabBar.h
//  CTBDriversClient
//
//  Created by apple_lwq on 13-12-3.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarDelegate;

@interface CustomTabBar : UIView
{
	UIImageView *_backgroundView;
	id<CustomTabBarDelegate> _delegate;
	NSMutableArray *_buttons;
}
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, assign) id<CustomTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIImageView *animatedView;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;
- (void)changeTabAtIndex:(NSInteger)index;

@end
@protocol CustomTabBarDelegate<NSObject>
@optional
- (BOOL)tabBar:(CustomTabBar *)tabBar shouldSelectIndex:(NSInteger)index;
- (void)tabBar:(CustomTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end
