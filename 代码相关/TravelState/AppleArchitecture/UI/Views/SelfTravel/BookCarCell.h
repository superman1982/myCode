//
//  BookCarCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCarCell : UITableViewCell
//车辆需求
@property (retain, nonatomic) IBOutlet UILabel *produceCarOrNeedCarLable;
//车辆品牌
@property (retain, nonatomic) IBOutlet UILabel *carBrandLable;
//车牌号
@property (retain, nonatomic) IBOutlet UILabel *carLisenceLable;
//可拼人数
@property (retain, nonatomic) IBOutlet UILabel *peopleNumberLable;
@end
