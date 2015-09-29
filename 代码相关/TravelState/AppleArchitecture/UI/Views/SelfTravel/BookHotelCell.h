//
//  BookHotelCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookHotelCell : UITableViewCell

//单人间还是双人间
@property (retain, nonatomic) IBOutlet UILabel *peopleNumberLable;
//订房数量
@property (retain, nonatomic) IBOutlet UILabel *houseNumberLable;
//房间价格
@property (retain, nonatomic) IBOutlet UILabel *housePriceLable;
//是否是单人间
@property (nonatomic,assign) BOOL isSingleRoom;
//默认房间数量
@property (nonatomic,assign) NSInteger houseNumber;
//房间价格
@property (nonatomic,assign) NSInteger housePrice;

@property (nonatomic,assign) BOOL isChecked;

-(void)setCell:(NSDictionary *)aDic;
@end
