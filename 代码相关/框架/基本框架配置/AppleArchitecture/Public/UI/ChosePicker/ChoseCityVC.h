//
//  ChoseCityVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHSectionSelectionView.h"

@protocol ChoseCityVCDelegate <NSObject>

-(void)didChosedPlace:(id)sender;
@end

@interface ChoseCityVC : BaseViewController<CHSectionSelectionViewDataSource, CHSectionSelectionViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *cityTableView;

@property (nonatomic,retain) id<ChoseCityVCDelegate> delegate;

-(void)dealWithData:(NSDictionary *)aCellDataDic Section:(NSArray *)aSection;
@end
