//
//  MakeCarCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MakeCarCellDelegate <NSObject>
-(void)clearOtherCheckButton;
-(void)didMakeCarCellChecked:(id)sender;
@end
@interface MakeCarCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *checkButton;
//是否选定
@property (nonatomic,retain)  NSNumber *isChecked;
//cell索引以便确定选定了第几个cell
@property (nonatomic,assign) NSInteger index;
//司机
@property (retain, nonatomic) IBOutlet UILabel *driver;
//电话号码
@property (retain, nonatomic) IBOutlet UILabel *phone;
//车牌号
@property (retain, nonatomic) IBOutlet UILabel *carBrand;
//车型
@property (retain, nonatomic) IBOutlet UILabel *carModel;
//可拼人数
@property (retain, nonatomic) IBOutlet UILabel *seatQuantity;


@property (nonatomic,assign) id<MakeCarCellDelegate> delegate;

-(void)clearCheck;
-(void)setCell:(NSDictionary *)aDic chosedIndex:(NSNumber *)aIndex;
@end
