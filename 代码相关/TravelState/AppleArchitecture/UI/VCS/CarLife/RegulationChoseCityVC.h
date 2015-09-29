//
//  RegulationChoseCityVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegulationChoseCityVCDelegate <NSObject>

-(void)didRegulationChoseCityVCSelected:(id)sender;

@end

@interface RegulationChoseCityVC : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *RegulationChoseCityVCTableView;
@property (nonatomic,retain) NSMutableArray *cityInfoArray;

@property (nonatomic,retain) id delegate;

@end
