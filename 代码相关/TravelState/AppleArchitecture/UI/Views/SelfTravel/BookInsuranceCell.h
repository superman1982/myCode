//
//  BookInsuranceCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookInsuranceCellDelegate <NSObject>
-(void)didBookInsuranceCellChanged:(id)sender;
@end

@interface BookInsuranceCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *numberOfInuranceLable;
//保险数量
@property (nonatomic,assign) NSInteger numberOfInurance;
//保险价格
@property (nonatomic,assign) NSInteger inurancePrice;
@property (retain, nonatomic) IBOutlet UILabel *insurancePriceLable;

@property (nonatomic,assign) id<BookInsuranceCellDelegate> delegate;

@end
