//
//  CleanCarDetailCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BunessDetailProductInfo.h"

@interface CleanCarDetailCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *serviceName;

@property (retain, nonatomic) IBOutlet UILabel *serviceDesc;

@property (retain, nonatomic) IBOutlet UILabel *vipPrice;

@property (retain, nonatomic) IBOutlet UILabel *price;

@property (retain, nonatomic) IBOutlet UILabel *returnMoney;

-(void)setCell:(BunessDetailProductInfo *)aInfo;
@end
