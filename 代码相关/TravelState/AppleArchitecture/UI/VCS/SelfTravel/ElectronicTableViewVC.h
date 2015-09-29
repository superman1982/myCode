//
//  ElectronicTableViewVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectronicTableViewVC : UITableViewController

@property (nonatomic,retain) NSMutableArray *routesInfoArray;

@property (retain, nonatomic) IBOutlet UIView *firstRowContentView;

@property (nonatomic,retain) NSDictionary *dayDataDic;

@property (nonatomic,assign) ActiveType   routesType;

@end
