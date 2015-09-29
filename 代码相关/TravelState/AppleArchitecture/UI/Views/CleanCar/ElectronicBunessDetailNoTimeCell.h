//
//  ElectronicBunessDetailNoTimeCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BunessDetailProductInfo.h"

@protocol ElectronicBunessDetailNoTimeCellDelegate <NSObject>

-(void)didElectronicBunessDetailNoTimeCellOrderAmountChanged:(BunessDetailProductInfo *)aInfo;

@end
@interface ElectronicBunessDetailNoTimeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *servicePhoto;
@property (strong, nonatomic) IBOutlet UILabel *serviceName;
@property (strong, nonatomic) IBOutlet UILabel *vipPrice;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *returnMoney;
@property (strong, nonatomic) IBOutlet UILabel *serviceDesc;

@property (nonatomic,retain) BunessDetailProductInfo *bunessProductInfo;

@property (nonatomic,assign) id<ElectronicBunessDetailNoTimeCellDelegate> delegate;

@property (retain, nonatomic) IBOutlet UILabel *amoutLable;
-(void)setCell:(BunessDetailProductInfo *)aInfo;

@end
