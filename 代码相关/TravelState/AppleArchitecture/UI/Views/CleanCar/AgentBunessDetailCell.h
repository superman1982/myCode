//
//  AgentBunessDetailCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BunessDetailProductInfo.h"

@interface AgentBunessDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *serviceName;

@property (strong, nonatomic) IBOutlet UILabel *vipPrice;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *returnMoney;
@property (strong, nonatomic) IBOutlet UITextView *serviceDesc;

@property (nonatomic,retain) BunessDetailProductInfo *bunessProductInfo;


-(void)setCell:(BunessDetailProductInfo *)aInfo;

@end
