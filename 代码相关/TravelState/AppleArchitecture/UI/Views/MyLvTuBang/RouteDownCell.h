//
//  RouteDownCell.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteDownCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *firstLable;
@property (strong, nonatomic) IBOutlet UILabel *secondLable;
@property (strong, nonatomic) IBOutlet UILabel *thirdLable;
-(void)setCell:(NSDictionary *)aDic Section:(NSInteger)aSection Row:(NSInteger)aRow;
@end
