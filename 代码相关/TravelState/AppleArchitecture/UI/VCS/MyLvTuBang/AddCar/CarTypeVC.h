//
//  CarTypeVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarTypeVCDelegate <NSObject>
-(void)didCarTypeVCSelected:(id)sender;

@end

@interface CarTypeVC : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *carTypeTableView;
@property (nonatomic,retain)  id<CarTypeVCDelegate> delegate;

@end
