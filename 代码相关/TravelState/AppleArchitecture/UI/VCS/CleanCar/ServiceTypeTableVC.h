//
//  ServiceTypeTableVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceTypeTableVCDelegate <NSObject>
-(void)didServiceTypeTableVCSelected:(SearchType)aType;
@end

@interface ServiceTypeTableVC : UIViewController

@property (nonatomic,assign)  id<ServiceTypeTableVCDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
