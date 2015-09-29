//
//  BookHotelHouseCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveInfo.h"
#import "BookHotelHouseCell.h"

@protocol BookHotelHouseCellDelegate <NSObject>
-(void)BookHotelHouseCellDidSeleted:(BOOL)aIsCheck;
@end

@interface BookHotelHouseCell : UITableViewCell
@property (nonatomic,assign) BOOL isCheck;
//房差
@property (retain, nonatomic) IBOutlet UILabel *lodgingMoney;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (nonatomic,assign) id<BookHotelHouseCellDelegate> delegate;

@property (nonatomic,retain) ActiveInfo *activeInfo;

- (IBAction)checkButtonClicked:(UIButton *)sender ;

@end
