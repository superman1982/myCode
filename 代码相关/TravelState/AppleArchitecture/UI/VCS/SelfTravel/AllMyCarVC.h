//
//  AllMyCarVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-15.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllMyCarVCDelegate <NSObject>

-(void)didAllMyCarVCSeleted:(id)sender;

@end
@interface AllMyCarVC : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *allMyCarTableView;

@property (nonatomic,assign)  id<AllMyCarVCDelegate>  delegate;

@end
