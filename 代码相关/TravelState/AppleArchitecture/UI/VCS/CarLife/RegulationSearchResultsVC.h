//
//  RegulationSearchResultsVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegulationSearchResultsVC : BaseViewController

@property (nonatomic,retain) NSMutableArray *resultArray;
@property (nonatomic,retain) NSDictionary *resultDic;
@property (strong, nonatomic) IBOutlet UITableView *regulationSearchResultsVCTableView;

@end
