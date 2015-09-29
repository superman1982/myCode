//
//  UpGrandVipCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpGrandVipCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *cardMame;
@property (retain, nonatomic) IBOutlet UILabel *cardMoney;
@property (retain, nonatomic) IBOutlet UIImageView *cardBackImageView;

-(void)setCell:(NSDictionary *)aDic;
@end

