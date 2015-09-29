//
//  DriveFriendsVC.h
//  CarServices
//
//  Created by klbest1 on 14-1-23.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CleanCarView.h"
#import "ServiceTypeTableVC.h"
#import "ShangJiaInfo.h"
#import "BunessDetailVC.h"

@protocol CleanCarVCDelegate <NSObject>

-(void)didCleanCarVCBack:(id)sender;

@end

@interface CleanCarVC : BaseViewController<CleanCarDelegate,ServiceTypeTableVCDelegate,BunessDetailVCDelegate>

@property (nonatomic,assign) id<CleanCarVCDelegate> delegate;
//选择不同的类型后加载不同的数据
-(void)typeSelected:(NSInteger )sender BunessName:(NSString *)aBunessName;
//重设列表大小
-(void)setTableFrame:(CGRect )aRect;
#pragma mark 进入商家详情页面
+(void)gotoBunessDetail:(SearchType )aSearchtype ShangJiaInfo:(ShangJiaInfo *)aInfo;

@end
 