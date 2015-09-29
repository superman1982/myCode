//
//  MyRouteOrderDetailVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRouteOrderDetailVC : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *MyRouteOrderDetailTableView;

@property (nonatomic,retain) id activityId;
@property (nonatomic,retain) NSString *routeImageURLStr;

#pragma mark 初始化网络请求
-(void)initWebData;
@end
