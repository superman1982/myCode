//
//  JiFenCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiFenCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *scoreId;
@property (retain, nonatomic) IBOutlet UILabel *scoreDate;
@property (retain, nonatomic) IBOutlet UILabel *desc;
@property (retain, nonatomic) IBOutlet UILabel *score;
-(void)setCell:(NSDictionary *)aDic;
@end
